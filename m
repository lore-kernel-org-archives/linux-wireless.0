Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1DZKEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 06:04:36 -0400
Received: by wwa36 with SMTP id 36so496575wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 03:04:34 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH V3 1/2] wl12xx: consider encryption when configuring auto arp template
Date: Tue, 26 Apr 2011 13:04:47 +0300
Message-Id: <1303812288-9388-1-git-send-email-eliad@wizery.com> (sfid-20110426_120450_755200_9E43D14F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When configuring the arp response template, and encryption is enabled,
we should add some space and set the protected flag bit in the fc.

In order to track the encryption type, set wl->encryption_type when
setting an encryption key, and reconfigure the arp response.
Clear this field on wl1271_join, as keys have to be re-configured
anyway after a join command.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1 -> v2:
	don't configure template in ap mode
v2->v3:
	rename WL1271_TKIP_IV_SPACE to WL1271_EXTRA_SPACE_TKIP and some
	more style issues

 drivers/net/wireless/wl12xx/cmd.c          |   77 +++++++++++++++++++++-------
 drivers/net/wireless/wl12xx/main.c         |   21 +++++++-
 drivers/net/wireless/wl12xx/tx.c           |   11 ++--
 drivers/net/wireless/wl12xx/tx.h           |    4 +-
 drivers/net/wireless/wl12xx/wl12xx.h       |    4 ++
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    2 +-
 6 files changed, 92 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 2468044..54c3f28 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -742,28 +742,31 @@ out:
 
 int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
 {
-	int ret;
-	struct wl12xx_arp_rsp_template tmpl;
+	int ret, extra;
+	u16 fc;
+	struct sk_buff *skb;
+	struct wl12xx_arp_rsp_template *tmpl;
 	struct ieee80211_hdr_3addr *hdr;
 	struct arphdr *arp_hdr;
 
-	memset(&tmpl, 0, sizeof(tmpl));
+	skb = dev_alloc_skb(sizeof(*hdr) + sizeof(*tmpl) +
+			    WL1271_EXTRA_SPACE_MAX);
+	if (!skb) {
+		wl1271_error("failed to allocate buffer for arp rsp template");
+		return -ENOMEM;
+	}
 
-	/* mac80211 header */
-	hdr = &tmpl.hdr;
-	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
-					 IEEE80211_STYPE_DATA |
-					 IEEE80211_FCTL_TODS);
-	memcpy(hdr->addr1, wl->vif->bss_conf.bssid, ETH_ALEN);
-	memcpy(hdr->addr2, wl->vif->addr, ETH_ALEN);
-	memset(hdr->addr3, 0xff, ETH_ALEN);
+	skb_reserve(skb, sizeof(*hdr) + WL1271_EXTRA_SPACE_MAX);
+
+	tmpl = (struct wl12xx_arp_rsp_template *)skb_put(skb, sizeof(*tmpl));
+	memset(tmpl, 0, sizeof(tmpl));
 
 	/* llc layer */
-	memcpy(tmpl.llc_hdr, rfc1042_header, sizeof(rfc1042_header));
-	tmpl.llc_type = cpu_to_be16(ETH_P_ARP);
+	memcpy(tmpl->llc_hdr, rfc1042_header, sizeof(rfc1042_header));
+	tmpl->llc_type = cpu_to_be16(ETH_P_ARP);
 
 	/* arp header */
-	arp_hdr = &tmpl.arp_hdr;
+	arp_hdr = &tmpl->arp_hdr;
 	arp_hdr->ar_hrd = cpu_to_be16(ARPHRD_ETHER);
 	arp_hdr->ar_pro = cpu_to_be16(ETH_P_IP);
 	arp_hdr->ar_hln = ETH_ALEN;
@@ -771,13 +774,51 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
 	arp_hdr->ar_op = cpu_to_be16(ARPOP_REPLY);
 
 	/* arp payload */
-	memcpy(tmpl.sender_hw, wl->vif->addr, ETH_ALEN);
-	tmpl.sender_ip = ip_addr;
+	memcpy(tmpl->sender_hw, wl->vif->addr, ETH_ALEN);
+	tmpl->sender_ip = ip_addr;
+
+	/* encryption space */
+	switch (wl->encryption_type) {
+	case KEY_TKIP:
+		extra = WL1271_EXTRA_SPACE_TKIP;
+		break;
+	case KEY_AES:
+		extra = WL1271_EXTRA_SPACE_AES;
+		break;
+	case KEY_NONE:
+	case KEY_WEP:
+	case KEY_GEM:
+		extra = 0;
+		break;
+	default:
+		wl1271_warning("Unknown encryption type: %d",
+			       wl->encryption_type);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (extra) {
+		u8 *space = skb_push(skb, extra);
+		memset(space, 0, extra);
+	}
+
+	/* mac80211 header */
+	hdr = (struct ieee80211_hdr_3addr *)skb_push(skb, sizeof(*hdr));
+	memset(hdr, 0, sizeof(hdr));
+	fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA | IEEE80211_FCTL_TODS;
+	if (wl->encryption_type != KEY_NONE)
+		fc |= IEEE80211_FCTL_PROTECTED;
+
+	hdr->frame_control = cpu_to_le16(fc);
+	memcpy(hdr->addr1, wl->vif->bss_conf.bssid, ETH_ALEN);
+	memcpy(hdr->addr2, wl->vif->addr, ETH_ALEN);
+	memset(hdr->addr3, 0xff, ETH_ALEN);
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_ARP_RSP,
-				      &tmpl, sizeof(tmpl), 0,
+				      skb->data, skb->len, 0,
 				      wl->basic_rate);
-
+out:
+	dev_kfree_skb(skb);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7126506..75397ed 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1623,6 +1623,9 @@ static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		wl1271_info("JOIN while associated.");
 
+	/* clear encryption type */
+	wl->encryption_type = KEY_NONE;
+
 	if (set_assoc)
 		set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 
@@ -2196,6 +2199,17 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			wl1271_error("Could not add or replace key");
 			goto out_sleep;
 		}
