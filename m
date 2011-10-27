Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:40270 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1J0Ps4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:48:56 -0400
Subject: [PATCH 08/10] ath6kl: add a timeout to ath6kl_hif_intr_bh_handler()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:48:52 +0300
Message-ID: <20111027154852.23519.2897.stgit@localhost6.localdomain6> (sfid-20111027_174859_569484_D958C6A1)
In-Reply-To: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
References: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's possible to busyloop forever in ath6kl_hif_intr_bh_handler(). Add
a check that it lasts only one second.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.c |    4 +++-
 drivers/net/wireless/ath/ath6kl/hif.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index e2d8088..309be98 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -485,6 +485,7 @@ out:
 int ath6kl_hif_intr_bh_handler(struct ath6kl *ar)
 {
 	struct ath6kl_device *dev = ar->htc_target->dev;
+	unsigned long timeout;
 	int status = 0;
 	bool done = false;
 
@@ -498,7 +499,8 @@ int ath6kl_hif_intr_bh_handler(struct ath6kl *ar)
 	 * IRQ processing is synchronous, interrupt status registers can be
 	 * re-read.
 	 */
-	while (!done) {
+	timeout = jiffies + msecs_to_jiffies(ATH6KL_HIF_COMMUNICATION_TIMEOUT);
+	while (time_before(jiffies, timeout) && !done) {
 		status = proc_pending_irqs(dev, &done);
 		if (status)
 			break;
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index ee7c31a..78a6c79 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -69,6 +69,8 @@
 #define ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER      (16 * 1024)
 #define ATH6KL_SCATTER_REQS                       4
 
+#define ATH6KL_HIF_COMMUNICATION_TIMEOUT	1000
+
 struct bus_request {
 	struct list_head list;
 

