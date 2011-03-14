Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43067 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab1CNQxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 12:53:39 -0400
Received: by eyx24 with SMTP id 24so1691778eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 09:53:38 -0700 (PDT)
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl12xx: update bet_max_consecutive
Date: Mon, 14 Mar 2011 18:53:10 +0200
Message-Id: <1300121590-27998-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow early termination of 50 consecutive beacons.

This value is the recommended one by the 12xx's system/RF team,
and tests show that power consumption is improved as expected.

Reported-by: Ruthy Zaphir <ruthyz@ti.com>
Tested-by: Danil Shalumov <danils@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8b3c8d1..4e6660d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -254,7 +254,7 @@ static struct conf_drv_settings default_conf = {
 		.ps_poll_threshold           = 10,
 		.ps_poll_recovery_period     = 700,
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
-		.bet_max_consecutive         = 10,
+		.bet_max_consecutive         = 50,
 		.psm_entry_retries           = 5,
 		.psm_exit_retries            = 255,
 		.psm_entry_nullfunc_retries  = 3,
-- 
1.7.1

