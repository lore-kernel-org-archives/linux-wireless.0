Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39880 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761333AbbA3Ncn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:43 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgg-004FiR-Ii
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:42 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 02/17] ath9k: Return early for error conditions
Date: Fri, 30 Jan 2015 19:05:22 +0530
Message-Id: <1422624937-4810-3-git-send-email-sujith@msujith.org> (sfid-20150130_143247_675123_23FE9DF4)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Do not try to cancel work instances and ANI when
the device is not present or WOW triggers are
not configured. Bail out early and use ath_err()
for such error conditions.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/wow.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 4ffaadd..1d5cd88 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -197,21 +197,21 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 
-	ath_cancel_work(sc);
-	ath_stop_ani(sc);
-
 	if (test_bit(ATH_OP_INVALID, &common->op_flags)) {
-		ath_dbg(common, ANY, "Device not present\n");
-		ret = -EINVAL;
+		ath_err(common, "Device not present\n");
+		ret = -ENODEV;
 		goto fail_wow;
 	}
 
 	if (WARN_ON(!wowlan)) {
-		ath_dbg(common, WOW, "None of the WoW triggers enabled\n");
+		ath_err(common, "None of the WoW triggers enabled\n");
 		ret = -EINVAL;
 		goto fail_wow;
 	}
 
+	ath_cancel_work(sc);
+	ath_stop_ani(sc);
+
 	if (!device_can_wakeup(sc->dev)) {
 		ath_dbg(common, WOW, "device_can_wakeup failed, WoW is not enabled\n");
 		ret = 1;
-- 
2.2.2

