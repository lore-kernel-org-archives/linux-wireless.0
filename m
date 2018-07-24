Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57100 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388471AbeGXLFe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 07:05:34 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v3 02/11] NFC: st95hf: drop nfcdev_free
Date: Tue, 24 Jul 2018 11:59:32 +0200
Message-Id: <20180724095941.25777-3-daniel@zonque.org> (sfid-20180724_120137_554444_9880AF06)
In-Reply-To: <20180724095941.25777-1-daniel@zonque.org>
References: <20180724095941.25777-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag is unneccesary. We can just nullify `ddev' instead after we freed
it and check for that in the ISR.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index bc1a2070f9bb..d58424ab5c48 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -220,8 +220,6 @@ struct st95_digital_cmd_complete_arg {
  *	from threaded ISR. Usage of this mutex avoids any race between
  *	deletion of the object from st95hf_remove() and its access from
  *	the threaded ISR.
- * @nfcdev_free: flag to have the state of nfc device object.
- *	[alive | died]
  * @current_protocol: current nfc protocol.
  * @current_rf_tech: current rf technology.
  * @fwi: frame waiting index, received in reply of RATS according to
@@ -237,7 +235,6 @@ struct st95hf_context {
 	unsigned char sendrcv_trflag;
 	struct semaphore exchange_lock;
 	struct mutex rm_lock;
-	bool nfcdev_free;
 	u8 current_protocol;
 	u8 current_rf_tech;
 	int fwi;
@@ -820,8 +817,8 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 		goto end;
 	}
 
-	/* if stcontext->nfcdev_free is true, it means remove already ran */
-	if (stcontext->nfcdev_free) {
+	/* if stcontext->ddev is %NULL, it means remove already ran */
+	if (!stcontext->ddev) {
 		result = -ENODEV;
 		goto end;
 	}
@@ -1220,7 +1217,7 @@ static int st95hf_remove(struct spi_device *nfc_spi_dev)
 
 	nfc_digital_unregister_device(stcontext->ddev);
 	nfc_digital_free_device(stcontext->ddev);
-	stcontext->nfcdev_free = true;
+	stcontext->ddev = NULL;
 
 	mutex_unlock(&stcontext->rm_lock);
 
-- 
2.17.1
