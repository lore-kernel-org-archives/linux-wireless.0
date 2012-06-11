Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2160 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2FKMiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 08:38:20 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: fix btcoex duty cycle
Date: Mon, 11 Jun 2012 18:09:14 +0530
Message-ID: <1339418354-1843-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120611_143825_560033_39A21F36)
In-Reply-To: <1339418354-1843-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339418354-1843-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reset duty cycle before updating btcoex scheme. Otherwise duty cycle
  reaches max limit and never be reduced again
* Adjust duty cycle with proper BDR profile value

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index e53df86..5246067 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -120,6 +120,9 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
 	if (mci_hw->config & ATH_MCI_CONFIG_DISABLE_TUNING)
 		goto skip_tuning;
 
+	btcoex->duty_cycle = num_profile ? ath_mci_duty_cycle[num_profile] :
+					   ATH_BTCOEX_DEF_DUTY_CYCLE;
+
 	if (num_profile == 1) {
 		info = list_first_entry(&mci->info,
 					struct ath_mci_profile_info,
@@ -178,7 +181,7 @@ skip_tuning:
 	if (IS_CHAN_5GHZ(sc->sc_ah->curchan))
 		return;
 
-	btcoex->duty_cycle += (mci->num_bdr ? ATH_MCI_MAX_DUTY_CYCLE : 0);
+	btcoex->duty_cycle += (mci->num_bdr ? ATH_MCI_BDR_DUTY_CYCLE : 0);
 	if (btcoex->duty_cycle > ATH_MCI_MAX_DUTY_CYCLE)
 		btcoex->duty_cycle = ATH_MCI_MAX_DUTY_CYCLE;
 
-- 
1.7.10.4

