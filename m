Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29956 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab1CKC4P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:52 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 07/20] ath6kl: remove-typedef AR6000_USER_SETKEYS_INFO
Date: Thu, 10 Mar 2011 18:55:34 -0800
Message-ID: <1299812147-12069-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR6000_USER_SETKEYS_INFO \
	"struct ar6000_user_setkeys_info" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
index 5a6c27e..66817c2 100644
--- a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
@@ -625,7 +625,7 @@ typedef enum {
  * arguments:
  * UINT32 cmd (AR6000_XIOCTL_USER_SETKEYS)
  * UINT32 keyOpCtrl
- * uses AR6000_USER_SETKEYS_INFO
+ * uses struct ar6000_user_setkeys_info
  */
 #define AR6000_XIOCTL_USER_SETKEYS                      58
 #endif /* USER_KEYS */
@@ -1098,10 +1098,9 @@ typedef struct targetStats_cmd_t {
 #define AR6000_XIOCTL_USER_SETKEYS_RSC_CTRL    1
 #define AR6000_USER_SETKEYS_RSC_UNCHANGED     0x00000002
 
-typedef struct {
+struct ar6000_user_setkeys_info {
     u32 keyOpCtrl;  /* Bit Map of Key Mgmt Ctrl Flags */
-} AR6000_USER_SETKEYS_INFO;
-
+}; /* XXX: unused !? */
 
 /* used by AR6000_XIOCTL_GPIO_OUTPUT_SET */
 struct ar6000_gpio_output_set_cmd_s {
-- 
1.7.4.15.g7811d

