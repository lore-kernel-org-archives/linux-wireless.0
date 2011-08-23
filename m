Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38180 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1HWOEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 10:04:41 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix PS wrappers in ath9k_set_coverage_class
Date: Tue, 23 Aug 2011 19:34:33 +0530
Message-ID: <1314108273-3787-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110823_160445_665429_0E3C4409)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

this callback is called during suspend/resume and also via iw command.
it configures parameters like sifs, slottime, acktimeout in
ath9k_hw_init_global_settings where few REG_READ, REG_RMW are also done
and hence the need for PS wrappers

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 781af25..2486f5c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2285,7 +2285,11 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 
 	mutex_lock(&sc->mutex);
 	ah->coverage_class = coverage_class;
+
+	ath9k_ps_wakeup(sc);
 	ath9k_hw_init_global_settings(ah);
+	ath9k_ps_restore(sc);
+
 	mutex_unlock(&sc->mutex);
 }
 
-- 
1.7.0.4

