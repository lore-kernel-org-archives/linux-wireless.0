Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49654 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaAMQ0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 11:26:04 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm2so2428780wib.10
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 08:26:02 -0800 (PST)
Message-ID: <1389630351.2590.4.camel@canaries32-MCP7A> (sfid-20140113_172612_276646_614C200A)
Subject: [PATCH 5/6] staging: vt6656: sparse fixes: iwctl_giwgenie use
 memcpy.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Jan 2014 16:25:51 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

extra is in kernel space use memcpy.

sparse warning
iwctl.c:1595:42: warning: incorrect type in argument 1 (different address spaces)
iwctl.c:1595:42:    expected void [noderef] <asn:1>*to
iwctl.c:1595:42:    got char *extra

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index bf56877..3a68dfa 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1591,13 +1591,11 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 	wrq->length = 0;
 	if (pMgmt->wWPAIELen > 0) {
 		wrq->length = pMgmt->wWPAIELen;
-		if (pMgmt->wWPAIELen <= space) {
-			if (copy_to_user(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen)) {
-				ret = -EFAULT;
-			}
-		} else {
+
+		if (pMgmt->wWPAIELen <= space)
+			memcpy(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen);
+		else
 			ret = -E2BIG;
-		}
 	}
 	return ret;
 }
-- 
1.8.5.2

