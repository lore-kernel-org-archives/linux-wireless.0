Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53998 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1BRVOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:14:16 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 13:13:55 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH 12/15] staging: ath6kl: Fixing the cached copy of the BSS filter set by user
Date: Fri, 18 Feb 2011 13:13:13 -0800
Message-ID: <1298063596-2096-12-git-send-email-vmehta@atheros.com>
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing the cached copy of the BSS filter set by user.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index fe275c7..6d15d2d 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -2590,7 +2590,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                         != 0) {
                     ret = -EIO;
                 } else {
-                    ar->arUserBssFilter = param;
+                    ar->arUserBssFilter = filt.bssFilter;
                 }
             }
             break;
-- 
1.6.3.3

