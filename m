Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62309 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2AUQ0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 11:26:13 -0500
Received: by eekc14 with SMTP id c14so742495eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jan 2012 08:26:12 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 21 Jan 2012 16:59:10 +0100
Subject: [PATCH] carl9170: allow users to lower output power level
To: linux-wireless@vger.kernel.org
Cc: harshal@gmail.com, linville@tuxdriver.com
Message-Id: <E1RodlY-0007c9-Q7@debian64.daheim> (sfid-20120121_172617_614549_DB6AD55D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements a simple way of reducing the
output power of the device by a configurable upper
limit.

Requested-by: Harshal Chhaya <harshal@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/mac.c      |   35 +++++++++++++++++++++++++
 drivers/net/wireless/ath/carl9170/main.c     |   11 ++++---
 drivers/net/wireless/ath/carl9170/phy.c      |   36 ++++---------------------
 drivers/net/wireless/ath/carl9170/tx.c       |    2 +
 5 files changed, 50 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index f0f44c3..0cea20e 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -559,6 +559,7 @@ int carl9170_set_hwretry_limit(struct ar9170 *ar, const u32 max_retry);
 int carl9170_upload_key(struct ar9170 *ar, const u8 id, const u8 *mac,
 	const u8 ktype, const u8 keyidx, const u8 *keydata, const int keylen);
 int carl9170_disable_key(struct ar9170 *ar, const u8 id);
+int carl9170_set_mac_tpc(struct ar9170 *ar, struct ieee80211_channel *channel);
 
 /* RX */
 void carl9170_rx(struct ar9170 *ar, void *buf, unsigned int len);
diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index dfda919..53415bf 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -485,3 +485,38 @@ int carl9170_disable_key(struct ar9170 *ar, const u8 id)
 	return carl9170_exec_cmd(ar, CARL9170_CMD_DKEY,
 		sizeof(key), (u8 *)&key, 0, NULL);
 }
+
+int carl9170_set_mac_tpc(struct ar9170 *ar, struct ieee80211_channel *channel)
+{
+	unsigned int power, chains;
+
+	if (ar->eeprom.tx_mask != 1)
+		chains = AR9170_TX_PHY_TXCHAIN_2;
+	else
+		chains = AR9170_TX_PHY_TXCHAIN_1;
+
+	switch (channel->band) {
+	case IEEE80211_BAND_2GHZ:
+		power = ar->power_2G_ofdm[0] & 0x3f;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		power = ar->power_5G_leg[0] & 0x3f;
+		break;
+	default:
+		BUG_ON(1);
+	}
+
+	power = min_t(unsigned int, power, ar->hw->conf.power_level * 2);
+
+	carl9170_regwrite_begin(ar);
+	carl9170_regwrite(AR9170_MAC_REG_ACK_TPC,
+			  0x3c1e | power << 20 | chains << 26);
+	carl9170_regwrite(AR9170_MAC_REG_RTS_CTS_TPC,
+			  power << 5 | chains << 11 |
+			  power << 21 | chains << 27);
+	carl9170_regwrite(AR9170_MAC_REG_CFEND_QOSNULL_TPC,
+			  power << 5 | chains << 11 |
+			  power << 21 | chains << 27);
+	carl9170_regwrite_finish();
+	return carl9170_regwrite_result();
+}
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index d7a6104..f50ff29 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -853,11 +853,6 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out;
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		/* TODO */
-		err = 0;
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_SMPS) {
 		/* TODO */
 		err = 0;
@@ -891,6 +886,12 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out;
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		err = carl9170_set_mac_tpc(ar, ar->hw->conf.channel);
+		if (err)
+			goto out;
+	}
+
 out:
 	mutex_unlock(&ar->mutex);
 	return err;
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index 472efc7..b72c09c 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1426,15 +1426,15 @@ static void carl9170_calc_ctl(struct ar9170 *ar, u32 freq, enum carl9170_bw bw)
 #undef EDGES
 }
 
-static int carl9170_set_power_cal(struct ar9170 *ar, u32 freq,
-				  enum carl9170_bw bw)
+static void carl9170_set_power_cal(struct ar9170 *ar, u32 freq,
+				   enum carl9170_bw bw)
 {
 	struct ar9170_calibration_target_power_legacy *ctpl;
 	struct ar9170_calibration_target_power_ht *ctph;
 	u8 *ctpres;
 	int ntargets;
 	int idx, i, n;
-	u8 ackpower, ackchains, f;
+	u8 f;
 	u8 pwr_freqs[AR5416_MAX_NUM_TGT_PWRS];
 
 	if (freq < 3000)
@@ -1523,32 +1523,6 @@ static int carl9170_set_power_cal(struct ar9170 *ar, u32 freq,
 
 	/* calc. conformance test limits and apply to ar->power*[] */
 	carl9170_calc_ctl(ar, freq, bw);
-
-	/* set ACK/CTS TX power */
-	carl9170_regwrite_begin(ar);
-
-	if (ar->eeprom.tx_mask != 1)
-		ackchains = AR9170_TX_PHY_TXCHAIN_2;
-	else
-		ackchains = AR9170_TX_PHY_TXCHAIN_1;
-
-	if (freq < 3000)
-		ackpower = ar->power_2G_ofdm[0] & 0x3f;
-	else
-		ackpower = ar->power_5G_leg[0] & 0x3f;
-
-	carl9170_regwrite(AR9170_MAC_REG_ACK_TPC,
-			  0x3c1e | ackpower << 20 | ackchains << 26);
-	carl9170_regwrite(AR9170_MAC_REG_RTS_CTS_TPC,
-			  ackpower << 5 | ackchains << 11 |
-			  ackpower << 21 | ackchains << 27);
-
-	carl9170_regwrite(AR9170_MAC_REG_CFEND_QOSNULL_TPC,
-			  ackpower << 5 | ackchains << 11 |
-			  ackpower << 21 | ackchains << 27);
-
-	carl9170_regwrite_finish();
-	return carl9170_regwrite_result();
 }
 
 int carl9170_get_noisefloor(struct ar9170 *ar)
@@ -1712,7 +1686,9 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 	if (err)
 		return err;
 
-	err = carl9170_set_power_cal(ar, channel->center_freq, bw);
+	carl9170_set_power_cal(ar, channel->center_freq, bw);
+
+	err = carl9170_set_mac_tpc(ar, channel);
 	if (err)
 		return err;
 
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index d19a9ee..771e1a9 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -719,6 +719,8 @@ static void carl9170_tx_rate_tpc_chains(struct ar9170 *ar,
 		else
 			*chains = AR9170_TX_PHY_TXCHAIN_2;
 	}
+
+	*tpc = min_t(unsigned int, *tpc, ar->hw->conf.power_level * 2);
 }
 
 static __le32 carl9170_tx_physet(struct ar9170 *ar,
-- 
1.7.8.3

