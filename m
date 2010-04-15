Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab0DOU2U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 16:28:20 -0400
Subject: [PATCH 1/2] libertas: consolidate SDIO firmware wait code
From: Dan Williams <dcbw@redhat.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Alagu Sankar <alagusankar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 13:27:44 -0700
Message-ID: <1271363264.10765.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Consolidate a bunch of C&P code that waits for the firmware to be ready.

Signed-off-by: Dan Williams <dcbw@redhat.com>

---
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 7a73f62..dcd14da 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -312,12 +312,28 @@ out:
 	return ret;
 }
 
+static int if_sdio_wait_status(struct if_sdio_card *card, const u8 condition)
+{
+	u8 status;
+	unsigned long timeout;
+	int ret = 0;
+
+	timeout = jiffies + HZ;
+	while (1) {
+		status = sdio_readb(card->func, IF_SDIO_STATUS, &ret);
+		if (ret || (status & condition))
+			break;
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+		mdelay(1);
+	}
+	return ret;
+}
+
 static int if_sdio_card_to_host(struct if_sdio_card *card)
 {
 	int ret;
-	u8 status;
 	u16 size, type, chunk;
-	unsigned long timeout;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
@@ -332,19 +348,9 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
 		goto out;
 	}
 
-	timeout = jiffies + HZ;
-	while (1) {
-		status = sdio_readb(card->func, IF_SDIO_STATUS, &ret);
-		if (ret)
-			goto out;
-		if (status & IF_SDIO_IO_RDY)
-			break;
-		if (time_after(jiffies, timeout)) {
-			ret = -ETIMEDOUT;
-			goto out;
-		}
-		mdelay(1);
-	}
+	ret = if_sdio_wait_status(card, IF_SDIO_IO_RDY);
+	if (ret)
+		goto out;
 
 	/*
 	 * The transfer must be in one transaction or the firmware
@@ -411,8 +417,6 @@ static void if_sdio_host_to_card_worker(struct work_struct *work)
 {
 	struct if_sdio_card *card;
 	struct if_sdio_packet *packet;
-	unsigned long timeout;
-	u8 status;
 	int ret;
 	unsigned long flags;
 
@@ -432,25 +436,15 @@ static void if_sdio_host_to_card_worker(struct work_struct *work)
 
 		sdio_claim_host(card->func);
 
-		timeout = jiffies + HZ;
-		while (1) {
-			status = sdio_readb(card->func, IF_SDIO_STATUS, &ret);
-			if (ret)
-				goto release;
-			if (status & IF_SDIO_IO_RDY)
-				break;
-			if (time_after(jiffies, timeout)) {
-				ret = -ETIMEDOUT;
-				goto release;
-			}
-			mdelay(1);
+		ret = if_sdio_wait_status(card, IF_SDIO_IO_RDY);
+		if (ret == 0) {
+			ret = sdio_writesb(card->func, card->ioport,
+					   packet->buffer, packet->nb);
 		}
 
-		ret = sdio_writesb(card->func, card->ioport,
-				packet->buffer, packet->nb);
 		if (ret)
-			goto release;
-release:
+			lbs_pr_err("error %d sending packet to firmware\n", ret);
+
 		sdio_release_host(card->func);
 
 		kfree(packet);
@@ -463,10 +457,11 @@ release:
 /* Firmware                                                         */
 /********************************************************************/
 
+#define FW_DL_READY_STATUS (IF_SDIO_IO_RDY | IF_SDIO_DL_RDY)
+
 static int if_sdio_prog_helper(struct if_sdio_card *card)
 {
 	int ret;
-	u8 status;
 	const struct firmware *fw;
 	unsigned long timeout;
 	u8 *chunk_buffer;
@@ -498,20 +493,9 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 	size = fw->size;
 
 	while (size) {
-		timeout = jiffies + HZ;
-		while (1) {
-			status = sdio_readb(card->func, IF_SDIO_STATUS, &ret);
-			if (ret)
-				goto release;
-			if ((status & IF_SDIO_IO_RDY) &&
-					(status & IF_SDIO_DL_RDY))
-				break;
-			if (time_after(jiffies, timeout)) {
-				ret = -ETIMEDOUT;
-				goto release;
-			}
-			mdelay(1);
-		}
+		ret = if_sdio_wait_status(card, FW_DL_READY_STATUS);
+		if (ret)
+			goto release;
 
 		chunk_size = min(size, (size_t)60);
 
@@ -581,7 +565,6 @@ out:
 static int if_sdio_prog_real(struct if_sdio_card *card)
 {
 	int ret;
-	u8 status;
 	const struct firmware *fw;
 	unsigned long timeout;
 	u8 *chunk_buffer;
@@ -613,20 +596,9 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 	size = fw->size;
 
 	while (size) {
-		timeout = jiffies + HZ;
-		while (1) {
-			status = sdio_readb(card->func, IF_SDIO_STATUS, &ret);
-			if (ret)
-				goto release;
-			if ((status & IF_SDIO_IO_RDY) &&
-					(status & IF_SDIO_DL_RDY))
-				break;
-			if (time_after(jiffies, timeout)) {
-				ret = -ETIMEDOUT;
-				goto release;
-			}
-			mdelay(1);
-		}
+		ret = if_sdio_wait_status(card, FW_DL_READY_STATUS);
+		if (ret)
+			goto release;
 
 		req_size = sdio_readb(card->func, IF_SDIO_RD_BASE, &ret);
 		if (ret)


