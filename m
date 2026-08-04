Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB37F43CE40;
	Tue,  4 Aug 2026 08:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785833760; cv=none; b=NVGIc6zQieH8Ht7oBwC+mV0Bz5klz+qoqpd9oGgevdmxw8o0nghNK4h2V3bu+HtmFPMwwTNUoiRXsigBtRdG2V9bZ5FmmVBG3yZpcG6H6WTQFfJLU3czltP0InK5CipoGGLkkn6C32s/dsyRu4j9RhRwmelZZIYonCW/rrcjOjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785833760; c=relaxed/simple;
	bh=8QSj/FHPhDqw9yacyuEStvcaNX2S7QEqGsKoxcOm1l8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=nKIvfMcOdTDEpmJ5i/X+kIIckOKDZZDDRbmKWc7DzsBj37bpAxrDk7BgGa2odbQA5/wqUkwwPO9LZekLshgPzrpT8iRMJbEXz70/C4BINf2y4d95TslF8z12MjWZkBoaWrHQQ+KjJYpk4+26Czf/avmjhJPG7w0A3lA7utvvBZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhUIrKFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhUIrKFa"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67BC4C2BCF4;
	Tue,  4 Aug 2026 08:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785833759;
	bh=8QSj/FHPhDqw9yacyuEStvcaNX2S7QEqGsKoxcOm1l8=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=ZhUIrKFaTAU1LxubtZzVK8Py9vjRstpf+NkauXNHnzcifqpdQVJtdY2U3nFhVYIPj
	 NV9AAfOoEXAPTOxu/SlgVwPeeQIIr5QjSaPOSBNXvMP4ykwFACADmXi6EIBN9zeuWu
	 NQfL6bRH3gsTtI/RiieNFLuZhmCoou+B/Qmc/rQ/qj/2c30gIugerm8W0ZfhTXvuvC
	 dXPFzik+Vh+n1onfBoU1rWy28VnFT9dNSW7vlh3rf0upu72sF9u2eezVwkuIpY83kB
	 QTO+WH4883g6aopaLN3YgGb41etvW9QgxmvqXa7lsYnSMods7Ngu1tOFQL1bN+pScZ
	 1SaqZmnFoYpwg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DB0C5518F;
	Tue,  4 Aug 2026 08:55:59 +0000 (UTC)
From: Stefan Hansson via B4 Relay <devnull+newbyte.postmarketos.org@kernel.org>
Date: Tue, 04 Aug 2026 10:55:41 +0200
Subject: [PATCH v2] wifi: rsi: Fix types to appease CFI
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-rsi-cfi-fix-v2-1-59679a520240@postmarketos.org>
X-B4-Tracking: v=1; b=H4sIAAypcWoC/22NwQ6CMBBEf8Xs2Zp2FYKe/A/DAcoCq5GS3Uo0h
 H+34NXjm8y8mUFJmBQuuxmEJlYOQwLc78D31dCR4SYxoMXcFhaNKBvfsmn5bdDaIqvz87FBhLQ
 YhVK82W7lj/VV38nHVbE2etYY5LPdTW7t/TdPzjiTFega9HV2IrqOQeOzkgfFoIcgHZTLsnwB+
 PzwML8AAAA=
X-Change-ID: 20260802-rsi-cfi-fix-20085b693d22
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht
Cc: Stefan Hansson <newbyte@postmarketos.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785833758; l=5665;
 i=newbyte@postmarketos.org; s=20260802; h=from:subject:message-id;
 bh=BB2op5+p7icC+54RZOKKgba+7WNOZz8dHsaqqYyKAvc=;
 b=ThwlqJJN1yoe+CcfBWuSg1qewHU3rshzTmTRG6YrHMTCThXu+4doDF1T6xeiW1wFudVbbaMYN
 1nVorWYRGjjC5veppy7VSJwhAXsDo9LYvi+BC4+lu1phkid1DpFJ4oL
X-Developer-Key: i=newbyte@postmarketos.org; a=ed25519;
 pk=CMd9mCPy2ujgZ4/0VRH1OVotAimnFmPg2/JMEEgsOUk=
X-Endpoint-Received: by B4 Relay for newbyte@postmarketos.org/20260802 with
 auth_id=910
X-Original-From: Stefan Hansson <newbyte@postmarketos.org>
Reply-To: newbyte@postmarketos.org

From: Stefan Hansson <newbyte@postmarketos.org>

Avoids errors like:

    CFI failure at kthread+0x124/0x1cc (target: rsi_coex_scheduler_thread+0x0/0x1b4 [redpine_91x]; expected type: 0x89fb613d)

