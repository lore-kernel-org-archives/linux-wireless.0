Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54855 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab2BBKWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 05:22:34 -0500
Received: by werb13 with SMTP id b13so1677869wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 02:22:33 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] wl12xx: consider encryption and QoS in auto arp template
Date: Thu,  2 Feb 2012 12:22:09 +0200
Message-Id: <1328178131-28938-2-git-send-email-eliad@wizery.com> (sfid-20120202_112239_220704_D151C115)
In-Reply-To: <1328178131-28938-1-git-send-email-eliad@wizery.com>
References: <1328178131-28938-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When configuring the arp response template,
and encryption is enabled, we should add some
space and set the protected flag bit in the fc.

In order to track the encryption type, set
wlvif->encryption_type when setting an encryption key,
and reconfigure the arp response. Clear this field on
wl1271_join, as keys have to be re-configured
anyway after a join command.

Similarly, track whether QoS is configured.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c          |   88 +++++++++++++++++++++------
 drivers/net/wireless/wl12xx/cmd.h          |    3 +-
 drivers/net/wireless/wl12xx/debugfs.c      |    1 +
 drivers/net/wireless/wl12xx/init.c         |    6 +-
 drivers/net/wireless/wl12xx/main.c         |   31 +++++++++-
 drivers/net/wireless/wl12xx/tx.c           |   11 ++--
 drivers/net/wireless/wl12xx/tx.h           |    4 +-
 drivers/net/wireless/wl12xx/wl12xx.h       |    6 ++
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    2 +-
 9 files changed, 117 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index bf3c37b..b776d9d 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1213,32 +1213,34 @@ out:
 	return skb;
 }
 
-int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			     __be32 ip_addr)
+int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
-	int ret;
+	int ret, extra;
+	u16 fc;
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
-	struct wl12xx_arp_rsp_template tmpl;
+	struct sk_buff *skb;
+	struct wl12xx_arp_rsp_template *tmpl;
 	struct ieee80211_hdr_3addr *hdr;
 	struct arphdr *arp_hdr;
 
-	memset(&tmpl, 0, sizeof(tmpl));
+	skb = dev_alloc_skb(sizeof(*hdr) + sizeof(__le16) + sizeof(*tmpl) +
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
-	memcpy(hdr->addr1, vif->bss_conf.bssid, ETH_ALEN);
-	memcpy(hdr->addr2, vif->addr, ETH_ALEN);
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
@@ -1246,13 +1248,59 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	arp_hdr->ar_op = cpu_to_be16(ARPOP_REPLY);
 
 	/* arp payload */
-	memcpy(tmpl.sender_hw, vif->addr, ETH_ALEN);
-	tmpl.sender_ip = ip_addr;
+	memcpy(tmpl->sender_hw, vif->addr, ETH_ALEN);
+	tmpl->sender_ip = wlvif->ip_addr;
+
+	/* encryption space */
+	switch (wlvif->encryption_type) {
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
+			       wlvif->encryption_type);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (extra) {
+		u8 *space = skb_push(skb, extra);
+		memset(space, 0, extra);
+	}
+
+	/* QoS header - BE */
+	if (wlvif->sta.qos)
+		memset(skb_push(skb, sizeof(__le16)), 0, sizeof(__le16));
+
+	/* mac80211 header */
+	hdr = (struct ieee80211_hdr_3addr *)skb_push(skb, sizeof(*hdr));
+	memset(hdr, 0, sizeof(hdr));
+	fc = IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS;
+	if (wlvif->sta.qos)
+		fc |= IEEE80211_STYPE_QOS_DATA;
+	else
+		fc |= IEEE80211_STYPE_DATA;
+	if (wlvif->encryption_type != KEY_NONE)
+		fc |= IEEE80211_FCTL_PROTECTED;
+
+	hdr->frame_control = cpu_to_le16(fc);
+	memcpy(hdr->addr1, vif->bss_conf.bssid, ETH_ALEN);
+	memcpy(hdr->addr2, vif->addr, ETH_ALEN);
+	memset(hdr->addr3, 0xff, ETH_ALEN);
 
 	ret = wl1271_cmd_template_set(wl, wlvif->role_id, CMD_TEMPL_ARP_RSP,
-				      &tmpl, sizeof(tmpl), 0,
+				      skb->data, skb->len, 0,
 				      wlvif->basic_rate);
-
+out:
+	dev_kfree_skb(skb);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 83a2a2e..de217d9 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -67,8 +67,7 @@ int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 					      struct wl12xx_vif *wlvif,
 					      struct sk_buff *skb);
-int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			     __be32 ip_addr);
+int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_build_qos_null_data(struct wl1271 *wl, struct ieee80211_vif *vif);
 int wl12xx_cmd_build_klv_null_data(struct wl1271 *wl,
 				   struct wl12xx_vif *wlvif);
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 1c26238..f063c70 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -579,6 +579,7 @@ static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
 			VIF_STATE_PRINT_INT(sta.basic_rate_idx);
 			VIF_STATE_PRINT_INT(sta.ap_rate_idx);
 			VIF_STATE_PRINT_INT(sta.p2p_rate_idx);
