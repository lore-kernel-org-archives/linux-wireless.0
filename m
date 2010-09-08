Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17130 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab0IHAGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 20:06:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Sep 2010 17:06:00 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <segooon@gmail.com>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <devel@driverdev.osuosl.org>
Subject: [PATCH] staging: ath6kl: Fixing a compilation error introduced by commit ec53d6123bea9f69887f194b5d4294a43292120d.
Date: Tue, 7 Sep 2010 17:06:50 -0700
Message-ID: <1283904410-32553-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index 8ed87e7..d5f7ac0 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -2713,7 +2713,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		break;
 	    }
 
-	    if (get_user(cmd.ieType, userdata))
+	    if (get_user(cmd.ieType, userdata)) {
 		ret = -EFAULT;
 		break;
 	    }
-- 
1.6.3.3

