Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:34684 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab0IUFys (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 01:54:48 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 22:54:41 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>
Subject: [PATCH 1/2] ath9k: Fix tx struck state with paprd
Date: Mon, 20 Sep 2010 22:54:46 -0700
Message-ID: <1285048487-16795-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paprd needs to be done only on active chains(not for all the chains
that hw can support). The paprd training frames which are sent
for inactive chains would be hanging on the hw queue without
getting transmitted and would make the connection so unstable.
This issue happens only with the hw which supports paprd cal(ar9003).

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8b327bc..a133878 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -270,6 +270,7 @@ static void ath_paprd_activate(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	struct ath_common *common = ath9k_hw_common(ah);
 	int chain;
 
 	if (!caldata || !caldata->paprd_done)
@@ -278,7 +279,7 @@ static void ath_paprd_activate(struct ath_softc *sc)
 	ath9k_ps_wakeup(sc);
 	ar9003_paprd_enable(ah, false);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(ah->caps.tx_chainmask & BIT(chain)))
+		if (!(common->tx_chainmask & BIT(chain)))
 			continue;
 
 		ar9003_paprd_populate_single_table(ah, caldata, chain);
@@ -300,6 +301,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 	struct ieee80211_supported_band *sband = &sc->sbands[band];
 	struct ath_tx_control txctl;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	struct ath_common *common = ath9k_hw_common(ah);
 	int qnum, ftype;
 	int chain_ok = 0;
 	int chain;
@@ -333,7 +335,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 	ath9k_ps_wakeup(sc);
 	ar9003_paprd_init_table(ah);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(ah->caps.tx_chainmask & BIT(chain)))
+		if (!(common->tx_chainmask & BIT(chain)))
 			continue;
 
 		chain_ok = 0;
-- 
1.7.0.4

