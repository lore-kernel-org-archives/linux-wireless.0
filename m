Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24631 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753608AbdDEQxW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 12:53:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] ath10k: remove ath10k_sdio_io()
Date: Wed, 5 Apr 2017 16:53:16 +0000
Message-ID: <87vaqig5j7.fsf@kamboji.qca.qualcomm.com> (sfid-20170405_185624_092818_14AEB234)
References: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
        <6a6d8e7f-ccd2-0ee6-bd99-6d82dd906843@gmail.com>
In-Reply-To: <6a6d8e7f-ccd2-0ee6-bd99-6d82dd906843@gmail.com> (Erik
        Stromdahl's message of "Wed, 5 Apr 2017 18:08:16 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> I can't find patch 1/7...

Odd, apparently it didn't get delivered to ath10k list but did get to
linux-wireless. You can find the patch from linux-wireless patchwork:

https://patchwork.kernel.org/patch/9663097/

Also copying it below.

Kalle

Author: Kalle Valo <kvalo@qca.qualcomm.com>
Date:   Tue Mar 28 10:27:00 2017 +0300

    ath10k: add ath10k_sdio_write32/read32()
   =20
    Also remove ath10k_sdio_hif_set_addrwin_reg(), after the conversion it =
looked
    useless.
   =20
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/=
ath/ath10k/sdio.c
index 0dced846035b..c7bc86e5063f 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -263,6 +263,53 @@ static int ath10k_sdio_read_write_sync(struct ath10k *=
ar, u32 addr, u8 *buf,
 	return ath10k_sdio_io(ar, request, addr, buf, len);
 }
=20
+static int ath10k_sdio_write32(struct ath10k *ar, u32 addr, u32 val)
+{
+	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
+	struct sdio_func *func =3D ar_sdio->func;
+	int ret;
+
+	sdio_claim_host(func);
+
+	sdio_writel(func, val, addr, &ret);
+	if (ret) {
+		ath10k_warn(ar, "failed to write 0x%x to address 0x%x: %d\n",
+			    val, addr, ret);
+		goto out;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_SDIO, "sdio write32 addr 0x%x val 0x%x\n",
+		   addr, val);
+
+out:
+	sdio_release_host(func);
+
+	return ret;
+}
+
+static int ath10k_sdio_read32(struct ath10k *ar, u32 addr, u32 *val)
+{
+	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
+	struct sdio_func *func =3D ar_sdio->func;
+	int ret;
+
+	sdio_claim_host(func);
+	*val =3D sdio_readl(func, addr, &ret);
+	if (ret) {
+		ath10k_warn(ar, "failed to read from address 0x%x: %d\n",
+			    addr, ret);
+		goto out;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_SDIO, "sdio read32 addr 0x%x val 0x%x\n",
+		   addr, *val);
+
+out:
+	sdio_release_host(func);
+
+	return ret;
+}
+
 /* HIF mbox functions */
=20
 static int ath10k_sdio_mbox_rx_process_packet(struct ath10k *ar,
@@ -617,27 +664,19 @@ static int ath10k_sdio_mbox_rxmsg_pending_handler(str=
uct ath10k *ar,
=20
 static int ath10k_sdio_mbox_proc_dbg_intr(struct ath10k *ar)
 {
-	u32 *dummy;
+	u32 val;
 	int ret;
=20
-	dummy =3D kzalloc(sizeof(*dummy), GFP_KERNEL);
-	if (!dummy)
-		return -ENOMEM;
-
 	/* TODO: Add firmware crash handling */
 	ath10k_warn(ar, "firmware crashed\n");
=20
 	/* read counter to clear the interrupt, the debug error interrupt is
 	 * counter 0.
 	 */
-	ret =3D ath10k_sdio_read_write_sync(ar, MBOX_COUNT_DEC_ADDRESS,
-					  (u8 *)dummy, sizeof(*dummy),
-					  HIF_RD_SYNC_BYTE_INC);
+	ret =3D ath10k_sdio_read32(ar, MBOX_COUNT_DEC_ADDRESS, &val);
 	if (ret)
 		ath10k_warn(ar, "failed to clear debug interrupt: %d\n", ret);
=20
-	kfree(dummy);
-
 	return ret;
 }
=20
@@ -972,90 +1011,70 @@ static void ath10k_sdio_set_mbox_info(struct ath10k =
*ar)
=20
 static int ath10k_sdio_bmi_credits(struct ath10k *ar)
 {
-	int ret;
-	u32 addr, *cmd_credits;
+	u32 addr, cmd_credits;
 	unsigned long timeout;
-
-	cmd_credits =3D kzalloc(sizeof(*cmd_credits), GFP_KERNEL);
-	if (!cmd_credits)
-		return -ENOMEM;
+	int ret;
=20
 	/* Read the counter register to get the command credits */
 	addr =3D MBOX_COUNT_DEC_ADDRESS + ATH10K_HIF_MBOX_NUM_MAX * 4;
-
 	timeout =3D jiffies + BMI_COMMUNICATION_TIMEOUT_HZ;
-	while (time_before(jiffies, timeout) && !*cmd_credits) {
+	cmd_credits =3D 0;
+
+	while (time_before(jiffies, timeout) && !cmd_credits) {
 		/* Hit the credit counter with a 4-byte access, the first byte
 		 * read will hit the counter and cause a decrement, while the
 		 * remaining 3 bytes has no effect. The rationale behind this
 		 * is to make all HIF accesses 4-byte aligned.
 		 */
-		ret =3D ath10k_sdio_read_write_sync(ar, addr,
-						  (u8 *)cmd_credits,
-						  sizeof(*cmd_credits),
-						  HIF_RD_SYNC_BYTE_INC);
+		ret =3D ath10k_sdio_read32(ar, addr, &cmd_credits);
 		if (ret) {
 			ath10k_warn(ar,
 				    "unable to decrement the command credit count register: %d\n",
 				    ret);
-			goto out;
+			return ret;
 		}
=20
 		/* The counter is only 8 bits.
 		 * Ignore anything in the upper 3 bytes
 		 */
-		*cmd_credits &=3D 0xFF;
+		cmd_credits &=3D 0xFF;
 	}
=20
-	if (!*cmd_credits) {
+	if (!cmd_credits) {
 		ath10k_warn(ar, "bmi communication timeout\n");
-		ret =3D -ETIMEDOUT;
-		goto out;
+		return -ETIMEDOUT;
 	}
=20
-	ret =3D 0;
-
-out:
-	kfree(cmd_credits);
-
-	return ret;
+	return 0;
 }
=20
 static int ath10k_sdio_bmi_get_rx_lookahead(struct ath10k *ar)
 {
 	unsigned long timeout;
-	u32 *rx_word;
+	u32 rx_word;
 	int ret;
=20
-	rx_word =3D kzalloc(sizeof(*rx_word), GFP_KERNEL);
-	if (!rx_word)
-		return -ENOMEM;
-
 	timeout =3D jiffies + BMI_COMMUNICATION_TIMEOUT_HZ;
-	while ((time_before(jiffies, timeout)) && !*rx_word) {
-		ret =3D ath10k_sdio_read_write_sync(ar,
-						  MBOX_HOST_INT_STATUS_ADDRESS,
-						  (u8 *)rx_word,
-						  sizeof(*rx_word),
-						  HIF_RD_SYNC_BYTE_INC);
+	rx_word =3D 0;
+
+	while ((time_before(jiffies, timeout)) && !rx_word) {
+		ret =3D ath10k_sdio_read32(ar,
+					 MBOX_HOST_INT_STATUS_ADDRESS,
+					 &rx_word);
 		if (ret) {
 			ath10k_warn(ar, "unable to read RX_LOOKAHEAD_VALID: %d\n", ret);
-			goto out;
+			return ret;
 		}
=20
 		 /* all we really want is one bit */
-		*rx_word &=3D 1;
+		rx_word &=3D 1;
 	}
=20
-	if (!*rx_word) {
+	if (!rx_word) {
 		ath10k_warn(ar, "bmi_recv_buf FIFO empty\n");
-		ret =3D -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
=20
-out:
-	kfree(rx_word);
-
 	return ret;
 }
=20
@@ -1464,69 +1483,29 @@ static int ath10k_sdio_hif_enable_intrs(struct ath1=
0k *ar)
=20
 static int ath10k_sdio_hif_set_mbox_sleep(struct ath10k *ar, bool enable_s=
leep)
 {
-	u32 *val;
+	u32 val;
 	int ret;
=20
-	val =3D kzalloc(sizeof(*val), GFP_KERNEL);
-	if (!val)
-		return -ENOMEM;
-
-	ret =3D ath10k_sdio_read_write_sync(ar, FIFO_TIMEOUT_AND_CHIP_CONTROL,
-					  (u8 *)val, sizeof(*val),
-					  HIF_RD_SYNC_BYTE_INC);
+	ret =3D ath10k_sdio_read32(ar, FIFO_TIMEOUT_AND_CHIP_CONTROL, &val);
 	if (ret) {
 		ath10k_warn(ar, "failed to read fifo/chip control register: %d\n",
 			    ret);
-		goto out;
+		return ret;
 	}
=20
 	if (enable_sleep)
-		*val &=3D FIFO_TIMEOUT_AND_CHIP_CONTROL_DISABLE_SLEEP_OFF;
+		val &=3D FIFO_TIMEOUT_AND_CHIP_CONTROL_DISABLE_SLEEP_OFF;
 	else
-		*val |=3D FIFO_TIMEOUT_AND_CHIP_CONTROL_DISABLE_SLEEP_ON;
-
-	ret =3D ath10k_sdio_read_write_sync(ar, FIFO_TIMEOUT_AND_CHIP_CONTROL,
-					  (u8 *)val, sizeof(*val),
-					  HIF_WR_SYNC_BYTE_INC);
-	if (ret)
-		goto out;
-
-	ret =3D 0;
-
-out:
-	kfree(val);
-
-	return ret;
-}
-
-/* set the window address register (using 4-byte register access ). */
-static int ath10k_sdio_hif_set_addrwin_reg(struct ath10k *ar, u32 reg_addr=
,
-					   u32 addr)
-{
-	u32 *tmp_addr;
-	int ret;
-
-	tmp_addr =3D kmalloc(sizeof(addr), GFP_KERNEL);
-	if (!tmp_addr)
-		return -ENOMEM;
-
-	*tmp_addr =3D addr;
-	ret =3D ath10k_sdio_read_write_sync(ar, reg_addr, (u8 *)tmp_addr,
-					  4, HIF_WR_SYNC_BYTE_INC);
+		val |=3D FIFO_TIMEOUT_AND_CHIP_CONTROL_DISABLE_SLEEP_ON;
=20
+	ret =3D ath10k_sdio_write32(ar, FIFO_TIMEOUT_AND_CHIP_CONTROL, val);
 	if (ret) {
-		ath10k_warn(ar,
-			    "failed to write 0x%x to window reg: %d\n",
-			    reg_addr, ret);
-		goto out;
+		ath10k_warn(ar, "failed to write to FIFO_TIMEOUT_AND_CHIP_CONTROL: %d",
+			    ret);
+		return ret;
 	}
=20
-	ret =3D 0;
-
-out:
-	kfree(tmp_addr);
-
-	return ret;
+	return 0;
 }
=20
 /* HIF diagnostics */
@@ -1537,11 +1516,11 @@ static int ath10k_sdio_hif_diag_read(struct ath10k =
*ar, u32 address, void *buf,
 	int ret;
=20
 	/* set window register to start read cycle */
-	ret =3D ath10k_sdio_hif_set_addrwin_reg(ar,
-					      MBOX_WINDOW_READ_ADDR_ADDRESS,
-					      address);
-	if (ret)
+	ret =3D ath10k_sdio_write32(ar, MBOX_WINDOW_READ_ADDR_ADDRESS, address);
+	if (ret) {
+		ath10k_warn(ar, "failed to set mbox window read address: %d", ret);
 		return ret;
+	}
=20
 	/* read the data */
 	ret =3D ath10k_sdio_read_write_sync(ar, MBOX_WINDOW_DATA_ADDRESS,
@@ -1595,9 +1574,13 @@ static int ath10k_sdio_hif_diag_write_mem(struct ath=
10k *ar, u32 address,
 	}
=20
 	/* set window register, which starts the write cycle */
-	return ath10k_sdio_hif_set_addrwin_reg(ar,
-					       MBOX_WINDOW_WRITE_ADDR_ADDRESS,
-					       address);
+	ret =3D ath10k_sdio_write32(ar, MBOX_WINDOW_WRITE_ADDR_ADDRESS, address);
+	if (ret) {
+		ath10k_warn(ar, "failed to set mbox window write address: %d", ret);
+		return ret;
+	}
+
+	return 0;
 }
=20
 /* HIF start/stop */
diff --git a/drivers/net/wireless/ath/ath10k/sdio.h b/drivers/net/wireless/=
ath/ath10k/sdio.h
index bc8d6e5342ea..d1e4f78ddaeb 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.h
+++ b/drivers/net/wireless/ath/ath10k/sdio.h
@@ -168,9 +168,6 @@ struct ath10k_sdio_rx_data {
 #define HIF_RD_SYNC_BYTE_INC						\
 	(HIF_READ | HIF_BYTE_BASIS | HIF_INCREMENTAL_ADDRESS)
=20
-#define HIF_RD_SYNC_BYTE_FIX						\
-	(HIF_READ | HIF_BYTE_BASIS | HIF_FIXED_ADDRESS)
-
 #define HIF_RD_SYNC_BLOCK_FIX						\
 	(HIF_READ | HIF_BLOCK_BASIS | HIF_FIXED_ADDRESS)
 =
