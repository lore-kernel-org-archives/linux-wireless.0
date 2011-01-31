Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:45363 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab1AaHzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 02:55:37 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 23:55:17 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Fix memory leak due to failed PAPRD frames
Date: Mon, 31 Jan 2011 13:25:29 +0530
Message-ID: <1296460529-13669-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

free the skb's when the Tx of PAPRD frames fails and also add a debug
message indicating that.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 20c70ba..1447b55 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -331,6 +331,8 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_tx_control txctl;
 	int time_left;
 
@@ -348,8 +350,12 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 	init_completion(&sc->paprd_complete);
 	sc->paprd_pending = true;
 	txctl.paprd = BIT(chain);
-	if (ath_tx_start(hw, skb, &txctl) != 0)
+
+	if (ath_tx_start(hw, skb, &txctl) != 0) {
+		ath_dbg(common, ATH_DBG_XMIT, "PAPRD TX failed\n");
+		dev_kfree_skb_any(skb);
 		return false;
+	}
 
 	time_left = wait_for_completion_timeout(&sc->paprd_complete,
 			msecs_to_jiffies(ATH_PAPRD_TIMEOUT));
-- 
1.7.0.4

