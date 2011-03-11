Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29936 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab1CKCzz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:55:55 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:33 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/20] staging: ath6kl: Cast variable to size_t to avoid compile warning
Date: Thu, 10 Mar 2011 18:55:28 -0800
Message-ID: <1299812147-12069-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Martinez Canillas <martinez.javier@gmail.com>

The min() macro does strict type-checking so use min_t() instead
to silence a compile warning.

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
index 67e6d5e..55b0633 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
@@ -360,7 +360,7 @@ int PSSendOps(void *arg)
         	status = 1;
         	goto complete;
     	}
-	len = min(firmware->size, MAX_BDADDR_FORMAT_LENGTH - 1);
+	len = min_t(size_t, firmware->size, MAX_BDADDR_FORMAT_LENGTH - 1);
 	memcpy(config_bdaddr, firmware->data, len);
 	config_bdaddr[len] = '\0';
 	write_bdaddr(hdev,config_bdaddr,BDADDR_TYPE_STRING);
-- 
1.7.4.15.g7811d

