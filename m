Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40705 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0IQXI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:08:27 -0400
Received: by bwz11 with SMTP id 11so3128503bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:08:26 -0700 (PDT)
Message-Id: <5cb2e8c6417605344a1ef9228a31182a3414c3f9.1284763835.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1284763834.git.chunkeey@googlemail.com>
References: <cover.1284763834.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 17 Sep 2010 22:42:37 +0200
Subject: [PATCH 3/7] carl9170: don't load bogus nf of chain 1
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to Atheros, chain 1 is not connected.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    2 +-
 drivers/net/wireless/ath/carl9170/debug.c    |    8 +++-----
 drivers/net/wireless/ath/carl9170/phy.c      |   11 +++++------
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 9f1d603..d43675a 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -321,7 +321,7 @@ struct ar9170 {
 
 	/* PHY */
 	struct ieee80211_channel *channel;
-	int noise[6];
+	int noise[4];
 	unsigned int chan_fail;
 	unsigned int total_chan_fail;
 	u8 heavy_clip;
diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 6559381..dbb35c3 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -437,12 +437,10 @@ static char *carl9170_debugfs_phy_noise_read(struct ar9170 *ar, char *buf,
 		return buf;
 	}
 
-	ADD(buf, *len, bufsize, "Chain 1: %10d dBm, ext. chan.:%10d dBm\n",
-	    ar->noise[1], ar->noise[4]);
+	ADD(buf, *len, bufsize, "Chain 0: %10d dBm, ext. chan.:%10d dBm\n",
+	    ar->noise[0], ar->noise[2]);
 	ADD(buf, *len, bufsize, "Chain 2: %10d dBm, ext. chan.:%10d dBm\n",
-	    ar->noise[2], ar->noise[5]);
-	ADD(buf, *len, bufsize, "Combined %10d dBm, ext. chan.:%10d dBm\n",
-	    ar->noise[0], ar->noise[3]);
+	    ar->noise[1], ar->noise[3]);
 
 	return buf;
 }
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index 7df8f71..fa349b8 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1566,9 +1566,8 @@ static int carl9170_calc_noise_dbm(u32 raw_noise)
 int carl9170_get_noisefloor(struct ar9170 *ar)
 {
 	static const u32 phy_regs[] = {
-		AR9170_PHY_REG_CCA, AR9170_PHY_REG_CH1_CCA,
-		AR9170_PHY_REG_CH2_CCA, AR9170_PHY_REG_EXT_CCA,
-		AR9170_PHY_REG_CH1_EXT_CCA, AR9170_PHY_REG_CH2_EXT_CCA };
+		AR9170_PHY_REG_CCA, AR9170_PHY_REG_CH2_CCA,
+		AR9170_PHY_REG_EXT_CCA, AR9170_PHY_REG_CH2_EXT_CCA };
 	u32 phy_res[ARRAY_SIZE(phy_regs)];
 	int err, i;
 
@@ -1578,12 +1577,12 @@ int carl9170_get_noisefloor(struct ar9170 *ar)
 	if (err)
 		return err;
 
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < 2; i++) {
 		ar->noise[i] = carl9170_calc_noise_dbm(
 			(phy_res[i] >> 19) & 0x1ff);
 
-		ar->noise[i + 3] = carl9170_calc_noise_dbm(
-			(phy_res[i + 3] >> 23) & 0x1ff);
+		ar->noise[i + 2] = carl9170_calc_noise_dbm(
+			(phy_res[i + 2] >> 23) & 0x1ff);
 	}
 
 	return 0;
-- 
1.7.1

