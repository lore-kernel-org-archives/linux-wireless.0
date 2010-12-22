Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53525 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0LVLiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 06:38:54 -0500
Received: by wwa36 with SMTP id 36so5173977wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 03:38:53 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix some sparse warnings
Date: Wed, 22 Dec 2010 13:38:52 +0200
Message-Id: <1293017932-9806-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note that wl1271_write32() calls cpu_to_le32() by itself, so calling
wl1271_write32(addr, cpu_to_le32(val)) is in fact a bug on BE systems.

Fix the following sparse warnings:

drivers/net/wireless/wl12xx/cmd.c:662:16: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/cmd.c:662:16:    expected unsigned short [unsigned] [addressable] [usertype] llc_type
drivers/net/wireless/wl12xx/cmd.c:662:16:    got restricted __be16 [usertype] <noident>
drivers/net/wireless/wl12xx/cmd.c:674:17: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/cmd.c:674:17:    expected unsigned int [unsigned] [addressable] [usertype] sender_ip
drivers/net/wireless/wl12xx/cmd.c:674:17:    got restricted __be32 [usertype] ip_addr
drivers/net/wireless/wl12xx/rx.c:202:4: warning: incorrect type in argument 3 (different base types)
drivers/net/wireless/wl12xx/rx.c:202:4:    expected unsigned int [unsigned] [usertype] val
drivers/net/wireless/wl12xx/rx.c:202:4:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/wl12xx/acx.c:1247:23: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/acx.c:1247:23:    expected restricted __le32 [usertype] ht_capabilites
drivers/net/wireless/wl12xx/acx.c:1247:23:    got unsigned long
drivers/net/wireless/wl12xx/acx.c:1250:24: warning: invalid assignment: |=
drivers/net/wireless/wl12xx/acx.c:1250:24:    left side has type restricted __le32
drivers/net/wireless/wl12xx/acx.c:1250:24:    right side has type unsigned long
drivers/net/wireless/wl12xx/acx.c:1253:24: warning: invalid assignment: |=
drivers/net/wireless/wl12xx/acx.c:1253:24:    left side has type restricted __le32
drivers/net/wireless/wl12xx/acx.c:1253:24:    right side has type unsigned long
drivers/net/wireless/wl12xx/acx.c:1256:24: warning: invalid assignment: |=
drivers/net/wireless/wl12xx/acx.c:1256:24:    left side has type restricted __le32
drivers/net/wireless/wl12xx/acx.c:1256:24:    right side has type unsigned long

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c          |   13 +++++++------
 drivers/net/wireless/wl12xx/cmd.c          |    8 ++++----
 drivers/net/wireless/wl12xx/rx.c           |    3 +--
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    6 +++---
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index cc4068d..17f6a63 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1233,6 +1233,7 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 	struct wl1271_acx_ht_capabilities *acx;
 	u8 mac_address[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	int ret = 0;
+	u32 ht_capabilites = 0;
 
 	wl1271_debug(DEBUG_ACX, "acx ht capabilities setting");
 
@@ -1244,16 +1245,16 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 
 	/* Allow HT Operation ? */
 	if (allow_ht_operation) {
-		acx->ht_capabilites =
+		ht_capabilites =
 			WL1271_ACX_FW_CAP_HT_OPERATION;
 		if (ht_cap->cap & IEEE80211_HT_CAP_GRN_FLD)
-			acx->ht_capabilites |=
+			ht_capabilites |=
 				WL1271_ACX_FW_CAP_GREENFIELD_FRAME_FORMAT;
 		if (ht_cap->cap & IEEE80211_HT_CAP_SGI_20)
-			acx->ht_capabilites |=
+			ht_capabilites |=
 				WL1271_ACX_FW_CAP_SHORT_GI_FOR_20MHZ_PACKETS;
 		if (ht_cap->cap & IEEE80211_HT_CAP_LSIG_TXOP_PROT)
-			acx->ht_capabilites |=
+			ht_capabilites |=
 				WL1271_ACX_FW_CAP_LSIG_TXOP_PROTECTION;
 
 		/* get data from A-MPDU parameters field */
@@ -1261,10 +1262,10 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 		acx->ampdu_min_spacing = ht_cap->ampdu_density;
 
 		memcpy(acx->mac_address, mac_address, ETH_ALEN);
-	} else { /* HT operations are not allowed */
-		acx->ht_capabilites = 0;
 	}
 
+	acx->ht_capabilites = cpu_to_le32(ht_capabilites);
+
 	ret = wl1271_cmd_configure(wl, ACX_PEER_HT_CAP, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("acx ht capabilities setting failed: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 0106628..52a6bcd 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -659,15 +659,15 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr)
 
 	/* llc layer */
 	memcpy(tmpl.llc_hdr, rfc1042_header, sizeof(rfc1042_header));
-	tmpl.llc_type = htons(ETH_P_ARP);
+	tmpl.llc_type = cpu_to_be16(ETH_P_ARP);
 
 	/* arp header */
 	arp_hdr = &tmpl.arp_hdr;
-	arp_hdr->ar_hrd = htons(ARPHRD_ETHER);
-	arp_hdr->ar_pro = htons(ETH_P_IP);
+	arp_hdr->ar_hrd = cpu_to_be16(ARPHRD_ETHER);
+	arp_hdr->ar_pro = cpu_to_be16(ETH_P_IP);
 	arp_hdr->ar_hln = ETH_ALEN;
 	arp_hdr->ar_pln = 4;
-	arp_hdr->ar_op = htons(ARPOP_REPLY);
+	arp_hdr->ar_op = cpu_to_be16(ARPOP_REPLY);
 
 	/* arp payload */
 	memcpy(tmpl.sender_hw, wl->vif->addr, ETH_ALEN);
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 682304c..e855c86 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -198,6 +198,5 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 			pkt_offset += pkt_length;
 		}
 	}
-	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS,
-			cpu_to_le32(wl->rx_counter));
+	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 }
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index be21032..e2b26fb 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -138,13 +138,13 @@ struct wl12xx_arp_rsp_template {
 	struct ieee80211_hdr_3addr hdr;
 
 	u8 llc_hdr[sizeof(rfc1042_header)];
-	u16 llc_type;
+	__be16 llc_type;
 
 	struct arphdr arp_hdr;
 	u8 sender_hw[ETH_ALEN];
-	u32 sender_ip;
+	__be32 sender_ip;
 	u8 target_hw[ETH_ALEN];
-	u32 target_ip;
+	__be32 target_ip;
 } __packed;
 
 
-- 
1.7.0.4

