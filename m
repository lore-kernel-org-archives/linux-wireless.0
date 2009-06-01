Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:58487 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbZFATls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 15:41:48 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RESEND][PATCH 3/4] ar9170: 40mhz fixes
Date: Mon, 1 Jun 2009 21:41:50 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
References: <200905120108.35995.chunkeey@web.de>
In-Reply-To: <200905120108.35995.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200906012141.50481.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replace a few constant magics which may affected
the device when operating in a 40MHz channel.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index 6ce2075..ffdb0c8 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -401,7 +401,7 @@ int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
 	int i, err;
 	u32 val;
 	bool is_2ghz = band == IEEE80211_BAND_2GHZ;
-	bool is_40mhz = false; /* XXX: for now */
+	bool is_40mhz = conf_is_ht40(&ar->hw->conf);
 
 	ar9170_regwrite_begin(ar);
 
@@ -1200,7 +1203,7 @@ int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		return -ENOSYS;
 	}
 
-	if (0 /* 2 streams capable */)
+	if (ar->eeprom.tx_mask != 1)
 		tmp |= 0x100;
 
 	err = ar9170_write_reg(ar, 0x1c5804, tmp);
@@ -1214,7 +1217,7 @@ int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 	freqpar = ar9170_get_hw_dyn_params(channel, bw);
 
 	vals[0] = cpu_to_le32(channel->center_freq * 1000);
-	vals[1] = cpu_to_le32(bw == AR9170_BW_20 ? 0 : 1);
+	vals[1] = cpu_to_le32(conf_is_ht40(&ar->hw->conf));
 	vals[2] = cpu_to_le32(offs << 2 | 1);
 	vals[3] = cpu_to_le32(freqpar->coeff_exp);
 	vals[4] = cpu_to_le32(freqpar->coeff_man);

