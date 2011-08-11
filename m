Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34961 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab1HKM2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 08:28:16 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so1622730fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 05:28:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: use enum for firmware header format
Date: Thu, 11 Aug 2011 15:07:15 +0200
Message-Id: <1313068036-13608-2-git-send-email-zajec5@gmail.com> (sfid-20110811_142819_748966_C2174535)
In-Reply-To: <1313068036-13608-1-git-send-email-zajec5@gmail.com>
References: <1313068036-13608-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h  |    8 ++++++
 drivers/net/wireless/b43/main.c |    6 +++-
 drivers/net/wireless/b43/xmit.c |   52 +++++++++++++++++++++++++++------------
 drivers/net/wireless/b43/xmit.h |   15 ++++------
 4 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 3aee322..e9f04ae 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -695,6 +695,11 @@ struct b43_firmware_file {
 	enum b43_firmware_file_type type;
 };
 
+enum b43_firmware_hdr_format {
+	B43_FW_HDR_410,
+	B43_FW_HDR_351,
+};
+
 /* Pointers to the firmware data and meta information about it. */
 struct b43_firmware {
 	/* Microcode */
@@ -711,6 +716,9 @@ struct b43_firmware {
 	/* Firmware patchlevel */
 	u16 patch;
 
+	/* Format of header used by firmware */
+	enum b43_firmware_hdr_format hdr_format;
+
 	/* Set to true, if we are using an opensource firmware.
 	 * Use this to check for proprietary vs opensource. */
 	bool opensource;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index d2661aa..fa05f00 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2510,6 +2510,10 @@ static int b43_upload_microcode(struct b43_wldev *dev)
 	}
 	dev->fw.rev = fwrev;
 	dev->fw.patch = fwpatch;
+	if (dev->fw.rev >= 410)
+		dev->fw.hdr_format = B43_FW_HDR_410;
+	else
+		dev->fw.hdr_format = B43_FW_HDR_351;
 	dev->fw.opensource = (fwdate == 0xFFFF);
 
 	/* Default to use-all-queues. */
@@ -2557,7 +2561,7 @@ static int b43_upload_microcode(struct b43_wldev *dev)
 			dev->fw.rev, dev->fw.patch);
 	wiphy->hw_version = dev->dev->core_id;
 
-	if (b43_is_old_txhdr_format(dev)) {
+	if (dev->fw.hdr_format == B43_FW_HDR_351) {
 		/* We're over the deadline, but we keep support for old fw
 		 * until it turns out to be in major conflict with something new. */
 		b43warn(dev->wl, "You are using an old firmware image. "
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 36c7243..5ce17d5 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -337,12 +337,15 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
 		}
 	}
-	if (b43_is_old_txhdr_format(dev)) {
+	switch (dev->fw.hdr_format) {
+	case B43_FW_HDR_351:
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->format_351.plcp),
 				      plcp_fragment_len, rate);
-	} else {
+		break;
+	case B43_FW_HDR_410:
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->format_410.plcp),
 				      plcp_fragment_len, rate);
+		break;
 	}
 	b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->plcp_fb),
 			      plcp_fragment_len, rate_fb);
@@ -415,10 +418,10 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	if ((rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
 	    (rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)) {
 		unsigned int len;
-		struct ieee80211_hdr *hdr;
+		struct ieee80211_hdr *uninitialized_var(hdr);
 		int rts_rate, rts_rate_fb;
 		int rts_rate_ofdm, rts_rate_fb_ofdm;
-		struct b43_plcp_hdr6 *plcp;
+		struct b43_plcp_hdr6 *uninitialized_var(plcp);
 		struct ieee80211_rate *rts_cts_rate;
 
 		rts_cts_rate = ieee80211_get_rts_cts_rate(dev->wl->hw, info);
@@ -429,14 +432,17 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
 
 		if (rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-			struct ieee80211_cts *cts;
+			struct ieee80211_cts *uninitialized_var(cts);
 
-			if (b43_is_old_txhdr_format(dev)) {
+			switch (dev->fw.hdr_format) {
+			case B43_FW_HDR_351:
 				cts = (struct ieee80211_cts *)
 					(txhdr->format_351.rts_frame);
-			} else {
+				break;
+			case B43_FW_HDR_410:
 				cts = (struct ieee80211_cts *)
 					(txhdr->format_410.rts_frame);
+				break;
 			}
 			ieee80211_ctstoself_get(dev->wl->hw, info->control.vif,
 						fragment_data, fragment_len,
@@ -444,14 +450,17 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			mac_ctl |= B43_TXH_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
-			struct ieee80211_rts *rts;
+			struct ieee80211_rts *uninitialized_var(rts);
 
-			if (b43_is_old_txhdr_format(dev)) {
+			switch (dev->fw.hdr_format) {
+			case B43_FW_HDR_351:
 				rts = (struct ieee80211_rts *)
 					(txhdr->format_351.rts_frame);
-			} else {
+				break;
+			case B43_FW_HDR_410:
 				rts = (struct ieee80211_rts *)
 					(txhdr->format_410.rts_frame);
+				break;
 			}
 			ieee80211_rts_get(dev->wl->hw, info->control.vif,
 					  fragment_data, fragment_len,
@@ -462,22 +471,29 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 		len += FCS_LEN;
 
 		/* Generate the PLCP headers for the RTS/CTS frame */
-		if (b43_is_old_txhdr_format(dev))
+		switch (dev->fw.hdr_format) {
+		case B43_FW_HDR_351:
 			plcp = &txhdr->format_351.rts_plcp;
-		else
+			break;
+		case B43_FW_HDR_410:
 			plcp = &txhdr->format_410.rts_plcp;
+			break;
+		}
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)plcp,
 				      len, rts_rate);
 		plcp = &txhdr->rts_plcp_fb;
 		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)plcp,
 				      len, rts_rate_fb);
 
-		if (b43_is_old_txhdr_format(dev)) {
+		switch (dev->fw.hdr_format) {
+		case B43_FW_HDR_351:
 			hdr = (struct ieee80211_hdr *)
 				(&txhdr->format_351.rts_frame);
-		} else {
+			break;
+		case B43_FW_HDR_410:
 			hdr = (struct ieee80211_hdr *)
 				(&txhdr->format_410.rts_frame);
+			break;
 		}
 		txhdr->rts_dur_fb = hdr->duration_id;
 
@@ -505,10 +521,14 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	}
 
 	/* Magic cookie */
-	if (b43_is_old_txhdr_format(dev))
+	switch (dev->fw.hdr_format) {
+	case B43_FW_HDR_351:
 		txhdr->format_351.cookie = cpu_to_le16(cookie);
-	else
+		break;
+	case B43_FW_HDR_410:
 		txhdr->format_410.cookie = cpu_to_le16(cookie);
+		break;
+	}
 
 	if (phy->type == B43_PHYTYPE_N) {
 		txhdr->phy_ctl1 =
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index 79fc162..a3ff727 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -166,19 +166,16 @@ struct b43_tx_legacy_rate_phy_ctl_entry {
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
+	switch (dev->fw.hdr_format) {
+	case B43_FW_HDR_410:
+		return 104 + sizeof(struct b43_plcp_hdr6);
+	case B43_FW_HDR_351:
 		return 100 + sizeof(struct b43_plcp_hdr6);
-	return 104 + sizeof(struct b43_plcp_hdr6);
+	}
+	return 0;
 }
 
 
-- 
1.7.3.4

