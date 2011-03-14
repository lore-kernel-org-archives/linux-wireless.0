Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20476 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab1CNR73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 10:59:06 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/38] ath6kl: remove-typedef HIF_MBOX_PROPERTIES
Date: Mon, 14 Mar 2011 10:58:45 -0700
Message-ID: <1300125552-24422-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
References: <1300125552-24422-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s HIF_MBOX_PROPERTIES \
	"struct hif_mbox_properties" drivers/staging/ath6kl/

Tested-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/include/hif.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/include/hif.h b/drivers/staging/ath6kl/include/hif.h
index 61e4392..4f9be8a 100644
--- a/drivers/staging/ath6kl/include/hif.h
+++ b/drivers/staging/ath6kl/include/hif.h
@@ -223,10 +223,10 @@ typedef enum {
  * 
  */
 
-typedef struct {
+struct hif_mbox_properties {
     u32 ExtendedAddress;  /* extended address for larger writes */
     u32 ExtendedSize;
-} HIF_MBOX_PROPERTIES;
+};
 
 #define HIF_MBOX_FLAG_NO_BUNDLING   (1 << 0)   /* do not allow bundling over the mailbox */
 
@@ -240,7 +240,7 @@ struct hif_device_mbox_info {
                                    and ARRAY of 32-bit words */
     
         /* the following describe extended mailbox properties */
-    HIF_MBOX_PROPERTIES MboxProp[4];
+    struct hif_mbox_properties MboxProp[4];
         /* if the HIF supports the GMbox extended address region it can report it
          * here, some interfaces cannot support the GMBOX address range and not set this */
     u32 GMboxAddress;
-- 
1.7.4.15.g7811d

