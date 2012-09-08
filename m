Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33327 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2IHBxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 21:53:23 -0400
Received: by qcro28 with SMTP id o28so128834qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 18:53:22 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 8 Sep 2012 09:53:22 +0800
Message-ID: <CAPgLHd_SyyDQBeFGRDfXJFn58sH8FWfHWKRqrBGOyoVbFf3u7Q@mail.gmail.com> (sfid-20120908_035348_173124_AD6E9EC5)
Subject: [PATCH v2] NFC: nfcwilink: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/nfc/nfcwilink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index e7fd493..1a47190 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -352,8 +352,6 @@ static long nfcwilink_receive(void *priv_data, struct sk_buff *skb)
 	struct nfcwilink *drv = priv_data;
 	int rc;
 
-	nfc_dev_dbg(&drv->pdev->dev, "receive entry, len %d", skb->len);
-
 	if (!skb)
 		return -EFAULT;
 
@@ -362,6 +360,8 @@ static long nfcwilink_receive(void *priv_data, struct sk_buff *skb)
 		return -EFAULT;
 	}
 
+	nfc_dev_dbg(&drv->pdev->dev, "receive entry, len %d", skb->len);
+
 	/* strip the ST header
 	(apart for the chnl byte, which is not received in the hdr) */
 	skb_pull(skb, (NFCWILINK_HDR_LEN-1));


