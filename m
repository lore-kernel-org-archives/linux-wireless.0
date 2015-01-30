Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42176 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbbA3Ncp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:45 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgj-004FiR-1K
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:45 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 04/17] ath9k: Check early for multi-vif/STA conditions
Date: Fri, 30 Jan 2015 19:05:24 +0530
Message-Id: <1422624937-4810-5-git-send-email-sujith@msujith.org> (sfid-20150130_143253_429433_EBE991DB)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If multiple interfaces are active or there is no
associated station interface, bail out early and
return 1 so that mac80211 can proceed with the normal
suspend routine.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/wow.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 272c05c..1799a1d 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -209,29 +209,21 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 		goto fail_wow;
 	}
 
-	ath_cancel_work(sc);
-	ath_stop_ani(sc);
-
-	/*
-	 * none of the sta vifs are associated
-	 * and we are not currently handling multivif
-	 * cases, for instance we have to seperately
-	 * configure 'keep alive frame' for each
-	 * STA.
-	 */
-
-	if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
-		ath_dbg(common, WOW, "None of the STA vifs are associated\n");
+	if (sc->cur_chan->nvifs > 1) {
+		ath_dbg(common, WOW, "WoW for multivif is not yet supported\n");
 		ret = 1;
 		goto fail_wow;
 	}
 
-	if (sc->cur_chan->nvifs > 1) {
-		ath_dbg(common, WOW, "WoW for multivif is not yet supported\n");
+	if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
+		ath_dbg(common, WOW, "None of the STA vifs are associated\n");
 		ret = 1;
 		goto fail_wow;
 	}
 
+	ath_cancel_work(sc);
+	ath_stop_ani(sc);
+
 	ath9k_wow_map_triggers(sc, wowlan, &wow_triggers_enabled);
 
 	ath_dbg(common, WOW, "WoW triggers enabled 0x%x\n",
-- 
2.2.2

