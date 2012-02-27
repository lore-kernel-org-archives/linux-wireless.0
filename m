Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36039 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab2B0S6v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 13:58:51 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: [PATCH 3.3 2/4] ath9k: do not call ath9k_hw_txprocdesc on AR9003 outside of the tx tasklet
Date: Mon, 27 Feb 2012 19:58:40 +0100
Message-Id: <1330369122-60220-2-git-send-email-nbd@openwrt.org> (sfid-20120227_195854_841340_CE21E9AB)
In-Reply-To: <1330369122-60220-1-git-send-email-nbd@openwrt.org>
References: <1330369122-60220-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since AR9003 uses a global tx status queue, processing tx status outside of
the regular tx tasklet is dangerous and messes up hardware/software
synchronization of tx status events.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4a00806..8cbbc17 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2332,6 +2332,7 @@ static int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
 	struct ath_vif *avp;
 	struct ath_buf *bf;
 	struct ath_tx_status ts;
+	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int status;
 
 	vif = sc->beacon.bslot[0];
@@ -2342,7 +2343,7 @@ static int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
 	if (!avp->is_bslot_active)
 		return 0;
 
-	if (!sc->beacon.tx_processed) {
+	if (!sc->beacon.tx_processed && !edma) {
 		tasklet_disable(&sc->bcon_tasklet);
 
 		bf = avp->av_bcbuf;
-- 
1.7.3.2

