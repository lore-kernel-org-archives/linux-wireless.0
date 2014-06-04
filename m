Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18000 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaFDNra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:47:30 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 11/13] ath9k: Move caldata into channel context
Date: Wed, 4 Jun 2014 19:16:37 +0530
Message-ID: <1401889599-412-12-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154739_631329_6BE561A4)
In-Reply-To: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 4 ++--
 drivers/net/wireless/ath/ath9k/debug.c | 2 +-
 drivers/net/wireless/ath/ath9k/main.c  | 2 +-
 drivers/net/wireless/ath/ath9k/mci.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7634960..7776094 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -327,6 +327,8 @@ struct ath_chanctx {
 	struct list_head vifs;
 	struct list_head acq[IEEE80211_NUM_ACS];
 
+	struct ath9k_hw_cal_data caldata;
+
 	u16 txpower;
 	bool offchannel;
 	bool stopped;
@@ -822,8 +824,6 @@ struct ath_softc {
 	struct led_classdev led_cdev;
 #endif
 
-	struct ath9k_hw_cal_data caldata;
-
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath9k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 6cc42be..f230e2e9 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1080,7 +1080,7 @@ static ssize_t read_file_dump_nfcal(struct file *file, char __user *user_buf,
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath9k_nfcal_hist *h = sc->caldata.nfCalHist;
+	struct ath9k_nfcal_hist *h = sc->cur_chan->caldata.nfCalHist;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &common->hw->conf;
 	u32 len = 0, size = 1500;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2d619b7..fa9d915 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -288,7 +288,7 @@ int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 	if (!sc->cur_chan->offchannel) {
 		fastcc = false;
-		caldata = &sc->caldata;
+		caldata = &sc->cur_chan->caldata;
 	}
 
 	if (!hchan) {
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 313ed99..3f7a11e 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -706,7 +706,7 @@ void ath9k_mci_set_txpower(struct ath_softc *sc, bool setchannel,
 		return;
 
 	if (setchannel) {
-		struct ath9k_hw_cal_data *caldata = &sc->caldata;
+		struct ath9k_hw_cal_data *caldata = &sc->cur_chan->caldata;
 		if (IS_CHAN_HT40PLUS(ah->curchan) &&
 		    (ah->curchan->channel > caldata->channel) &&
 		    (ah->curchan->channel <= caldata->channel + 20))
-- 
2.0.0

