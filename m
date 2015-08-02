Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33497 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbHBPzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 11:55:00 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 1/3] drivers: staging: wilc1000: use 'void' for no arguments functions
Date: Sun,  2 Aug 2015 21:23:51 +0530
Message-Id: <1438530833-24640-2-git-send-email-csgorentla@gmail.com> (sfid-20150802_175600_832850_A8F73EA6)
In-Reply-To: <1438530833-24640-1-git-send-email-csgorentla@gmail.com>
References: <1438530833-24640-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added 'void' keyword in the paranthesis of function definitions, when
there are no arguments to the functions.  This fixes the checkpatch.pl
error - "Bad function definition 'function()' should probably be
function(void)".

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c  | 2 +-
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index d812a3b..65d60af 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -567,7 +567,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
  *  @date	12 JUL 2012
  *  @version	1.0
  */
-int WILC_WFI_deinit_mon_interface()
+int WILC_WFI_deinit_mon_interface(void)
 {
 	bool rollback_lock = false;
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5a794df..443be4e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -215,7 +215,7 @@ void printk_later(const char *format, ...)
 }
 
 
-void dump_logs()
+void dump_logs(void)
 {
 	if (DebugBuffer[0]) {
 		DebugBuffer[DEGUG_BUFFER_LENGTH] = 0;
@@ -229,7 +229,7 @@ void dump_logs()
 	}
 }
 
-void Reset_WatchDogdebugger()
+void Reset_WatchDogdebugger(void)
 {
 	WatchDogdebuggerCounter = 0;
 }
-- 
2.5.0

