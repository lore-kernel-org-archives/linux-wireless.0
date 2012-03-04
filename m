Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58905 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CDI4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:56:04 -0500
Received: by mail-we0-f174.google.com with SMTP id x9so1794100wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:56:04 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/11] wl12xx: avoid bug_on_recovery during fw switch
Date: Sun,  4 Mar 2012 10:55:54 +0200
Message-Id: <1330851355-24459-11-git-send-email-eliad@wizery.com> (sfid-20120304_095629_765253_61936644)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a flag to indicate we initiated a recovery work
on purpose, in order to avoid triggering BUG() (when
the bug_on_recovery module param was set).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    5 ++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 89bf9ea..3c966f2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1154,7 +1154,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x",
 		    wl->chip.fw_ver_str, wl1271_read32(wl, SCR_PAD4));
 
-	BUG_ON(bug_on_recovery);
+	BUG_ON(bug_on_recovery &&
+	       !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
 
 	/*
 	 * Advance security sequence number to overcome potential progress
@@ -2133,6 +2134,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 	if (wl12xx_need_fw_change(wl, vif_count, true)) {
 		wl12xx_force_active_psm(wl);
+		set_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags);
 		mutex_unlock(&wl->mutex);
 		wl1271_recovery_work(&wl->recovery_work);
 		return 0;
@@ -2317,6 +2319,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	WARN_ON(iter != wlvif);
 	if (wl12xx_need_fw_change(wl, vif_count, false)) {
 		wl12xx_force_active_psm(wl);
+		set_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags);
 		wl12xx_queue_recovery_work(wl);
 		cancel_recovery = false;
 	}
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b26b1be..6e13a30 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -260,6 +260,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_SOFT_GEMINI,
 	WL1271_FLAG_RECOVERY_IN_PROGRESS,
 	WL1271_FLAG_VIF_CHANGE_IN_PROGRESS,
+	WL1271_FLAG_INTENDED_FW_RECOVERY,
 };
 
 enum wl12xx_vif_flags {
-- 
1.7.6.401.g6a319

