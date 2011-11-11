Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:37985 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1KKKSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:18:41 -0500
Subject: [PATCH 09/10] ath6kl: disable HTC for USB devices
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2011 12:18:37 +0200
Message-ID: <20111111101837.12075.38773.stgit@localhost6.localdomain6> (sfid-20111111_111844_496709_5ED12434)
In-Reply-To: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
References: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As HTC layer doesn't support USB devices return an error if that happens.
USB support will be added to HTC in the future, this is just a temporary
solution.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.c |    5 +++++
 drivers/net/wireless/ath/ath6kl/htc.c |   10 +++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index e57da35..0772ef6 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -689,6 +689,11 @@ int ath6kl_hif_setup(struct ath6kl_device *dev)
 	ath6kl_dbg(ATH6KL_DBG_HIF, "hif block size %d mbox addr 0x%x\n",
 		   dev->htc_cnxt->block_sz, dev->ar->mbox_info.htc_addr);
 
+	/* usb doesn't support enabling interrupts */
+	/* FIXME: remove check once USB support is implemented */
+	if (dev->ar->hif_type == ATH6KL_HIF_TYPE_USB)
+		return 0;
+
 	status = ath6kl_hif_disable_intrs(dev);
 
 fail_setup:
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index f3b63ca..b017022 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -2543,6 +2543,12 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 	struct htc_service_connect_resp resp;
 	int status;
 
+	/* FIXME: remove once USB support is implemented */
+	if (target->dev->ar->hif_type == ATH6KL_HIF_TYPE_USB) {
+		ath6kl_err("HTC doesn't support USB yet. Patience!\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* we should be getting 1 control message that the target is ready */
 	packet = htc_wait_for_ctrl_msg(target);
 
@@ -2772,7 +2778,9 @@ void ath6kl_htc_cleanup(struct htc_target *target)
 {
 	struct htc_packet *packet, *tmp_packet;
 
-	ath6kl_hif_cleanup_scatter(target->dev->ar);
+	/* FIXME: remove check once USB support is implemented */
+	if (target->dev->ar->hif_type != ATH6KL_HIF_TYPE_USB)
+		ath6kl_hif_cleanup_scatter(target->dev->ar);
 
 	list_for_each_entry_safe(packet, tmp_packet,
 			&target->free_ctrl_txbuf, list) {

