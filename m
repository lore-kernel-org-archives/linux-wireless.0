Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:58898 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3IWJ4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 05:56:38 -0400
Received: by mail-bk0-f45.google.com with SMTP id mx11so1055358bkb.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Sep 2013 02:56:37 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 Sep 2013 17:56:36 +0800
Message-ID: <CAPgLHd-1S=MSjOeW3+SQyFW_W9JuNSxgD1YDWEyF_aOtU4BFeQ@mail.gmail.com> (sfid-20130923_115641_988178_B78489F2)
Subject: [PATCH] NFC: nfcsim: fix the error handle in nfcsim_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unregister/free NFC device and destroy_workqueue()
before return in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/nfc/nfcsim.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index 9a53f13..a4a2286 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -497,15 +497,13 @@ static int __init nfcsim_init(void)
 	dev0 = nfcsim_init_dev();
 	if (IS_ERR(dev0)) {
 		rc = PTR_ERR(dev0);
-		goto exit;
+		goto exit_init_dev0;
 	}
 
 	dev1 = nfcsim_init_dev();
 	if (IS_ERR(dev1)) {
-		kfree(dev0);
-
 		rc = PTR_ERR(dev1);
-		goto exit;
+		goto exit_init_dev1;
 	}
 
 	dev0->peer_dev = dev1;
@@ -513,11 +511,14 @@ static int __init nfcsim_init(void)
 
 	pr_debug("NFCsim " NFCSIM_VERSION " initialized\n");
 
-	rc = 0;
+	return 0;
+
+exit_init_dev1:
+	nfcsim_free_device(dev0);
+exit_init_dev0:
+	destroy_workqueue(wq);
 exit:
-	if (rc)
-		pr_err("Failed to initialize nfcsim driver (%d)\n",
-		       rc);
+	pr_err("Failed to initialize nfcsim driver (%d)\n", rc);
 
 	return rc;
 }

