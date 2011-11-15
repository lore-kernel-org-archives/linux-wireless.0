Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51628 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1KOGFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:05:49 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
CC: Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 16/18] ath9k: make ath_reset non-static
Date: Tue, 15 Nov 2011 11:35:40 +0530
Message-ID: <1321337140-12953-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111115_070558_191002_844E359C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

to be used by MCI specific changes

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9f28cc4..c04ff7d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -424,6 +424,7 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
 
 #define ATH_PAPRD_TIMEOUT	100 /* msecs */
 
+int ath_reset(struct ath_softc *sc, bool retry_tx);
 void ath_reset_work(struct work_struct *work);
 void ath_hw_check(struct work_struct *work);
 void ath_hw_pll_work(struct work_struct *work);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 90d35f2..c9578ab 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -959,7 +959,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_ps_restore(sc);
 }
 
-static int ath_reset(struct ath_softc *sc, bool retry_tx)
+int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	int r;
 
-- 
1.7.0.4