+
+		/* reconfiguring arp response (data packet) */
+		if (wl->bss_type == BSS_TYPE_STA_BSS &&
+		    wl->encryption_type != key_type) {
+			wl->encryption_type = key_type;
+			ret = wl1271_cmd_build_arp_rsp(wl, wl->ip_addr);
+			if (ret < 0) {
+				wl1271_warning("build arp rsp failed: %d", ret);
+				goto out_sleep;
+			}
+		}
 		break;
 
 	case DISABLE_KEY:
@@ -2734,6 +2748,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 
 		if (bss_conf->arp_addr_cnt == 1 &&
 		    bss_conf->arp_filter_enabled) {
+			wl->ip_addr = addr;
 			/*
 			 * The template should have been configured only upon
 			 * association. however, it seems that the correct ip
@@ -2749,8 +2764,10 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			ret = wl1271_acx_arp_ip_filter(wl,
 				ACX_ARP_FILTER_ARP_FILTERING,
 				addr);
-		} else
+		} else {
+			wl->ip_addr = 0;
 			ret = wl1271_acx_arp_ip_filter(wl, 0, addr);
+		}
 
 		if (ret < 0)
 			goto out;
@@ -3520,7 +3537,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	};
 
 	/* The tx descriptor buffer and the TKIP space. */
-	wl->hw->extra_tx_headroom = WL1271_TKIP_IV_SPACE +
+	wl->hw->extra_tx_headroom = WL1271_EXTRA_SPACE_TKIP +
 		sizeof(struct wl1271_tx_hw_descr);
 
 	/* unit us */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 7a3339f..b3395f6 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -353,7 +353,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 
 	if (info->control.hw_key &&
 	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP)
-		extra = WL1271_TKIP_IV_SPACE;
+		extra = WL1271_EXTRA_SPACE_TKIP;
 
 	if (info->control.hw_key) {
 		bool is_wep;
@@ -688,8 +688,9 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	if (info->control.hw_key &&
 	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
 		int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		memmove(skb->data + WL1271_TKIP_IV_SPACE, skb->data, hdrlen);
-		skb_pull(skb, WL1271_TKIP_IV_SPACE);
+		memmove(skb->data + WL1271_EXTRA_SPACE_TKIP, skb->data,
+			hdrlen);
+		skb_pull(skb, WL1271_EXTRA_SPACE_TKIP);
 	}
 
 	wl1271_debug(DEBUG_TX, "tx status id %u skb 0x%p failures %u rate 0x%x"
@@ -825,9 +826,9 @@ void wl1271_tx_reset(struct wl1271 *wl)
 			    info->control.hw_key->cipher ==
 			    WLAN_CIPHER_SUITE_TKIP) {
 				int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-				memmove(skb->data + WL1271_TKIP_IV_SPACE,
+				memmove(skb->data + WL1271_EXTRA_SPACE_TKIP,
 					skb->data, hdrlen);
-				skb_pull(skb, WL1271_TKIP_IV_SPACE);
+				skb_pull(skb, WL1271_EXTRA_SPACE_TKIP);
 			}
 
 			info->status.rates[0].idx = -1;
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index fc7835c..c6efb5e 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -53,7 +53,9 @@
 #define TX_HW_RESULT_QUEUE_LEN_MASK      0xf
 
 #define WL1271_TX_ALIGN_TO 4
-#define WL1271_TKIP_IV_SPACE 4
+#define WL1271_EXTRA_SPACE_TKIP 4
+#define WL1271_EXTRA_SPACE_AES  8
+#define WL1271_EXTRA_SPACE_MAX  8
 
 /* Used for management frames and dummy packets */
 #define WL1271_TID_MGMT 7
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index fb2b79f..b36a406 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -556,6 +556,10 @@ struct wl1271 {
 	/* bands supported by this instance of wl12xx */
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
+	/* save the current encryption type for auto-arp config*/
+	u8 encryption_type;
+	__be32 ip_addr;
+
 	/* RX BA constraint value */
 	bool ba_support;
 	u8 ba_rx_bitmap;
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index 18fe542..71e29aa 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -134,7 +134,7 @@ struct wl12xx_qos_null_data_template {
 } __packed;
 
 struct wl12xx_arp_rsp_template {
-	struct ieee80211_hdr_3addr hdr;
+	/* not including ieee80211 header */
 
 	u8 llc_hdr[sizeof(rfc1042_header)];
 	__be16 llc_type;
-- 
1.7.0.4

