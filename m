Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34436 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaAFQuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 11:50:11 -0500
Received: by mail-wi0-f176.google.com with SMTP id hq4so3045466wib.15
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 08:50:09 -0800 (PST)
From: Julien Massot <jmassot@aldebaran-robotics.com>
To: ath6kl-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Julien Massot <jmassot@aldebaran-robotics.com>
Subject: [PATCH 2/2] ath6kl: set rx urb count threshold to 1
Date: Mon,  6 Jan 2014 19:52:48 +0100
Message-Id: <1389034368-5370-3-git-send-email-jmassot@aldebaran-robotics.com> (sfid-20140106_175018_563823_2014C7C0)
In-Reply-To: <1389034368-5370-1-git-send-email-jmassot@aldebaran-robotics.com>
References: <1389034368-5370-1-git-send-email-jmassot@aldebaran-robotics.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduce the Rx count threshold to make sure we read
the available credits for Tx.

Signed-off-by: Julien Massot <jmassot@aldebaran-robotics.com>
---
 drivers/net/wireless/ath/ath6kl/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index bbaf867..56c3fd5 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -481,8 +481,8 @@ static void ath6kl_usb_start_recv_pipes(struct ath6kl_usb *ar_usb)
 	 *		ATH6KL_USB_RX_BUFFER_SIZE);
 	 */
 
-	ar_usb->pipes[ATH6KL_USB_PIPE_RX_DATA].urb_cnt_thresh =
-	    ar_usb->pipes[ATH6KL_USB_PIPE_RX_DATA].urb_alloc / 2;
+	ar_usb->pipes[ATH6KL_USB_PIPE_RX_DATA].urb_cnt_thresh = 1;
+
 	ath6kl_usb_post_recv_transfers(&ar_usb->pipes[ATH6KL_USB_PIPE_RX_DATA],
 				       ATH6KL_USB_RX_BUFFER_SIZE);
 }
-- 
1.8.4.2

