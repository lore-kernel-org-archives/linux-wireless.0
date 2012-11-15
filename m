Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48697 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767858Ab2KOQ5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 11:57:38 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so829426bkw.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2012 08:57:37 -0800 (PST)
Message-ID: <1352998649.3367.3.camel@user64-MCP7A> (sfid-20121115_175742_156415_F8C5DE21)
Subject: [PATCH] staging: vt6656: iwctl_giwaplist() re warn: possible memory
 leak of 'qual'
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Nov 2012 16:57:29 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index a914d20..08557fa 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -655,9 +655,13 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 		return -EINVAL;
 
 	sock = kzalloc(sizeof(struct sockaddr) * IW_MAX_AP, GFP_KERNEL);
+	if (sock == NULL)
+		return -ENOMEM;
 	qual = kzalloc(sizeof(struct iw_quality) * IW_MAX_AP, GFP_KERNEL);
-	if (sock == NULL || qual == NULL)
+	if (qual == NULL) {
+		kfree(sock);
 		return -ENOMEM;
+	}
 
 	for (ii = 0, jj = 0; ii < MAX_BSS_NUM; ii++) {
 		if (!pBSS[ii].bActive)
-- 
1.7.10.4


