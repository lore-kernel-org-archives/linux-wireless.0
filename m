Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45282 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2BOCoZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 21:44:25 -0500
Received: by mail-iy0-f174.google.com with SMTP id b35so764642iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 18:44:25 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix warning in debug.c
Date: Tue, 14 Feb 2012 20:44:15 -0600
Message-Id: <1329273855-15438-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120215_034452_312372_7C684983)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit e82912dc, compilation of rtlwifi has resulted in the following
warning:

In file included from drivers/net/wireless/rtlwifi/debug.c:31:0:
drivers/net/wireless/rtlwifi/wifi.h:33:0: warning: "pr_fmt" redefined [enabled by default]
include/linux/printk.h:152:0: note: this is the location of the previous definition

The fix is to ensure that wifi.h s included before any header files that pull in
printk.h.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This problem only occurs in wireless-testing, and not in mainline. Commit d273bb20
starts the problem.

Larry
---

 drivers/net/wireless/rtlwifi/debug.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/debug.c b/drivers/net/wireless/rtlwifi/debug.c
index 1d9b456..bdda9b2 100644
--- a/drivers/net/wireless/rtlwifi/debug.c
+++ b/drivers/net/wireless/rtlwifi/debug.c
@@ -26,8 +26,6 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *****************************************************************************/
 
-#include <linux/moduleparam.h>
-
 #include "wifi.h"
 
 #include <linux/moduleparam.h>
-- 
1.7.7

