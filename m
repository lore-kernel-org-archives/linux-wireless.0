Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:33794 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935061AbeF2MrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 08:47:24 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 1/2] nfc: st95hf: drop nfcdev_free
Date: Fri, 29 Jun 2018 14:47:16 +0200
Message-Id: <20180629124717.2011-1-daniel@zonque.org> (sfid-20180629_144730_737564_4EB22023)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag is unneccesary. We can just nullify `ddev' instead after we freed
it.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index a50a95cfcfd8..ef91ca8b53a4 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -220,7 +220,6 @@ struct st95_digital_cmd_complete_arg {
  *	from threaded ISR. Usage of this mutex avoids any race between
  *	deletion of the object from st95hf_remove() and its access from
  *	the threaded ISR.
- * @nfcdev_free: flag to have the state of nfc device object.
  *	[alive | died]
  * @current_protocol: current nfc protocol.
  * @current_rf_tech: current rf technology.
@@ -237,7 +236,6 @@ struct st95hf_context {
 	unsigned char sendrcv_trflag;
 	struct semaphore exchange_lock;
 	struct mutex rm_lock;
-	bool nfcdev_free;
 	u8 current_protocol;
 	u8 current_rf_tech;
 	int fwi;
@@ -822,8 +820,8 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 		goto end;
 	}
 
-	/* if stcontext->nfcdev_free is true, it means remove already ran */
-	if (stcontext->nfcdev_free) {
+	/* if stcontext->ddev is %NULL, it means remove already ran */
+	if (!stcontext->ddev) {
 		result = -ENODEV;
 		goto end;
 	}
@@ -1222,7 +1220,7 @@ static int st95hf_remove(struct spi_device *nfc_spi_dev)
 
 	nfc_digital_unregister_device(stcontext->ddev);
 	nfc_digital_free_device(stcontext->ddev);
-	stcontext->nfcdev_free = true;
+	stcontext->ddev = NULL;
 
 	mutex_unlock(&stcontext->rm_lock);
 
-- 
2.17.1
