Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53985 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab1BRVOI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:14:08 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:13:47 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 05/15] staging: ath6kl: Fixing driver initialization for manufacturing mode
Date: Fri, 18 Feb 2011 13:13:06 -0800
Message-ID: <1298063596-2096-5-git-send-email-vmehta@atheros.com>
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing the driver initialization for manufacturing mode that involves
downloading a firmware binary meant for RF tests on the factory floor.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index df9badb..d907e93 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1806,7 +1806,9 @@ ar6000_avail_ev(void *context, void *hif_handle)
                     break;
                 }
 #ifdef HTC_RAW_INTERFACE
-                break; /* Don't call ar6000_init for ART */
+                if (!eppingtest && bypasswmi) {
+                    break; /* Don't call ar6000_init for ART */
+                }
 #endif 
                 rtnl_lock();
                 status = (ar6000_init(dev)==0) ? 0 : A_ERROR;
-- 
1.6.3.3

