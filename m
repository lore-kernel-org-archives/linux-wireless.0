Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:35383 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab2DXCzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 22:55:55 -0400
Received: by dadz8 with SMTP id z8so273607dad.10
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 19:55:55 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, dcbw@redhat.com
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] libertas: include sched.h on firmware.c
Date: Mon, 23 Apr 2012 19:55:48 -0700
Message-Id: <1335236148-519-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20120424_045558_930058_2702C683)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Do not assume we have our subsystem including this for us,
at least for older kernels this is not true. Lets just be
explicit about this requirement for the usage of wake_up().

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/libertas/firmware.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/libertas/firmware.c b/drivers/net/wireless/libertas/firmware.c
index 77f6504..601f207 100644
--- a/drivers/net/wireless/libertas/firmware.c
+++ b/drivers/net/wireless/libertas/firmware.c
@@ -2,6 +2,7 @@
  * Firmware loading and handling functions.
  */
 
+#include <linux/sched.h>
 #include <linux/firmware.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
-- 
1.7.10.rc1.22.gf5241

