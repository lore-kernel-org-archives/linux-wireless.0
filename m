Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab1JZPao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 11:30:44 -0400
Received: by faan17 with SMTP id n17so1656357faa.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 08:30:43 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com, patches@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: =?UTF-8?q?=5BPATCH=5D=20ath6kl=3A=20Fix=20compile=20error=20for=20ARM?=
Date: Wed, 26 Oct 2011 16:28:38 +0100
Message-Id: <1319642918-27076-1-git-send-email-sangwook.lee@linaro.org> (sfid-20111026_173053_800200_E80246AD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the compile error for ARM Platform.

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---

Compile errors come from ARM plaform:
In file included from drivers/net/wireless/ath/ath6kl/init.c:19:0:
include/linux/of.h: In function ‘of_property_read_u32_array’:
include/linux/of.h:249:10: error: ‘ENOSYS’ undeclared 

 drivers/net/wireless/ath/ath6kl/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 4c0c314..64975a9 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/moduleparam.h>
+#include <linux/errno.h>
 #include <linux/of.h>
 #include <linux/mmc/sdio_func.h>
 #include "core.h"
-- 
1.7.4.1

