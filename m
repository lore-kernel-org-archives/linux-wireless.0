Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:35580 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320Ab3EGMHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 08:07:53 -0400
Received: by mail-bk0-f42.google.com with SMTP id j4so249676bkw.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 05:07:52 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 May 2013 20:07:52 +0800
Message-ID: <CAPgLHd98BDZihsvkMR-o6Z2y6QwPtXwEm9_7meXcLrjHcCDe7Q@mail.gmail.com> (sfid-20130507_140757_811053_2DE8DEF6)
Subject: [PATCH] NFC: pn533: fix error return code in pn533_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the nfc device alloc error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/nfc/pn533.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 8f6f2ba..0bdfa88 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -2783,8 +2783,10 @@ static int pn533_probe(struct usb_interface *interface,
 					   dev->ops->tx_header_len +
 					   PN533_CMD_DATAEXCH_HEAD_LEN,
 					   dev->ops->tx_tail_len);
-	if (!dev->nfc_dev)
+	if (!dev->nfc_dev) {
+		rc = -ENOMEM;
 		goto destroy_wq;
+	}
 
 	nfc_set_parent_dev(dev->nfc_dev, &interface->dev);
 	nfc_set_drvdata(dev->nfc_dev, dev);

