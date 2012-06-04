Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8864 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760006Ab2FDK7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 06:59:50 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20428.38113.996923.254437@gargle.gargle.HOWL> (sfid-20120604_132058_985227_C64AEE9C)
Date: Mon, 4 Jun 2012 16:28:41 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 18/20] ath: do not update cycle counters with sleep mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

When the chip is waking up from sleep state, the cycle counters
might have incorrect readings. So it is better not to update those
readings with software counters.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7777f43..b0790cd 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -101,6 +101,7 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
 		spin_lock(&common->cc_lock);
 		ath_hw_cycle_counters_update(common);
 		memset(&common->cc_survey, 0, sizeof(common->cc_survey));
+		memset(&common->cc_ani, 0, sizeof(common->cc_ani));
 		spin_unlock(&common->cc_lock);
 	}
 
-- 
1.7.10.3

