Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54452 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbbA3Ncr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:47 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgk-004FiR-8l
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 05/17] ath9k: Check multi-channel context for WOW
Date: Fri, 30 Jan 2015 19:05:25 +0530
Message-Id: <1422624937-4810-6-git-send-email-sujith@msujith.org> (sfid-20150130_143251_314061_C7703A2B)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If CONFIG_ATH9K_CHANNEL_CONTEXT is enabled, check whether
multiple contexts are active and if so, return 1 without
enabling WOW since we don't support it in this case.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/wow.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 1799a1d..1b005c6 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -215,6 +215,15 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 		goto fail_wow;
 	}
 
+	if (ath9k_is_chanctx_enabled()) {
+		if (test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags)) {
+			ath_dbg(common, WOW,
+				"Multi-channel WOW is not supported\n");
+			ret = 1;
+			goto fail_wow;
+		}
+	}
+
 	if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
 		ath_dbg(common, WOW, "None of the STA vifs are associated\n");
 		ret = 1;
-- 
2.2.2

