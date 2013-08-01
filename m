Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab3HAKEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 06:04:09 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.11] iwl4965: set power mode early
Date: Thu,  1 Aug 2013 12:07:13 +0200
Message-Id: <1375351633-20123-1-git-send-email-sgruszka@redhat.com> (sfid-20130801_120413_488820_51AB1B20)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If device was put into a sleep and system was restarted or module
reloaded, we have to wake device up before sending other commands.
Otherwise it will fail to start with Microcode error.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index b9b2bb5..f0b7794 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5334,6 +5334,9 @@ il4965_alive_start(struct il_priv *il)
 
 	il->active_rate = RATES_MASK;
 
+	il_power_update_mode(il, true);
+	D_INFO("Updated power mode\n");
+
 	if (il_is_associated(il)) {
 		struct il_rxon_cmd *active_rxon =
 		    (struct il_rxon_cmd *)&il->active;
@@ -5364,9 +5367,6 @@ il4965_alive_start(struct il_priv *il)
 	D_INFO("ALIVE processing complete.\n");
 	wake_up(&il->wait_command_queue);
 
-	il_power_update_mode(il, true);
-	D_INFO("Updated power mode\n");
-
 	return;
 
 restart:
-- 
1.7.11.7

