Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:9675 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3HLGh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 02:37:27 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MRE00A7VNPZCGN0@mailout3.samsung.com> for
 linux-wireless@vger.kernel.org; Mon, 12 Aug 2013 15:37:14 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Lauro Ramos Venancio' <lauro.venancio@openbossa.org>
Cc: 'Aloisio Almeida Jr' <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	'Thierry Escande' <thierry.escande@linux.intel.com>,
	Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/2] NFC: nfcsim: Staticize local symbols
Date: Mon, 12 Aug 2013 15:37:14 +0900
Message-id: <000101ce9726$61bd4b30$2537e190$@samsung.com> (sfid-20130812_083741_035967_9E02F2B7)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These local symbols are used only in this file.
Fix the following sparse warnings:

drivers/nfc/nfcsim.c:63:25: warning: symbol 'wq' was not declared. Should it be static?
drivers/nfc/nfcsim.c:484:12: warning: symbol 'nfcsim_init' was not declared. Should it be static?
drivers/nfc/nfcsim.c:525:13: warning: symbol 'nfcsim_exit' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/nfc/nfcsim.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index c5c30fb..9a53f13 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -60,7 +60,7 @@ struct nfcsim {
 static struct nfcsim *dev0;
 static struct nfcsim *dev1;
 
-struct workqueue_struct *wq;
+static struct workqueue_struct *wq;
 
 static void nfcsim_cleanup_dev(struct nfcsim *dev, u8 shutdown)
 {
@@ -481,7 +481,7 @@ static void nfcsim_free_device(struct nfcsim *dev)
 	kfree(dev);
 }
 
-int __init nfcsim_init(void)
+static int __init nfcsim_init(void)
 {
 	int rc;
 
@@ -522,7 +522,7 @@ exit:
 	return rc;
 }
 
-void __exit nfcsim_exit(void)
+static void __exit nfcsim_exit(void)
 {
 	nfcsim_cleanup_dev(dev0, 1);
 	nfcsim_cleanup_dev(dev1, 1);
-- 
1.7.10.4


