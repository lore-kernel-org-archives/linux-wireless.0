Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34899 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbLTS7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 13:59:38 -0500
From: Saurabh Sengar <saurabh.truth@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Saurabh Sengar <saurabh.truth@gmail.com>
Subject: [PATCH] NFC: added the rx delay parameter for nfcsim workqueue
Date: Mon, 21 Dec 2015 00:29:30 +0530
Message-Id: <1450637970-4990-1-git-send-email-saurabh.truth@gmail.com> (sfid-20151220_200039_716852_111E1EDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

added the rx delay parameter as a device tunable parameter.

Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>
---
This is a follow up patch after the review comments by Samuel Ortiz
on the initial patch.
Below is the link to original patch which implemented this parameter
as sysfs entry:
https://lkml.org/lkml/2015/12/20/118
 drivers/nfc/nfcsim.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index 26ac9e5..93aaca5 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -32,6 +32,8 @@
 #define NFCSIM_POLL_TARGET	2
 #define NFCSIM_POLL_DUAL	(NFCSIM_POLL_INITIATOR | NFCSIM_POLL_TARGET)
 
+#define RX_DEFAULT_DELAY	5
+
 struct nfcsim {
 	struct nfc_dev *nfc_dev;
 
@@ -51,6 +53,8 @@ struct nfcsim {
 
 	u8 initiator;
 
+	u32 rx_delay;
+
 	data_exchange_cb_t cb;
 	void *cb_context;
 
@@ -320,10 +324,9 @@ static int nfcsim_tx(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	 * If packet transmission occurs immediately between them, we have a
 	 * non-stop flow of several tens of thousands SYMM packets per second
 	 * and a burning cpu.
-	 *
-	 * TODO: Add support for a sysfs entry to control this delay.
 	 */
-	queue_delayed_work(wq, &peer->recv_work, msecs_to_jiffies(5));
+	queue_delayed_work(wq, &peer->recv_work,
+			msecs_to_jiffies(dev->rx_delay));
 
 	mutex_unlock(&peer->lock);
 
@@ -461,6 +464,7 @@ static struct nfcsim *nfcsim_init_dev(void)
 	if (rc)
 		goto free_nfc_dev;
 
+	dev->rx_delay = RX_DEFAULT_DELAY;
 	return dev;
 
 free_nfc_dev:
-- 
1.9.1

