Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50687 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759160AbYHFVYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 17:24:33 -0400
Date: Thu, 7 Aug 2008 00:23:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Michael Buesch <mb@bu3sch.de>, stefano.brivio@polimi.it,
	linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC: 2.6 patch] b43: the overdue firmware < 410 removal
Message-ID: <20080806212304.GC1702@cs181140183.pp.htv.fi> (sfid-20080806_232452_786538_5EA78804)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch contains the overdue removal of support for firmware
revision < 410.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |    9 ----
 drivers/net/wireless/b43/main.c            |    8 ---
 drivers/net/wireless/b43/xmit.c            |   45 ++++----------------
 drivers/net/wireless/b43/xmit.h            |   47 +++++----------------
 4 files changed, 22 insertions(+), 87 deletions(-)

d83c2534c5d33bc80203ef1480c0e6f7bb201313 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 77d5bed..e18e2d1 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -244,15 +244,6 @@ Who:	Jan Engelhardt <jengelh@computergmbh.de>
 
 ---------------------------
 
-What:	b43 support for firmware revision < 410
-When:	July 2008
-Why:	The support code for the old firmware hurts code readability/maintainability
-	and slightly hurts runtime performance. Bugfixes for the old firmware
-	are not provided by Broadcom anymore.
-Who:	Michael Buesch <mb@bu3sch.de>
-
----------------------------
-
 What:	init_mm export
 When:	2.6.26
 Why:	Not used in-tree. The current out-of-tree users used it to
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 3bf3a86..a655bb5 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2289,7 +2289,7 @@ static int b43_upload_microcode(struct b43_wldev *dev)
 	fwdate = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_UCODEDATE);
 	fwtime = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_UCODETIME);
 
-	if (fwrev <= 0x128) {
+	if (fwrev <= 351) {
 		b43err(dev->wl, "YOUR FIRMWARE IS TOO OLD. Firmware from "
 		       "binary drivers older than version 4.x is unsupported. "
 		       "You must upgrade your firmware files.\n");
@@ -2320,12 +2320,6 @@ static int b43_upload_microcode(struct b43_wldev *dev)
 		}
 	}
 
-	if (b43_is_old_txhdr_format(dev)) {
-		b43warn(dev->wl, "You are using an old firmware image. "
-			"Support for old firmware will be removed in July 2008.\n");
-		b43_print_fw_helptext(dev->wl, 0);
-	}
-
 	return 0;
 
 error:
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 9dda816..32b8acb 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -264,13 +264,8 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			     ARRAY_SIZE(txhdr->iv));
 		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
 	}
-	if (b43_is_old_txhdr_format(dev)) {
-		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->old_format.plcp),
-				      plcp_fragment_len, rate);
-	} else {
-		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->new_format.plcp),
-				      plcp_fragment_len, rate);
-	}
+	b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->new_format.plcp),
+			      plcp_fragment_len, rate);
 	b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->plcp_fb),
 			      plcp_fragment_len, rate_fb);
 
@@ -347,13 +342,8 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
 			struct ieee80211_cts *cts;
 
-			if (b43_is_old_txhdr_format(dev)) {
-				cts = (struct ieee80211_cts *)
-					(txhdr->old_format.rts_frame);
-			} else {
-				cts = (struct ieee80211_cts *)
-					(txhdr->new_format.rts_frame);
-			}
+			cts = (struct ieee80211_cts *)
+				(txhdr->new_format.rts_frame);
 			ieee80211_ctstoself_get(dev->wl->hw, info->control.vif,
 						fragment_data, fragment_len,
 						info, cts);
@@ -362,13 +352,8 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		} else {
 			struct ieee80211_rts *rts;
 
-			if (b43_is_old_txhdr_format(dev)) {
-				rts = (struct ieee80211_rts *)
-					(txhdr->old_format.rts_frame);
-			} else {
-				rts = (struct ieee80211_rts *)
-					(txhdr->new_format.rts_frame);
-			}
+			rts = (struct ieee80211_rts *)
+				(txhdr->new_format.rts_frame);
 			ieee80211_rts_get(dev->wl->hw, info->control.vif,
 					  fragment_data, fragment_len,
 					  info, rts);
@@ -378,23 +363,14 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		len += FCS_LEN;
 
 		/* Generate the PLCP headers for the RTS/CTS frame */
-		if (b43_is_old_txhdr_format(dev))
-			plcp = &txhdr->old_format.rts_plcp;
-		else
-			plcp = &txhdr->new_format.rts_plcp;
+		plcp = &txhdr->new_format.rts_plcp;
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)plcp,
 				      len, rts_rate);
 		plcp = &txhdr->rts_plcp_fb;
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)plcp,
 				      len, rts_rate_fb);
 
