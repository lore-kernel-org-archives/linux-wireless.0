Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8500 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab2ESIoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 04:44:34 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 08/10] ath: do not update cycle counters with sleep mode results
Date: Sat, 19 May 2012 14:13:54 +0530
Message-ID: <1337417036-1431-8-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120519_104439_894306_936896C2)
In-Reply-To: <1337417036-1431-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337417036-1431-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the chip is waking up from sleep state, the cycle counters
might have incorrect readings. So it is better not to update those
readings with software counters.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3f79923..66ea3df 100644
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
1.7.10.2

