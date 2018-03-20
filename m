Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37253 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753281AbeCTNxF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 09:53:05 -0400
Received: by mail-pg0-f66.google.com with SMTP id n11so635124pgp.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2018 06:53:05 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [PATCH 2/2] rsi: fix kernel panic observed on 64bit machine
Date: Tue, 20 Mar 2018 19:10:41 +0530
Message-Id: <1521553241-12676-2-git-send-email-amitkarwar@gmail.com> (sfid-20180320_145309_596174_5854138F)
In-Reply-To: <1521553241-12676-1-git-send-email-amitkarwar@gmail.com>
References: <1521553241-12676-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Following kernel panic is observed on 64bit machine while loading
the driver. It is fixed if we pass dynamically allocated memory to
SDIO for DMA.

BUG: unable to handle kernel paging request at ffffeb04000172e0
IP: sg_miter_stop+0x56/0x70
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
Modules linked in: rsi_sdio(OE+) rsi_91x(OE) btrsi(OE) rfcomm bluetooth
ecdh_generic mac80211 mmc_block fuse xt_CHECKSUM iptable_mangle
drm_kms_helper mmc_core serio_raw drm firewire_ohci tg3
CPU: 0 PID: 4003 Comm: insmod Tainted: G           OE    4.16.0-rc1+ #27
Hardware name: Dell Inc. Latitude E5500                  /0DW634, BIOS
A19 06/13/2013
RIP: 0010:sg_miter_stop+0x56/0x70
RSP: 0018:ffff88007d003e78 EFLAGS: 00010002
RAX: 0000000000000003 RBX: 0000000000000004 RCX: 0000000000000000
RDX: ffffeb04000172c0 RSI: ffff88002f58002c RDI: ffff88007d003e80
RBP: 0000000000000004 R08: ffff88007d003e80 R09: 0000000000000008
R10: 0000000000000003 R11: 0000000000000001 R12: 0000000000000004
R13: ffff88002f580028 R14: 0000000000000000 R15: 0000000000000004
FS:  00007f35c29db700(0000) GS:ffff88007d000000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffeb04000172e0 CR3: 000000007038e000 CR4: 00000000000406f0
Call Trace:
<IRQ>
sg_copy_buffer+0xc6/0xf0
sdhci_tasklet_finish+0x170/0x260 [sdhci]
tasklet_action+0xf4/0x100
__do_softirq+0xef/0x26e
irq_exit+0xbe/0xd0
do_IRQ+0x4a/0xc0
common_interrupt+0xa2/0xa2
</IRQ>

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 32 +++++++++++++++++++++-----------
 drivers/net/wireless/rsi/rsi_sdio.h     |  2 ++
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 9ce2edb..d76e69c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -653,11 +653,14 @@ static int rsi_sdio_master_reg_read(struct rsi_hw *adapter, u32 addr,
 				    u32 *read_buf, u16 size)
 {
 	u32 addr_on_bus, *data;
-	u32 align[2] = {};
 	u16 ms_addr;
 	int status;
 
-	data = PTR_ALIGN(&align[0], 8);
+	data = kzalloc(RSI_MASTER_REG_BUF_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data = PTR_ALIGN(data, 8);
 
 	ms_addr = (addr >> 16);
 	status = rsi_sdio_master_access_msword(adapter, ms_addr);
@@ -665,7 +668,7 @@ static int rsi_sdio_master_reg_read(struct rsi_hw *adapter, u32 addr,
 		rsi_dbg(ERR_ZONE,
 			"%s: Unable to set ms word to common reg\n",
 			__func__);
-		return status;
+		goto err;
 	}
 	addr &= 0xFFFF;
 
@@ -683,7 +686,7 @@ static int rsi_sdio_master_reg_read(struct rsi_hw *adapter, u32 addr,
 					 (u8 *)data, 4);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "%s: AHB register read failed\n", __func__);
-		return status;
+		goto err;
 	}
 	if (size == 2) {
 		if ((addr & 0x3) == 0)
@@ -705,17 +708,23 @@ static int rsi_sdio_master_reg_read(struct rsi_hw *adapter, u32 addr,
 		*read_buf = *data;
 	}
 
-	return 0;
+err:
+	kfree(data);
+	return status;
 }
 
 static int rsi_sdio_master_reg_write(struct rsi_hw *adapter,
 				     unsigned long addr,
 				     unsigned long data, u16 size)
 {
-	unsigned long data1[2], *data_aligned;
+	unsigned long *data_aligned;
 	int status;
 
-	data_aligned = PTR_ALIGN(&data1[0], 8);
+	data_aligned = kzalloc(RSI_MASTER_REG_BUF_SIZE, GFP_KERNEL);
+	if (!data_aligned)
+		return -ENOMEM;
+
+	data_aligned = PTR_ALIGN(data_aligned, 8);
 
 	if (size == 2) {
 		*data_aligned = ((data << 16) | (data & 0xFFFF));
@@ -734,6 +743,7 @@ static int rsi_sdio_master_reg_write(struct rsi_hw *adapter,
 		rsi_dbg(ERR_ZONE,
 			"%s: Unable to set ms word to common reg\n",
 			__func__);
+		kfree(data_aligned);
 		return -EIO;
 	}
 	addr = addr & 0xFFFF;
@@ -743,12 +753,12 @@ static int rsi_sdio_master_reg_write(struct rsi_hw *adapter,
 					(adapter,
 					 (addr | RSI_SD_REQUEST_MASTER),
 					 (u8 *)data_aligned, size);
-	if (status < 0) {
+	if (status < 0)
 		rsi_dbg(ERR_ZONE,
 			"%s: Unable to do AHB reg write\n", __func__);
-		return status;
-	}
-	return 0;
+
+	kfree(data_aligned);
+	return status;
 }
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index ba649be..ead8e7c 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -46,6 +46,8 @@ enum sdio_interrupt_type {
 #define PKT_BUFF_AVAILABLE                      1
 #define FW_ASSERT_IND                           2
 
+#define RSI_MASTER_REG_BUF_SIZE			12
+
 #define RSI_DEVICE_BUFFER_STATUS_REGISTER       0xf3
 #define RSI_FN1_INT_REGISTER                    0xf9
 #define RSI_INT_ENABLE_REGISTER			0x04
-- 
2.7.4
