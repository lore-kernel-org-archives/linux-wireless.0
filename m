Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:40033 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380AbYGTDoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 23:44:05 -0400
Date: Sun, 20 Jul 2008 06:44:43 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 8/12] ath5k: Update channel functions
Message-ID: <20080720034443.GH7440@makis> (sfid-20080720_054408_836213_E4683F84)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add channel function for RF2425 (got this from decompiling binary HAL, i have no idea why there is a 5GHz section but i'm looking into it)
 * Update RF5112 channel function (also got this from decompiling binary HAL)
 * Set JAPAN setting for channel 14 on all PHY chips

 Changes-licensed-under: ISC
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 66af70b..cbc362d 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1898,9 +1898,6 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 	data = data0 = data1 = data2 = 0;
 	c = channel->center_freq;
 
-	/*
-	 * Set the channel on the RF5112 or newer
-	 */
 	if (c < 4800) {
 		if (!((c - 2224) % 5)) {
 			data0 = ((2 * (c - 704)) - 3040) / 10;
@@ -1912,7 +1909,7 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 			return -EINVAL;
 
 		data0 = ath5k_hw_bitswap((data0 << 2) & 0xff, 8);
-	} else {
+	} else if ((c - (c % 5)) != 2 || c > 5435) {
 		if (!(c % 20) && c >= 5120) {
 			data0 = ath5k_hw_bitswap(((c - 4800) / 20 << 2), 8);
 			data2 = ath5k_hw_bitswap(3, 2);
@@ -1924,6 +1921,9 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 			data2 = ath5k_hw_bitswap(1, 2);
 		} else
 			return -EINVAL;
+	} else {
+		data0 = ath5k_hw_bitswap((10 * (c - 2) - 4800) / 25 + 1, 8);
+		data2 = ath5k_hw_bitswap(0, 2);
 	}
 
 	data = (data0 << 4) | (data1 << 1) | (data2 << 2) | 0x1001;
@@ -1935,6 +1935,45 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 }
 
 /*
+ * Set the channel on the RF2425
+ */
+static int ath5k_hw_rf2425_channel(struct ath5k_hw *ah,
+		struct ieee80211_channel *channel)
+{
+	u32 data, data0, data2;
+	u16 c;
+
+	data = data0 = data2 = 0;
+	c = channel->center_freq;
+
+	if (c < 4800) {
+		data0 = ath5k_hw_bitswap((c - 2272), 8);
+		data2 = 0;
+	/* ? 5GHz ? */
+	} else if ((c - (c % 5)) != 2 || c > 5435) {
+		if (!(c % 20) && c < 5120)
+			data0 = ath5k_hw_bitswap(((c - 4800) / 20 << 2), 8);
+		else if (!(c % 10))
+			data0 = ath5k_hw_bitswap(((c - 4800) / 10 << 1), 8);
+		else if (!(c % 5))
+			data0 = ath5k_hw_bitswap((c - 4800) / 5, 8);
+		else
+			return -EINVAL;
+		data2 = ath5k_hw_bitswap(1, 2);
+	} else {
+		data0 = ath5k_hw_bitswap((10 * (c - 2) - 4800) / 25 + 1, 8);
+		data2 = ath5k_hw_bitswap(0, 2);
+	}
+
+	data = (data0 << 4) | data2 << 2 | 0x1001;
+
+	ath5k_hw_reg_write(ah, data & 0xff, AR5K_RF_BUFFER);
+	ath5k_hw_reg_write(ah, (data >> 8) & 0x7f, AR5K_RF_BUFFER_CONTROL_5);
+
+	return 0;
+}
+
+/*
  * Set a channel on the radio chip
  */
 int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
@@ -1963,6 +2002,9 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 	case AR5K_RF5111:
 		ret = ath5k_hw_rf5111_channel(ah, channel);
 		break;
+	case AR5K_RF2425:
+		ret = ath5k_hw_rf2425_channel(ah, channel);
+		break;
 	default:
 		ret = ath5k_hw_rf5112_channel(ah, channel);
 		break;
@@ -1971,6 +2013,15 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 	if (ret)
 		return ret;
 
+	/* Set JAPAN setting for channel 14 */
+	if (channel->center_freq == 2484) {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_CCKTXCTL,
+				AR5K_PHY_CCKTXCTL_JAPAN);
+	} else {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_CCKTXCTL,
+				AR5K_PHY_CCKTXCTL_WORLD);
+	}
+
 	ah->ah_current_channel.center_freq = channel->center_freq;
 	ah->ah_current_channel.hw_value = channel->hw_value;
 	ah->ah_turbo = channel->hw_value == CHANNEL_T ? true : false;

