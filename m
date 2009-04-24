Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:49363 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZDXTgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 15:36:00 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ar9170: handle otus' A-MPDU density definitions
Date: Fri, 24 Apr 2009 21:35:57 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904242135.57861.chunkeey@web.de> (sfid-20090424_213643_731367_9BD0F4EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otus uses slightly different set of "Minimum MPDU Start Spacing" values
than the 802.11n D2.0 specifies. (the whole table is shifted by one and
therefore the 16us spacing is not officially available!)

And while we're at it, we also initialize our MAC's density register.
So, this annoying _feature_ will not break TX A-MPDU later.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/hw.h b/drivers/net/wireless/ath/ar9170/hw.h
index 95bf812..3293e0f 100644
--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -207,6 +207,8 @@ enum ar9170_cmd {
 #define AR9170_MAC_REG_AC1_AC0_TXOP		(AR9170_MAC_REG_BASE + 0xB44)
 #define AR9170_MAC_REG_AC3_AC2_TXOP		(AR9170_MAC_REG_BASE + 0xB48)
 
+#define AR9170_MAC_REG_AMPDU_SET		(AR9170_MAC_REG_BASE + 0xba0)
+
 #define AR9170_MAC_REG_ACK_TABLE		(AR9170_MAC_REG_BASE + 0xC00)
 #define AR9170_MAC_REG_AMPDU_RX_THRESH		(AR9170_MAC_REG_BASE + 0xC50)
 
diff --git a/drivers/net/wireless/ath/ar9170/mac.c b/drivers/net/wireless/ath/ar9170/mac.c
index c8fa307..3332f6e 100644
--- a/drivers/net/wireless/ath/ar9170/mac.c
+++ b/drivers/net/wireless/ath/ar9170/mac.c
@@ -72,6 +72,24 @@ int ar9170_set_qos(struct ar9170 *ar)
 	return ar9170_regwrite_result();
 }
 
+static int ar9170_set_ampdu_density(struct ar9170 *ar, u8 mpdudensity)
+{
+	u32 val;
+
+	/* don't allow AMPDU density > 8us */
+	if (mpdudensity > 6)
+		return -EINVAL;
+
+	/* Watch out! Otus uses slightly different density values. */
+	val = 0x140a00 | (mpdudensity ? (mpdudensity + 1) : 0);
+
+	ar9170_regwrite_begin(ar);
+	ar9170_regwrite(AR9170_MAC_REG_AMPDU_SET, val);
+	ar9170_regwrite_finish();
+
+	return ar9170_regwrite_result();
+}
+
 int ar9170_init_mac(struct ar9170 *ar)
 {
 	ar9170_regwrite_begin(ar);
@@ -296,6 +314,11 @@ int ar9170_set_operating_mode(struct ar9170 *ar)
 	if (err)
 		return err;
 
+	/* set AMPDU density to 8us. */
+	err = ar9170_set_ampdu_density(ar, 6);
+	if (err)
+		return err;
+
 	ar9170_regwrite_begin(ar);
 
 	ar9170_regwrite(AR9170_MAC_REG_POWERMANAGEMENT, pm_mode);
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 1b60906..f297a6d 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -151,8 +151,8 @@ static struct ieee80211_channel ar9170_5ghz_chantable[] = {
 			  IEEE80211_HT_CAP_SGI_40 |			\
 			  IEEE80211_HT_CAP_DSSSCCK40 |			\
 			  IEEE80211_HT_CAP_SM_PS,			\
-	.ampdu_factor	= 3, /* ?? */					\
-	.ampdu_density	= 7, /* ?? */					\
+	.ampdu_factor	= 3,						\
+	.ampdu_density	= 6,						\
 	.mcs		= {						\
 		.rx_mask = { 0xFF, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, },	\
 	},								\
