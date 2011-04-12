Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64365 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab1DLN7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:59:38 -0400
Received: by bwz15 with SMTP id 15so5384622bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:59:37 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wl12xx: consider encryption when configuring auto arp template
Date: Tue, 12 Apr 2011 16:59:38 +0300
Message-Id: <1302616779-29012-1-git-send-email-eliad@wizery.com>
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
 drivers/net/wireless/wl12xx/cmd.c          |   65 ++++++++++++++++++++-------
 drivers/net/wireless/wl12xx/main.c         |   18 +++++++-
 drivers/net/wireless/wl12xx/wl12xx.h       |    4 ++
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    2 +-
 4 files changed, 70 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 2468044..65bcecb 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -742,28 +742,30 @@ out:
 
 int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
 {
-	int ret;
-	struct wl12xx_arp_rsp_template tmpl;
+	int ret, extra = 0;
+	u16 fc;
+	struct sk_buff *skb;
+	struct wl12xx_arp_rsp_template *tmpl;
 	struct ieee80211_hdr_3addr *hdr;
 	struct arphdr *arp_hdr;
 
-	memset(&tmpl, 0, sizeof(tmpl));
+	skb = dev_alloc_skb(sizeof(*hdr) + sizeof(*tmpl) + 8);
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
+	skb_reserve(skb, sizeof(*hdr) + 8);
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
@@ -771,12 +773,41 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
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
+		extra = WL1271_TKIP_IV_SPACE;
+		break;
+	case KEY_AES:
+		extra = 8;
+		break;
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
+	dev_kfree_skb(skb);
+
 
 	return ret;
 }
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7126506..8ec80fe 100644
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
 
@@ -2196,6 +2199,16 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			wl1271_error("Could not add or replace key");
 			goto out_sleep;
 		}
+
+		/* reconfiguring arp response (data packet) */
+		if (wl->encryption_type != key_type) {
+			wl->encryption_type = key_type;
+			ret = wl1271_cmd_build_arp_rsp(wl, wl->ip_addr);
+			if (ret < 0) {
+				wl1271_warning("build arp rsp failed: %d", ret);
+				goto out_sleep;
+			}
+		}
 		break;
 
 	case DISABLE_KEY:
@@ -2734,6 +2747,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 
 		if (bss_conf->arp_addr_cnt == 1 &&
 		    bss_conf->arp_filter_enabled) {
+			wl->ip_addr = addr;
 			/*
 			 * The template should have been configured only upon
 			 * association. however, it seems that the correct ip
@@ -2749,8 +2763,10 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
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

