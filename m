Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33584 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbbHEQNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 12:13:48 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH v2 1/3] drivers: staging: wilc1000: use 'void' for no arguments functions
Date: Wed,  5 Aug 2015 21:43:00 +0530
Message-Id: <1438791182-9178-2-git-send-email-csgorentla@gmail.com> (sfid-20150805_181444_175112_C950B650)
In-Reply-To: <1438791182-9178-1-git-send-email-csgorentla@gmail.com>
References: <1438791182-9178-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added 'void' keyword in the paranthesis of function definitions, when
there are no arguments to the functions.  This fixes the checkpatch.pl
error - "Bad function definition 'function()' should probably be
function(void)".

---
 drivers/staging/wilc1000/linux_mon.c  | 2 +-
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index aa20421..123468a 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -558,7 +558,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
  *  @date	12 JUL 2012
  *  @version	1.0
  */
-int WILC_WFI_deinit_mon_interface()
+int WILC_WFI_deinit_mon_interface(void)
 {
 	bool rollback_lock = false;
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3e55a8a..0a8052e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -202,7 +202,7 @@ void printk_later(const char *format, ...)
 
 }
 
-void dump_logs()
+void dump_logs(void)
 {
 	if (DebugBuffer[0]) {
 		DebugBuffer[DEGUG_BUFFER_LENGTH] = 0;
@@ -216,7 +216,7 @@ void dump_logs()
 	}
 }
 
-void Reset_WatchDogdebugger()
+void Reset_WatchDogdebugger(void)
 {
 	WatchDogdebuggerCounter = 0;
 }
-- 
2.5.0