As seen in the aforementioned error this was tested using the downstream
redpine_91x driver found in the Librem 5's downstream source tree.
However, it appears that this driver is a modified version of the rsi
driver found in mainline Linux and as such I decided to port the changes
here too.

Signed-off-by: Stefan Hansson <newbyte@postmarketos.org>
---
Changes in v2:
- Fix kernel-doc warnings.
- Link to v1: https://patch.msgid.link/20260802-rsi-cfi-fix-v1-1-5821d2cb54ee@postmarketos.org
---
 drivers/net/wireless/rsi/rsi_91x_coex.c     | 3 ++-
 drivers/net/wireless/rsi/rsi_91x_main.c     | 7 ++++---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 3 ++-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  | 7 ++++---
 drivers/net/wireless/rsi/rsi_common.h       | 2 +-
 drivers/net/wireless/rsi/rsi_sdio.h         | 2 +-
 drivers/net/wireless/rsi/rsi_usb.h          | 2 +-
 7 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index ee603a5173fb..023c539fc384 100644
--- a/drivers/net/wireless/rsi/rsi_91x_coex.c
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -50,8 +50,9 @@ static void rsi_coex_sched_tx_pkts(struct rsi_coex_ctrl_block *coex_cb)
 	} while (coex_q != RSI_COEX_Q_INVALID);
 }
 
-static void rsi_coex_scheduler_thread(struct rsi_common *common)
+static int rsi_coex_scheduler_thread(void *data)
 {
+	struct rsi_common *common = data;
 	struct rsi_coex_ctrl_block *coex_cb = common->coex_cb;
 	u32 timeout = EVENT_WAIT_FOREVER;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 662e42d1e5e8..2ce514766620 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -246,12 +246,13 @@ EXPORT_SYMBOL_GPL(rsi_read_pkt);
 /**
  * rsi_tx_scheduler_thread() - This function is a kernel thread to send the
  *			       packets to the device.
- * @common: Pointer to the driver private structure.
+ * @data: Pointer to the driver private structure.
  *
- * Return: None.
+ * Return: 0.
  */
-static void rsi_tx_scheduler_thread(struct rsi_common *common)
+static int rsi_tx_scheduler_thread(void *data)
 {
+	struct rsi_common *common = data;
 	struct rsi_hw *adapter = common->priv;
 	u32 timeout = EVENT_WAIT_FOREVER;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 597b238e2294..18a28aa97446 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -62,8 +62,9 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word)
 
 static void rsi_rx_handler(struct rsi_hw *adapter);
 
-void rsi_sdio_rx_thread(struct rsi_common *common)
+int rsi_sdio_rx_thread(void *data)
 {
+	struct rsi_common *common = data;
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index 25c2b232394a..e899631b9aed 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -21,12 +21,13 @@
 /**
  * rsi_usb_rx_thread() - This is a kernel thread to receive the packets from
  *			 the USB device.
- * @common: Pointer to the driver private structure.
+ * @data: Pointer to the driver private structure.
  *
- * Return: None.
+ * Return: 0.
  */
-void rsi_usb_rx_thread(struct rsi_common *common)
+int rsi_usb_rx_thread(void *data)
 {
+	struct rsi_common *common = data;
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_usbdev *dev = adapter->rsi_dev;
 	int status;
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index 3cdf9ded876d..2a33a81f71a3 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -58,7 +58,7 @@ static inline void rsi_reset_event(struct rsi_event *event)
 
 static inline int rsi_create_kthread(struct rsi_common *common,
 				     struct rsi_thread *thread,
-				     void *func_ptr,
+				     int (*func_ptr)(void *data),
 				     u8 *name)
 {
 	init_completion(&thread->completion);
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 7c91b126b350..eb2b7f36a7e4 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -134,5 +134,5 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num);
-void rsi_sdio_rx_thread(struct rsi_common *common);
+int rsi_sdio_rx_thread(void *data);
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 961851748bc4..78067eaffe8b 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -81,5 +81,5 @@ static inline int rsi_usb_event_timeout(struct rsi_hw *adapter)
 	return EVENT_WAIT_FOREVER;
 }
 
-void rsi_usb_rx_thread(struct rsi_common *common);
+int rsi_usb_rx_thread(void *data);
 #endif

---
base-commit: 95d6a9ccef99117115e41e9adb271243bd5e985b
change-id: 20260802-rsi-cfi-fix-20085b693d22

Best regards,
--  
Stefan Hansson <newbyte@postmarketos.org>


