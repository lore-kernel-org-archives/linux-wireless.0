Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38738 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759099AbbA3Nco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:44 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgh-004FiR-Qd
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:44 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 03/17] ath9k: Remove redundant device_can_wakeup() check
Date: Fri, 30 Jan 2015 19:05:23 +0530
Message-Id: <1422624937-4810-4-git-send-email-sujith@msujith.org> (sfid-20150130_143249_688462_41B88EAC)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

WOW capability is registered with mac80211 only when
the device has the ability to wakeup, so there is no
need to check in the suspend() routine.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/wow.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 1d5cd88..272c05c 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -212,12 +212,6 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 	ath_cancel_work(sc);
 	ath_stop_ani(sc);
 
-	if (!device_can_wakeup(sc->dev)) {
-		ath_dbg(common, WOW, "device_can_wakeup failed, WoW is not enabled\n");
-		ret = 1;
-		goto fail_wow;
-	}
-
 	/*
 	 * none of the sta vifs are associated
 	 * and we are not currently handling multivif
-- 
2.2.2

