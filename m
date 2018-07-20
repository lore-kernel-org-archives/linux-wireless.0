Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34959 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388109AbeGTTOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 15:14:01 -0400
From: Colin King <colin.king@canonical.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Mack <daniel@zonque.org>, linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: st95hf: remove redundant pointers 'dev' and 'nfcddev'
Date: Fri, 20 Jul 2018 19:24:31 +0100
Message-Id: <20180720182431.24353-1-colin.king@canonical.com> (sfid-20180720_202448_943628_DC89AE46)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Pointers 'dev' and 'nfcddev' are being assigned but are never used
hence they are redundant and can be removed.

Cleans up clang warnings:
warning: variable 'dev' set but not used [-Wunused-but-set-variable]
warning: variable 'nfcddev' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/st95hf/core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index a50a95cfcfd8..36ef0e905ba3 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -781,9 +781,7 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	int result = 0;
 	int res_len;
 	static bool wtx;
-	struct device *dev;
 	struct device *spidevice;
-	struct nfc_digital_dev *nfcddev;
 	struct sk_buff *skb_resp;
 	struct st95hf_context *stcontext  =
 		(struct st95hf_context *)st95hfcontext;
@@ -828,8 +826,6 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 		goto end;
 	}
 
-	dev = &stcontext->nfcdev->dev;
-	nfcddev = stcontext->ddev;
 	if (skb_resp->data[2] == WTX_REQ_FROM_TAG) {
 		/* Request for new FWT from tag */
 		result = st95hf_handle_wtx(stcontext, true, skb_resp->data[3]);
-- 
2.17.1
