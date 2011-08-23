Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58247 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab1HWNfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 09:35:54 -0400
Received: by fxh19 with SMTP id 19so237986fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 06:35:53 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl12xx: increase psm_entry_retries
Date: Tue, 23 Aug 2011 16:37:02 +0300
Message-Id: <1314106622-7481-2-git-send-email-eliad@wizery.com> (sfid-20110823_153558_205669_F37E8D15)
In-Reply-To: <1314106622-7481-1-git-send-email-eliad@wizery.com>
References: <1314106622-7481-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In congested env, sometimes 5 psm entry retries are not enough.
Increase the retries count to 8.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 91fbebb..554104c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -236,7 +236,7 @@ static struct conf_drv_settings default_conf = {
 		.ps_poll_recovery_period     = 700,
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
 		.bet_max_consecutive         = 50,
-		.psm_entry_retries           = 5,
+		.psm_entry_retries           = 8,
 		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
 		.psm_entry_hangover_period   = 1,
-- 
1.7.6.401.g6a319

