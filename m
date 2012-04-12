Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8232 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933732Ab2DLMsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 08:48:52 -0400
From: <raychen@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Ray Chen <raychen@qca.qualcomm.com>
Subject: [PATCH 1/1] ath6kl: Fix system crash sometimes for USB hotplug
Date: Thu, 12 Apr 2012 20:48:34 +0800
Message-ID: <1334234914-5487-1-git-send-email-raychen@qca.qualcomm.com> (sfid-20120412_144856_058965_FA3834F0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ray Chen <raychen@qca.qualcomm.com>

System crash because of NULL pointer reference due to
cleanup_scatter is not implemented for USB.

Signed-off-by: Ray Chen <raychen@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/usb.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 73aacdd..dfbbe9e 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -1037,6 +1037,14 @@ static void ath6kl_usb_stop(struct ath6kl *ar)
 	hif_stop(ar);
 }
 
+static void ath6kl_usb_cleanup_scatter(struct ath6kl *ar)
+{
+	/*
+	 * USB doesn't support it. Just return.
+	 */
+	return;
+}
+
 static const struct ath6kl_hif_ops ath6kl_usb_ops = {
 	.diag_read32 = ath6kl_usb_diag_read32,
 	.diag_write32 = ath6kl_usb_diag_write32,
@@ -1049,6 +1057,7 @@ static const struct ath6kl_hif_ops ath6kl_usb_ops = {
 	.pipe_get_default = ath6kl_usb_get_default_pipe,
 	.pipe_map_service = ath6kl_usb_map_service_pipe,
 	.pipe_get_free_queue_number = ath6kl_usb_get_free_queue_number,
+	.cleanup_scatter = ath6kl_usb_cleanup_scatter,
 };
 
 /* ath6kl usb driver registered functions */
-- 
1.7.0.4

