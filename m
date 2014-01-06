Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:44111 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaAFQuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 11:50:10 -0500
Received: by mail-we0-f176.google.com with SMTP id p61so16162574wes.35
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 08:50:09 -0800 (PST)
From: Julien Massot <jmassot@aldebaran-robotics.com>
To: ath6kl-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Julien Massot <jmassot@aldebaran-robotics.com>
Subject: [PATCH 1/2] ath6kl: increase usb rx buffer size to 4096
Date: Mon,  6 Jan 2014 19:52:47 +0100
Message-Id: <1389034368-5370-2-git-send-email-jmassot@aldebaran-robotics.com> (sfid-20140106_175021_509956_F86A8666)
In-Reply-To: <1389034368-5370-1-git-send-email-jmassot@aldebaran-robotics.com>
References: <1389034368-5370-1-git-send-email-jmassot@aldebaran-robotics.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the previous value (1700), some urb are dropped
with a babble error (urb status equal -EOVERFLOW).

These error seems to only happen when urb length is a
multiple of packet size (512).

Signed-off-by: Julien Massot <jmassot@aldebaran-robotics.com>
---
 drivers/net/wireless/ath/ath6kl/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index f38ff6a..bbaf867 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -24,7 +24,7 @@
 /* constants */
 #define TX_URB_COUNT            32
 #define RX_URB_COUNT            32
-#define ATH6KL_USB_RX_BUFFER_SIZE  1700
+#define ATH6KL_USB_RX_BUFFER_SIZE  4096
 
 /* tx/rx pipes for usb */
 enum ATH6KL_USB_PIPE_ID {
-- 
1.8.4.2

