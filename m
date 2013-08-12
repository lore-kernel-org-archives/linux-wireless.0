Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:10247 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3HLGkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 02:40:05 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MRE00LWONSVNDG0@mailout3.samsung.com> for
 linux-wireless@vger.kernel.org; Mon, 12 Aug 2013 15:40:04 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: 'Lauro Ramos Venancio' <lauro.venancio@openbossa.org>
Cc: 'Aloisio Almeida Jr' <aloisio.almeida@openbossa.org>,
	'Samuel Ortiz' <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	'Waldemar Rymarkiewicz' <waldemar.rymarkiewicz@tieto.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	'Olivier Guiter' <olivier.guiter@linux.intel.com>,
	Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/2] NFC: pn533: Staticize local symbols
Date: Mon, 12 Aug 2013 15:40:02 +0900
Message-id: <000201ce9726$c67c7640$537562c0$@samsung.com> (sfid-20130812_084011_322627_822172B9)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These local symbols are used only in this file.
Fix the following sparse warnings:

drivers/nfc/pn533.c:2576:5: warning: symbol 'pn533_dev_up' was not declared. Should it be static?
drivers/nfc/pn533.c:2581:5: warning: symbol 'pn533_dev_down' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/nfc/pn533.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index daf92ac..1746225 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -2573,12 +2573,12 @@ static int pn533_rf_field(struct nfc_dev *nfc_dev, u8 rf)
 	return rc;
 }
 
-int pn533_dev_up(struct nfc_dev *nfc_dev)
+static int pn533_dev_up(struct nfc_dev *nfc_dev)
 {
 	return pn533_rf_field(nfc_dev, 1);
 }
 
-int pn533_dev_down(struct nfc_dev *nfc_dev)
+static int pn533_dev_down(struct nfc_dev *nfc_dev)
 {
 	return pn533_rf_field(nfc_dev, 0);
 }
-- 
1.7.10.4


