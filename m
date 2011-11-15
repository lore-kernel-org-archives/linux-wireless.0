Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19842 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1KOGDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:03:14 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
CC: Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 06/18] ath9k: Add MCI interrupt to interrupt mask
Date: Tue, 15 Nov 2011 11:33:02 +0530
Message-ID: <1321336982-12591-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111115_070317_640537_3E4E2541)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e43c41c..90d35f2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -764,7 +764,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 		ATH9K_INT_BMISS |		\
 		ATH9K_INT_CST |			\
 		ATH9K_INT_TSFOOR |		\
-		ATH9K_INT_GENTIMER)
+		ATH9K_INT_GENTIMER |		\
+		ATH9K_INT_MCI)
 
 	struct ath_softc *sc = dev;
 	struct ath_hw *ah = sc->sc_ah;
@@ -1119,6 +1120,9 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		ah->imask |= ATH9K_INT_CST;
 
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+		ah->imask |= ATH9K_INT_MCI;
+
 	sc->sc_flags &= ~SC_OP_INVALID;
 	sc->sc_ah->is_monitoring = false;
 
-- 
1.7.0.4

