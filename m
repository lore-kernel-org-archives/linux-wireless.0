Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12896 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2I0MuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:50:18 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 1/6] ath6kl: Remove obselete USB device related checks
Date: Thu, 27 Sep 2012 18:19:48 +0530
Message-ID: <1348750193-2665-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120927_145023_099055_0F09AE6C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

These checks are no longer needed as the necessary
USB support is already present in the driver.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.c      |    5 -----
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   10 +---------
 2 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index 029914a..a7a1ec4 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -696,11 +696,6 @@ int ath6kl_hif_setup(struct ath6kl_device *dev)
 	ath6kl_dbg(ATH6KL_DBG_HIF, "hif block size %d mbox addr 0x%x\n",
 		   dev->htc_cnxt->block_sz, dev->ar->mbox_info.htc_addr);
 
-	/* usb doesn't support enabling interrupts */
-	/* FIXME: remove check once USB support is implemented */
-	if (dev->ar->hif_type == ATH6KL_HIF_TYPE_USB)
-		return 0;
-
 	status = ath6kl_hif_disable_intrs(dev);
 
 fail_setup:
diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index cd0e1ba..26685de 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -2655,12 +2655,6 @@ static int ath6kl_htc_mbox_wait_target(struct htc_target *target)
 	struct htc_service_connect_resp resp;
 	int status;
 
-	/* FIXME: remove once USB support is implemented */
-	if (target->dev->ar->hif_type == ATH6KL_HIF_TYPE_USB) {
-		ath6kl_err("HTC doesn't support USB yet. Patience!\n");
-		return -EOPNOTSUPP;
-	}
-
 	/* we should be getting 1 control message that the target is ready */
 	packet = htc_wait_for_ctrl_msg(target);
 
@@ -2890,9 +2884,7 @@ static void ath6kl_htc_mbox_cleanup(struct htc_target *target)
 {
 	struct htc_packet *packet, *tmp_packet;
 
-	/* FIXME: remove check once USB support is implemented */
-	if (target->dev->ar->hif_type != ATH6KL_HIF_TYPE_USB)
-		ath6kl_hif_cleanup_scatter(target->dev->ar);
+	ath6kl_hif_cleanup_scatter(target->dev->ar);
 
 	list_for_each_entry_safe(packet, tmp_packet,
 				 &target->free_ctrl_txbuf, list) {
-- 
1.7.0.4

