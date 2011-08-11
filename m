Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34961 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab1HKM2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 08:28:13 -0400
Received: by fxh19 with SMTP id 19so1622730fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 05:28:12 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: rename TX header formats
Date: Thu, 11 Aug 2011 15:07:14 +0200
Message-Id: <1313068036-13608-1-git-send-email-zajec5@gmail.com> (sfid-20110811_142817_581893_D951DB81)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace "old" and "new" with number of the first firmware known to use
the given format.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/xmit.c |   24 ++++++++++++------------
 drivers/net/wireless/b43/xmit.h |    8 ++++----
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index b74f25e..36c7243 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -338,10 +338,10 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		}
 	}
 	if (b43_is_old_txhdr_format(dev)) {
-		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->old_format.plcp),
+		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->format_351.plcp),
 				      plcp_fragment_len, rate);
 	} else {
-		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->new_format.plcp),
+		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->format_410.plcp),
 				      plcp_fragment_len, rate);
 	}
 	b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->plcp_fb),
@@ -433,10 +433,10 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 
 			if (b43_is_old_txhdr_format(dev)) {
 				cts = (struct ieee80211_cts *)
-					(txhdr->old_format.rts_frame);
+					(txhdr->format_351.rts_frame);
 			} else {
 				cts = (struct ieee80211_cts *)
-					(txhdr->new_format.rts_frame);
+					(txhdr->format_410.rts_frame);
 			}
 			ieee80211_ctstoself_get(dev->wl->hw, info->control.vif,
 						fragment_data, fragment_len,
@@ -448,10 +448,10 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 
 			if (b43_is_old_txhdr_format(dev)) {
 				rts = (struct ieee80211_rts *)
-					(txhdr->old_format.rts_frame);
+					(txhdr->format_351.rts_frame);
 			} else {
 				rts = (struct ieee80211_rts *)
-					(txhdr->new_format.rts_frame);
+					(txhdr->format_410.rts_frame);
 			}
 			ieee80211_rts_get(dev->wl->hw, info->control.vif,
 					  fragment_data, fragment_len,
@@ -463,9 +463,9 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 
 		/* Generate the PLCP headers for the RTS/CTS frame */
 		if (b43_is_old_txhdr_format(dev))
-			plcp = &txhdr->old_format.rts_plcp;
+			plcp = &txhdr->format_351.rts_plcp;
 		else
-			plcp = &txhdr->new_format.rts_plcp;
+			plcp = &txhdr->format_410.rts_plcp;
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)plcp,
 				      len, rts_rate);
 		plcp = &txhdr->rts_plcp_fb;
@@ -474,10 +474,10 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 
 		if (b43_is_old_txhdr_format(dev)) {
 			hdr = (struct ieee80211_hdr *)
-				(&txhdr->old_format.rts_frame);
+				(&txhdr->format_351.rts_frame);
 		} else {
 			hdr = (struct ieee80211_hdr *)
-				(&txhdr->new_format.rts_frame);
+				(&txhdr->format_410.rts_frame);
 		}
 		txhdr->rts_dur_fb = hdr->duration_id;
 
@@ -506,9 +506,9 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 
 	/* Magic cookie */
 	if (b43_is_old_txhdr_format(dev))
-		txhdr->old_format.cookie = cpu_to_le16(cookie);
+		txhdr->format_351.cookie = cpu_to_le16(cookie);
 	else
-		txhdr->new_format.cookie = cpu_to_le16(cookie);
+		txhdr->format_410.cookie = cpu_to_le16(cookie);
 
 	if (phy->type == B43_PHYTYPE_N) {
 		txhdr->phy_ctl1 =
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index 42debb5..79fc162 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -46,7 +46,7 @@ struct b43_txhdr {
 	__le32 timeout;			/* Timeout */
 
 	union {
-		/* The new r410 format. */
+		/* Tested with 410.2160, 478.104 and 508.* */
 		struct {
 			__le16 mimo_antenna;		/* MIMO antenna select */
 			__le16 preload_size;		/* Preload size */
@@ -57,9 +57,9 @@ struct b43_txhdr {
 			__u8 rts_frame[16];		/* The RTS frame (if used) */
 			PAD_BYTES(2);
 			struct b43_plcp_hdr6 plcp;	/* Main PLCP header */
-		} new_format __packed;
+		} format_410 __packed;
 
-		/* The old r351 format. */
+		/* Tested with 351.126 */
 		struct {
 			PAD_BYTES(2);
 			__le16 cookie;			/* TX frame cookie */
@@ -68,7 +68,7 @@ struct b43_txhdr {
 			__u8 rts_frame[16];		/* The RTS frame (if used) */
 			PAD_BYTES(2);
 			struct b43_plcp_hdr6 plcp;	/* Main PLCP header */
-		} old_format __packed;
+		} format_351 __packed;
 
 	} __packed;
 } __packed;
-- 
1.7.3.4

