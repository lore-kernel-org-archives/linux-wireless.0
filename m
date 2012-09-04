Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19801 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab2IDOEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 10:04:10 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 3/8] ath9k: Make use of ath_stop_ani wrapper
Date: Tue, 4 Sep 2012 19:33:34 +0530
Message-ID: <1346767419-12359-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120904_160413_795174_A964E236)
In-Reply-To: <1346767419-12359-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1346767419-12359-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Additionally it has a neat debug message informing us
that we are stopping the ANI algorithm.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8a2b04d..a0bdb4b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2260,7 +2260,7 @@ static int ath9k_suspend(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
-	del_timer_sync(&common->ani.timer);
+	ath_stop_ani(sc);
 	del_timer_sync(&sc->rx_poll_timer);
 
 	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
-- 
1.7.0.4

