Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:64653 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbbLVJyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 04:54:24 -0500
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc] PATCH v1.0 1/1] driver: nfc: st95hf: Fix of build error
Date: Tue, 22 Dec 2015 04:53:37 -0500
Message-ID: <1450778017-12124-2-git-send-email-shikha.singh@st.com> (sfid-20151222_105430_498316_E59ABE4E)
In-Reply-To: <1450778017-12124-1-git-send-email-shikha.singh@st.com>
References: <1450778017-12124-1-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modification in core.c to rename function "irq_handler"
and "irq_thread_handler" to "st95hf_irq_handler" and
"st95hf_irq_thread_handler" respectively. This modification
was done to remove build error.

Signed-off-by: Shikha Singh <shikha.singh@st.com>
---
 drivers/nfc/st95hf/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 526e342..9524b12 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -762,7 +762,7 @@ static int st95hf_response_handler(struct st95hf_context *stcontext,
 	return result;
 }
 
-static irqreturn_t irq_handler(int irq, void  *st95hfcontext)
+static irqreturn_t st95hf_irq_handler(int irq, void  *st95hfcontext)
 {
 	struct st95hf_context *stcontext  =
 		(struct st95hf_context *)st95hfcontext;
@@ -776,7 +776,7 @@ static irqreturn_t irq_handler(int irq, void  *st95hfcontext)
 	return IRQ_WAKE_THREAD;
 }
 
-static irqreturn_t irq_thread_handler(int irq, void  *st95hfcontext)
+static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 {
 	int result = 0;
 	int res_len;
@@ -1140,8 +1140,8 @@ static int st95hf_probe(struct spi_device *nfc_spi_dev)
 	if (nfc_spi_dev->irq > 0) {
 		if (devm_request_threaded_irq(&nfc_spi_dev->dev,
 					      nfc_spi_dev->irq,
-					      irq_handler,
-					      irq_thread_handler,
+					      st95hf_irq_handler,
+					      st95hf_irq_thread_handler,
 					      IRQF_TRIGGER_FALLING,
 					      "st95hf",
 					      (void *)st95context) < 0) {
-- 
1.8.2.1

