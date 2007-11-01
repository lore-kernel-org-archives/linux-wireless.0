Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:52896 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbXKAVx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 17:53:26 -0400
Received: by an-out-0708.google.com with SMTP id b36so94653ana
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 14:53:25 -0700 (PDT)
Date: Thu, 1 Nov 2007 17:53:18 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 5/7] ath5k: Move OFDM timings into a helper routine
Message-ID: <20071101215318.GC4182@pogo> (sfid-20071101_215329_379036_FA6EA0FF)
References: <20071101043520.GC21987@pogo> <20071101043718.GD21987@pogo> <20071101043815.GE21987@pogo> <20071101043855.GF21987@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071101043855.GF21987@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

** Resending after checkpatch.pl.. 

This move the OFDM timings on ath5k_hw_reset() onto a helper,
ath5k_hw_write_ofdm_timings() to make code cleaner.

Changes to ath5k.h, hw.c
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/hw.c |   83 ++++++++++++++++++++++++++-------------
 1 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 3f78d20..1b9c4f0 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -458,6 +458,56 @@ void ath5k_hw_detach(struct ath5k_hw *ah)
  */
 
 /**
+ * ath5k_hw_write_ofdm_timings - set OFDM timings on AR5212
+ *
+ * @ah: the &struct ath5k_hw
+ * @channel: the currently set channel upon reset
+ *
+ * Write the OFDM timings for the AR5212 upon reset. This is a helper for
+ * ath5k_hw_reset(). This seems to tune the PLL a specified frequency
+ * depending on the bandwidth of the channel.
+ *
+ */
+static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
+	struct ieee80211_channel *channel)
+{
+	/* Get exponent and mantissa and set it */
+	u32 coef_scaled, coef_exp, coef_man,
+		ds_coef_exp, ds_coef_man, clock;
+
+	if (!(ah->ah_version == AR5K_AR5212) ||
+		!(channel->val & CHANNEL_OFDM))
+		BUG();
+
+	/* Seems there are two PLLs, one for baseband sampling and one
+	 * for tuning. Tuning basebands are 40 MHz or 80MHz when in
+	 * turbo. */
+	clock = channel->val & CHANNEL_TURBO ? 80 : 40;
+	coef_scaled = ((5 * (clock << 24)) / 2) /
+	channel->freq;
+
+	for (coef_exp = 31; coef_exp > 0; coef_exp--)
+		if ((coef_scaled >> coef_exp) & 0x1)
+			break;
+
+	if (!coef_exp)
+		return -EINVAL;
+
+	coef_exp = 14 - (coef_exp - 24);
+	coef_man = coef_scaled +
+		(1 << (24 - coef_exp - 1));
+	ds_coef_man = coef_man >> (24 - coef_exp);
+	ds_coef_exp = coef_exp - 16;
+
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
+		AR5K_PHY_TIMING_3_DSC_MAN, ds_coef_man);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
+		AR5K_PHY_TIMING_3_DSC_EXP, ds_coef_exp);
+
+	return 0;
+}
+
+/**
  * ath5k_hw_write_rate_duration - set rate duration during hw resets
  *
  * @ah: the &struct ath5k_hw
@@ -696,34 +746,11 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		 */
 
 		/* Write OFDM timings on 5212*/
-		if (ah->ah_version == AR5K_AR5212) {
-			if (channel->val & CHANNEL_OFDM) {
-				/* Get exponent and mantissa and set it */
-				u32 coef_scaled, coef_exp, coef_man,
-					ds_coef_exp, ds_coef_man, clock;
-
-				clock = channel->val & CHANNEL_TURBO ? 80 : 40;
-				coef_scaled = ((5 * (clock << 24)) / 2) /
-					channel->freq;
-
-				for (coef_exp = 31; coef_exp > 0; coef_exp--)
-					if ((coef_scaled >> coef_exp) & 0x1)
-						break;
-
-				if (!coef_exp)
-					return -EINVAL;
-
-				coef_exp = 14 - (coef_exp - 24);
-				coef_man = coef_scaled +
-					(1 << (24 - coef_exp - 1));
-				ds_coef_man = coef_man >> (24 - coef_exp);
-				ds_coef_exp = coef_exp - 16;
-
-				AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
-				    AR5K_PHY_TIMING_3_DSC_MAN, ds_coef_man);
-				AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
-				    AR5K_PHY_TIMING_3_DSC_EXP, ds_coef_exp);
-			}
+		if (ah->ah_version == AR5K_AR5212 &&
+			channel->val & CHANNEL_OFDM) {
+			ret = ath5k_hw_write_ofdm_timings(ah, channel);
+			if (ret)
+				return ret;
 		}
 
 		/*Enable/disable 802.11b mode on 5111
-- 
1.5.2.5

