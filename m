Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23454 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0L2UCH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 15:02:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 12:01:50 -0800
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <simbwa@gmail.com>,
	<error27@gmail.com>, <devel@driverdev.osuosl.org>,
	Vipin Mehta <vmehta@atheros.com>
Subject: [PATCH] Staging: ath6kl: fix potential buffer overflow
Date: Wed, 29 Dec 2010 12:01:16 -0800
Message-ID: <1293652876-18594-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Phillip Simbwa <simbwa@gmail.com>

Off by one

Signed-off-by: Phillip Simbwa <simbwa at gmail dot com>
Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
index 0e298db..29b8ab4 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
@@ -360,8 +360,8 @@ int PSSendOps(void *arg)
         	status = 1;
         	goto complete;
     	}
-        len = (firmware->size > MAX_BDADDR_FORMAT_LENGTH)? MAX_BDADDR_FORMAT_LENGTH: firmware->size;
-	memcpy(config_bdaddr, firmware->data,len);
+	len = min(firmware->size, MAX_BDADDR_FORMAT_LENGTH - 1);
+	memcpy(config_bdaddr, firmware->data, len);
 	config_bdaddr[len] = '\0';
 	write_bdaddr(hdev,config_bdaddr,BDADDR_TYPE_STRING);
        	A_RELEASE_FIRMWARE(firmware);
-- 
1.6.3.3

