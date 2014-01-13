Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:64793 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaAMQXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 11:23:47 -0500
Received: by mail-we0-f170.google.com with SMTP id u57so6613499wes.29
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 08:23:46 -0800 (PST)
Message-ID: <1389630210.2590.3.camel@canaries32-MCP7A> (sfid-20140113_172355_153573_474564E7)
Subject: [PATCH 4/6] staging: vt6656: sparse fixes: iwctl_siwgenie use
 memcpy.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Jan 2014 16:23:30 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

extra is in kernel space replace copy_from_user with
memcpy with no need to error check.

We already know that extra is valid by error checking
on wrq->length.

sparse warning
iwctl.c:1567:53: warning: incorrect type in argument 2 (different address spaces)
iwctl.c:1567:53:    expected void const [noderef] <asn:1>*from
iwctl.c:1567:53:    got char *extra

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 058df65..bf56877 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1564,10 +1564,8 @@ int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 			goto out;
 		}
 		memset(pMgmt->abyWPAIE, 0, MAX_WPA_IE_LEN);
-		if (copy_from_user(pMgmt->abyWPAIE, extra, wrq->length)) {
-			ret = -EFAULT;
-			goto out;
-		}
+
+		memcpy(pMgmt->abyWPAIE, extra, wrq->length);
 		pMgmt->wWPAIELen = wrq->length;
 	} else {
 		memset(pMgmt->abyWPAIE, 0, MAX_WPA_IE_LEN);
-- 
1.8.5.2


