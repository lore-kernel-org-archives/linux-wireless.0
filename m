Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33926 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbcGUIPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 04:15:04 -0400
Received: by mail-pf0-f194.google.com with SMTP id g202so5051852pfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 01:15:03 -0700 (PDT)
From: Rajan Vaja <rajan.vaja@gmail.com>
To: j@w1.fi
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Subject: [PATCH] hostap: Use memdup_user() to reuse code
Date: Thu, 21 Jul 2016 13:44:44 +0530
Message-Id: <1469088884-28469-1-git-send-email-rajan.vaja@gmail.com> (sfid-20160721_101508_630035_666DBACD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix coccicheck warning which recommends to
use memdup_user() instead of reimplementing its
code.

This patch fixes below coccicheck warnings:

drivers/net/wireless/intersil/hostap/hostap_ioctl.c:3044:9-16: WARNING
opportunity for memdup_user
drivers/net/wireless/intersil/hostap/hostap_ioctl.c:3806:9-16: WARNING
opportunity for memdup_user

Signed-off-by: Rajan Vaja <rajan.vaja@gmail.com>
---
 drivers/net/wireless/intersil/hostap/hostap_ioctl.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
index 3e5fa78..a5656bc 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
@@ -3041,13 +3041,9 @@ static int prism2_ioctl_priv_download(local_info_t *local, struct iw_point *p)
 	    p->length > 1024 || !p->pointer)
 		return -EINVAL;
 
-	param = kmalloc(p->length, GFP_KERNEL);
-	if (param == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(param, p->pointer, p->length)) {
-		ret = -EFAULT;
-		goto out;
+	param = memdup_user(p->pointer, p->length);
+	if (IS_ERR(param)) {
+		return PTR_ERR(param);
 	}
 
 	if (p->length < sizeof(struct prism2_download_param) +
@@ -3803,13 +3799,9 @@ static int prism2_ioctl_priv_hostapd(local_info_t *local, struct iw_point *p)
 	    p->length > PRISM2_HOSTAPD_MAX_BUF_SIZE || !p->pointer)
 		return -EINVAL;
 
-	param = kmalloc(p->length, GFP_KERNEL);
-	if (param == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(param, p->pointer, p->length)) {
-		ret = -EFAULT;
-		goto out;
+	param = memdup_user(p->pointer, p->length);
+	if (IS_ERR(param)) {
+		return PTR_ERR(param);
 	}
 
 	switch (param->cmd) {
-- 
1.9.1

