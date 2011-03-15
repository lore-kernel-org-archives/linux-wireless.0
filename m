Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47528 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1COOZf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 10:25:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 07:25:12 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 3/4] ath9k_hw: Speedup register ops for HTC driver
Date: Tue, 15 Mar 2011 19:55:37 +0530
Message-ID: <1300199138-11851-3-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1300199138-11851-1-git-send-email-rmanoharan@atheros.com>
References: <1300199138-11851-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fine-tuning register write operation and avoid unnecessay
delays for ath9k_htc driver, saves hw reset time which
improves scanning time and also solves one of the following
scenario.

Sometimes the ACK is sent by STA for assoc response is not
seen at AP side. So the AP continues to send retry assoc
responses. At the STA side, since the assoc response was
already forwarded to mac80211, it proceeded to channel change
which in turns does chip reset.

In most of the cases the chip reset was completed before
max retries are reached at AP side. Hence STA can able to ACK
the retried frames again. But in clear environment these retries
are completed within shortspan of time.

Since ath9k_htc consumes more time for hw reset, this latency
is causing dissociation by AP due to max reties are reached.
This issue was originally reported with Cisco Aironet 1250 AP
in HT40 mode in noise free environment.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |    7 +++++--
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    7 +++++++
 drivers/net/wireless/ath/ath9k/hw.h         |   10 +++++++---
 drivers/net/wireless/ath/ath9k/phy.h        |    2 ++
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index ffcf44a..94acce5 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -729,6 +729,7 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 				 struct ath9k_channel *chan)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	struct ath_common *common = ath9k_hw_common(ah);
 	int i, regWrites = 0;
 	struct ieee80211_channel *channel = chan->chan;
 	u32 modesIndex, freqIndex;
@@ -805,7 +806,8 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 		REG_WRITE(ah, reg, val);
 
 		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->config.analog_shiftreg) {
+		    && ah->config.analog_shiftreg
+		    && (common->bus_ops->ath_bus_type != ATH_USB)) {
 			udelay(100);
 		}
 
@@ -835,7 +837,8 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 		REG_WRITE(ah, reg, val);
 
 		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->config.analog_shiftreg) {
+		    && ah->config.analog_shiftreg
+		    && (common->bus_ops->ath_bus_type != ATH_USB)) {
 			udelay(100);
 		}
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index fccd87d..995949d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -799,6 +799,8 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 							   pwr_table_offset,
 							   &diff);
 
+			ENABLE_REGWRITE_BUFFER(ah);
+
 			if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
 				if (OLC_FOR_AR9280_20_LATER) {
 					REG_WRITE(ah,
@@ -847,6 +849,7 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 
 				regOffset += 4;
 			}
+			REGWRITE_BUFFER_FLUSH(ah);
 		}
 	}
 
@@ -1205,6 +1208,8 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		}
 	}
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
 		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
 		  | ATH9K_POW_SM(ratesArray[rate12mb], 16)
@@ -1291,6 +1296,8 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
 		  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
 		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
+
+	REGWRITE_BUFFER_FLUSH(ah);
 }
 
 static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 072406c..c663216 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -105,18 +105,22 @@
 #define REG_CLR_BIT(_a, _r, _f) \
 	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~(_f))
 
-#define DO_DELAY(x) do {			\
-		if ((++(x) % 64) == 0)          \
-			udelay(1);		\
+#define DO_DELAY(x) do {					\
+		if (((++(x) % 64) == 0) &&			\
+		    (ath9k_hw_common(ah)->bus_ops->ath_bus_type	\
+			!= ATH_USB))				\
+			udelay(1);				\
 	} while (0)
 
 #define REG_WRITE_ARRAY(iniarray, column, regWr) do {                   \
 		int r;							\
+		ENABLE_REGWRITE_BUFFER(ah);				\
 		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
 			REG_WRITE(ah, INI_RA((iniarray), (r), 0),	\
 				  INI_RA((iniarray), r, (column)));	\
 			DO_DELAY(regWr);				\
 		}							\
+		REGWRITE_BUFFER_FLUSH(ah);				\
 	} while (0)
 
 #define AR_GPIO_OUTPUT_MUX_AS_OUTPUT             0
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 5e3d749..e402932 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -40,10 +40,12 @@
 
 #define REG_WRITE_RF_ARRAY(iniarray, regData, regWr) do {               \
 		int r;							\
+		ENABLE_REGWRITE_BUFFER(ah);				\
 		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
 			REG_WRITE(ah, INI_RA((iniarray), r, 0), (regData)[r]); \
 			DO_DELAY(regWr);				\
 		}							\
+		REGWRITE_BUFFER_FLUSH(ah);				\
 	} while (0)
 
 #define ANTSWAP_AB 0x0001
-- 
1.7.4.1

