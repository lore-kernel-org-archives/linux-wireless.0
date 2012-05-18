Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33422 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2EROHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 10:07:40 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 08/10] ath: do not update cycle counters with sleep mode results
Date: Fri, 18 May 2012 19:37:31 +0530
Message-ID: <1337350053-15491-8-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120518_160743_875228_A5B1BD75)
In-Reply-To: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
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

