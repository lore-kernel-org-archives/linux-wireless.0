Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31103 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0IRBOh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 21:14:37 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 18:14:31 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>, <randy.dunlap@oracle.com>
Subject: [PATCH] staging: ath6kl: Fixing a compile error
Date: Fri, 17 Sep 2010 18:14:33 -0700
Message-ID: <1284772473-13552-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit fixes a compilation error that was encountered while using
a specific kernel configuration file. The problem was the use of some
functions defined in <linux/semaphore.h> without including the header
file explicitly. It was probably working before because of the
dependency getting implicitly satisfied via some other header file.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index ef7cc82..fce6ceb 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -39,7 +39,7 @@
 #include <linux/timer.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
-
+#include <linux/semaphore.h>
 #include <linux/cache.h>
 
 #ifdef __GNUC__
-- 
1.6.3.3