-		if (b43_is_old_txhdr_format(dev)) {
-			hdr = (struct ieee80211_hdr *)
-				(&txhdr->old_format.rts_frame);
-		} else {
-			hdr = (struct ieee80211_hdr *)
-				(&txhdr->new_format.rts_frame);
-		}
+		hdr = (struct ieee80211_hdr *) (&txhdr->new_format.rts_frame);
 		txhdr->rts_dur_fb = hdr->duration_id;
 
 		if (rts_rate_ofdm) {
@@ -413,10 +389,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	}
 
 	/* Magic cookie */
-	if (b43_is_old_txhdr_format(dev))
-		txhdr->old_format.cookie = cpu_to_le16(cookie);
-	else
-		txhdr->new_format.cookie = cpu_to_le16(cookie);
+	txhdr->new_format.cookie = cpu_to_le16(cookie);
 
 	/* Apply the bitfields */
 	txhdr->mac_ctl = cpu_to_le32(mac_ctl);
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index 0215faf..1447ce6 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -43,32 +43,18 @@ struct b43_txhdr {
 	__le16 mimo_ratelen_fb;		/* MIMO fallback rate length */
 	__le32 timeout;			/* Timeout */
 
-	union {
-		/* The new r410 format. */
-		struct {
-			__le16 mimo_antenna;		/* MIMO antenna select */
-			__le16 preload_size;		/* Preload size */
-			PAD_BYTES(2);
-			__le16 cookie;			/* TX frame cookie */
-			__le16 tx_status;		/* TX status */
-			struct b43_plcp_hdr6 rts_plcp;	/* RTS PLCP header */
-			__u8 rts_frame[16];		/* The RTS frame (if used) */
-			PAD_BYTES(2);
-			struct b43_plcp_hdr6 plcp;	/* Main PLCP header */
-		} new_format __attribute__ ((__packed__));
-
-		/* The old r351 format. */
-		struct {
-			PAD_BYTES(2);
-			__le16 cookie;			/* TX frame cookie */
-			__le16 tx_status;		/* TX status */
-			struct b43_plcp_hdr6 rts_plcp;	/* RTS PLCP header */
-			__u8 rts_frame[16];		/* The RTS frame (if used) */
-			PAD_BYTES(2);
-			struct b43_plcp_hdr6 plcp;	/* Main PLCP header */
-		} old_format __attribute__ ((__packed__));
-
-	} __attribute__ ((__packed__));
+	/* The new r410 format. */
+	struct {
+		__le16 mimo_antenna;		/* MIMO antenna select */
+		__le16 preload_size;		/* Preload size */
+		PAD_BYTES(2);
+		__le16 cookie;			/* TX frame cookie */
+		__le16 tx_status;		/* TX status */
+		struct b43_plcp_hdr6 rts_plcp;	/* RTS PLCP header */
+		__u8 rts_frame[16];		/* The RTS frame (if used) */
+		PAD_BYTES(2);
+		struct b43_plcp_hdr6 plcp;	/* Main PLCP header */
+	} new_format __attribute__ ((__packed__));
 } __attribute__ ((__packed__));
 
 /* MAC TX control */
@@ -158,18 +144,9 @@ struct b43_txhdr {
 #define  B43_TXH_PHY1_MODUL_QAM256	0x2000 /* QAM256 */
 
 
-/* r351 firmware compatibility stuff. */
-static inline
-bool b43_is_old_txhdr_format(struct b43_wldev *dev)
-{
-	return (dev->fw.rev <= 351);
-}
-
 static inline
 size_t b43_txhdr_size(struct b43_wldev *dev)
 {
-	if (b43_is_old_txhdr_format(dev))
-		return 100 + sizeof(struct b43_plcp_hdr6);
 	return 104 + sizeof(struct b43_plcp_hdr6);
 }
 

