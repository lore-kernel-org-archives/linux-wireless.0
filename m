Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7362 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab1K2O45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 09:56:57 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Russell Hu <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 06/17] ath9k: Add MCI interrupt to interrupt mask
Date: Tue, 29 Nov 2011 20:25:27 +0530
Message-ID: <1322578538-18912-7-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111129_155700_270878_CD415751)
In-Reply-To: <1322578538-18912-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1322578538-18912-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
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

