Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57128 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388471AbeGXLFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 07:05:39 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v3 04/11] NFC: st95hf: remove logging from spi functions
Date: Tue, 24 Jul 2018 11:59:34 +0200
Message-Id: <20180724095941.25777-5-daniel@zonque.org> (sfid-20180724_120138_680737_6EBAAA2E)
In-Reply-To: <20180724095941.25777-1-daniel@zonque.org>
References: <20180724095941.25777-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The callers of these functions already log on errors, and there's no
need to do it from two places.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/spi.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/nfc/st95hf/spi.c b/drivers/nfc/st95hf/spi.c
index e2d3bbcc8c34..d5894d4546b1 100644
--- a/drivers/nfc/st95hf/spi.c
+++ b/drivers/nfc/st95hf/spi.c
@@ -47,8 +47,6 @@ int st95hf_spi_send(struct st95hf_spi_context *spicontext,
 
 	result = spi_sync(spidev, &m);
 	if (result) {
-		dev_err(&spidev->dev, "error: sending cmd to st95hf using SPI = %d\n",
-			result);
 		mutex_unlock(&spicontext->spi_lock);
 		return result;
 	}
@@ -62,12 +60,10 @@ int st95hf_spi_send(struct st95hf_spi_context *spicontext,
 	result = wait_for_completion_timeout(&spicontext->done,
 					     msecs_to_jiffies(1000));
 	/* check for timeout or success */
-	if (!result) {
-		dev_err(&spidev->dev, "error: response not ready timeout\n");
+	if (!result)
 		result = -ETIMEDOUT;
-	} else {
+	else
 		result = 0;
-	}
 
 	mutex_unlock(&spicontext->spi_lock);
 
@@ -79,7 +75,7 @@ EXPORT_SYMBOL_GPL(st95hf_spi_send);
 int st95hf_spi_recv_response(struct st95hf_spi_context *spicontext,
 			     unsigned char *receivebuff)
 {
-	int len = 0;
+	int ret, len;
 	struct spi_transfer tx_takedata;
 	struct spi_message m;
 	struct spi_device *spidev = spicontext->spidev;
@@ -89,8 +85,6 @@ int st95hf_spi_recv_response(struct st95hf_spi_context *spicontext,
 		{.rx_buf = receivebuff, .len = 2, .cs_change = 1,},
 	};
 
-	int ret = 0;
-
 	memset(&tx_takedata, 0x0, sizeof(struct spi_transfer));
 
 	mutex_lock(&spicontext->spi_lock);
@@ -102,8 +96,6 @@ int st95hf_spi_recv_response(struct st95hf_spi_context *spicontext,
 
 	ret = spi_sync(spidev, &m);
 	if (ret) {
-		dev_err(&spidev->dev, "spi_recv_resp, data length error = %d\n",
-			ret);
 		mutex_unlock(&spicontext->spi_lock);
 		return ret;
 	}
@@ -127,11 +119,8 @@ int st95hf_spi_recv_response(struct st95hf_spi_context *spicontext,
 	ret = spi_sync(spidev, &m);
 
 	mutex_unlock(&spicontext->spi_lock);
-	if (ret) {
-		dev_err(&spidev->dev, "spi_recv_resp, data read error = %d\n",
-			ret);
+	if (ret)
 		return ret;
-	}
 
 	return len;
 }
-- 
2.17.1