+			VIF_STATE_PRINT_INT(sta.qos);
 		} else {
 			VIF_STATE_PRINT_INT(ap.global_hlid);
 			VIF_STATE_PRINT_INT(ap.bcast_hlid);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index fcf2b12..acc0379 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -37,6 +37,7 @@
 int wl1271_init_templates_config(struct wl1271 *wl)
 {
 	int ret, i;
+	size_t max_size;
 
 	/* send empty templates for fw memory reservation */
 	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
@@ -89,10 +90,11 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	max_size = sizeof(struct wl12xx_arp_rsp_template) +
+		   WL1271_EXTRA_SPACE_MAX;
 	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
 				      CMD_TEMPL_ARP_RSP, NULL,
-				      sizeof
-				      (struct wl12xx_arp_rsp_template),
+				      max_size,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ce924e6..f22c8b1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2298,6 +2298,9 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		wl1271_info("JOIN while associated.");
 
+	/* clear encryption type */
+	wlvif->encryption_type = KEY_NONE;
+
 	if (set_assoc)
 		set_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags);
 
@@ -2955,6 +2958,21 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			wl1271_error("Could not add or replace key");
 			goto out_sleep;
 		}
+
+		/*
+		 * reconfiguring arp response if the unicast (or common)
+		 * encryption key type was changed
+		 */
+		if (wlvif->bss_type == BSS_TYPE_STA_BSS &&
+		    (sta || key_type == KEY_WEP) &&
+		    wlvif->encryption_type != key_type) {
+			wlvif->encryption_type = key_type;
+			ret = wl1271_cmd_build_arp_rsp(wl, wlvif);
+			if (ret < 0) {
+				wl1271_warning("build arp rsp failed: %d", ret);
+				goto out_sleep;
+			}
+		}
 		break;
 
 	case DISABLE_KEY:
@@ -3796,19 +3814,22 @@ sta_not_found:
 	if (ret < 0)
 		goto out;
 
-	if (changed & BSS_CHANGED_ARP_FILTER) {
+	if ((changed & BSS_CHANGED_ARP_FILTER) ||
+	    (!is_ibss && (changed & BSS_CHANGED_QOS))) {
 		__be32 addr = bss_conf->arp_addr_list[0];
+		wlvif->sta.qos = bss_conf->qos;
 		WARN_ON(wlvif->bss_type != BSS_TYPE_STA_BSS);
 
 		if (bss_conf->arp_addr_cnt == 1 &&
 		    bss_conf->arp_filter_enabled) {
+			wlvif->ip_addr = addr;
 			/*
 			 * The template should have been configured only upon
 			 * association. however, it seems that the correct ip
 			 * isn't being set (when sending), so we have to
 			 * reconfigure the template upon every ip change.
 			 */
-			ret = wl1271_cmd_build_arp_rsp(wl, wlvif, addr);
+			ret = wl1271_cmd_build_arp_rsp(wl, wlvif);
 			if (ret < 0) {
 				wl1271_warning("build arp rsp failed: %d", ret);
 				goto out;
@@ -3817,8 +3838,10 @@ sta_not_found:
 			ret = wl1271_acx_arp_ip_filter(wl, wlvif,
 				ACX_ARP_FILTER_ARP_FILTERING,
 				addr);
-		} else
+		} else {
+			wlvif->ip_addr = 0;
 			ret = wl1271_acx_arp_ip_filter(wl, wlvif, 0, addr);
+		}
 
 		if (ret < 0)
 			goto out;
@@ -4868,7 +4891,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	};
 
 	/* The tx descriptor buffer and the TKIP space. */
-	wl->hw->extra_tx_headroom = WL1271_TKIP_IV_SPACE +
+	wl->hw->extra_tx_headroom = WL1271_EXTRA_SPACE_TKIP +
 		sizeof(struct wl1271_tx_hw_descr);
 
 	/* unit us */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 1f5cc2a..6446e4d 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -386,7 +386,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	if (info->control.hw_key &&
 	    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP)
-		extra = WL1271_TKIP_IV_SPACE;
+		extra = WL1271_EXTRA_SPACE_TKIP;
 
 	if (info->control.hw_key) {
 		bool is_wep;
@@ -861,8 +861,9 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
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
@@ -1004,9 +1005,9 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
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
index 7ceb3ce..e3977b5 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -52,7 +52,9 @@
 #define TX_HW_RESULT_QUEUE_LEN_MASK      0xf
 
 #define WL1271_TX_ALIGN_TO 4
-#define WL1271_TKIP_IV_SPACE 4
+#define WL1271_EXTRA_SPACE_TKIP 4
+#define WL1271_EXTRA_SPACE_AES  8
+#define WL1271_EXTRA_SPACE_MAX  8
 
 /* Used for management frames and dummy packets */
 #define WL1271_TID_MGMT 7
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1463341..70b15b5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -502,6 +502,8 @@ struct wl12xx_vif {
 			u8 basic_rate_idx;
 			u8 ap_rate_idx;
 			u8 p2p_rate_idx;
+
+			bool qos;
 		} sta;
 		struct {
 			u8 global_hlid;
@@ -568,6 +570,10 @@ struct wl12xx_vif {
 	int rssi_thold;
 	int last_rssi_event;
 
+	/* save the current encryption type for auto-arp config */
+	u8 encryption_type;
+	__be32 ip_addr;
+
 	/* RX BA constraint value */
 	bool ba_support;
 	bool ba_allowed;
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index 8f0ffaf..22b0bc9 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -117,7 +117,7 @@ struct wl12xx_ps_poll_template {
 } __packed;
 
 struct wl12xx_arp_rsp_template {
-	struct ieee80211_hdr_3addr hdr;
+	/* not including ieee80211 header */
 
 	u8 llc_hdr[sizeof(rfc1042_header)];
 	__be16 llc_type;
-- 
1.7.6.401.g6a319

