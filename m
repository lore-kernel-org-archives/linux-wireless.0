Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792796535;
	b=sBs2RgNBOjIwTLu77+tE3m6o5X47V0xEwGTTKHYEsR4yb9u0wBbcV8dBgsDWbHiM9YOI
	 YTzGU5fS+fW9uafR150bYU0trJIjfUKks/ItEb8lINgKrzqx1s3lqgcfIQqRgx5O+/7NV
	 NqN1pTwfwfvpj+wGrVXAPOpC6E1EF0fBstOFUECdaSacL0LqIiiykkNqogf93TMsEjsM4
	 ICXSbo2f9jOkLqWJ5bLsnRxJiphUUIsbDGgt8NSMXQ8ILn6AaKTdz6mVa/2dJO/YByKEB
	 Q5BFm/AjtWyr8Ll4guVQXUMUJHc6f+nBVTXmlB4gMNldEaDYG1+4WBlhOct8ruhYq5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792796535;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=YROaAk07jS+ry0tSFW0rxX+MRMzWpCBk2u6ljn+Kn2c=;
	b=aBnwNFC/j4lbNemNqwmm7ZtS/X2xRnSvl0ebzwv9WzzdYYcujjIG7VVsl4PgJQ9eZObN
	 CG+CfFgxFKSk8mBwLJ92ug7aKMGINozmDJKFM4aMdw+qwGc7DND95Q4ChGo3PwLqyzzON
	 1x7j1aO9oOUeSKBgxVT5wIoU3px4X/fNfLAqrgFBfIhIcSJi40gP54CZ6yNkuT5A0PR0Z
	 XoEhCbKRROW+CZm+ERK9uj4pv/EGeUEmavLYtUaez6tgGHe3YTvEqRF3hMepV48EClbWc
	 3kdxSrQF+6wYE9ec2mzzmtRa/eWNKB1LS6HnMB4nHpoN+lmzOYx+rRrtkYp51OFNRJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Wp/dW7Vy";
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C92606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 23:02:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14C92606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Wp/dW7Vy
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-487049569b6so779512f8f.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 16:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796533; x=1793401333; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YROaAk07jS+ry0tSFW0rxX+MRMzWpCBk2u6ljn+Kn2c=;
        b=Wp/dW7VyRApfDH17TCGwNFPzv7eGFGyT3eJ/coW4BWRt5yFuTKUdqwcBBYe8KFXO+n
         Ydhn+xtgn2aAsUYXiW5VRz2UUFQb2vf/caEcNeMclIkU/TnfnJF4MnbQUx+Umyg+E9n2
         tkvJVy8PYIS4qUlf7mOuohX1JYc9zJcdoCcBie8OwBxf9TIMUTy59qysDhMzxTu9e42R
         copLWx/Ueh7cA6rE8dU5aJOyHwGrV/jndXRXj6TodbtnxBDZX9zQLKfPNp/gvgC3v5vu
         xT0qxkh99oKhQdN40ygB90moUonPlck3yyBAmlVnJ80dzOiH/4EvuaofN0Sqp0dAs80i
         CtVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796533; x=1793401333;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YROaAk07jS+ry0tSFW0rxX+MRMzWpCBk2u6ljn+Kn2c=;
        b=JNlrF04/ax5Fs/UqY052Bb7lOHpagD5LyUqU8rkKm4FdE0Qbx5wmbzuAMaX7hpBqKv
         TWbmK5s9cSxl8rWQv1m8l1ylpjTzl7h56qdNujmojtkaQ6Nbeieybq4Ti47k5EMR2TVM
         EkLpC5VTfo7zY7KkCUsicZxWyrPWvVfWEUWlLJkK7KXpAZLGk1w2a9F9O/SJE5Mb8r+L
         T4onXUfQz0q0NbRszcsd6jF31yXnbzTFvDAHkN26v5omwCvRSvEcL+7EW/loPe285Dmu
         IRCiUbYceLBEto9oiva79fy9F4kM8e3FZNN/OK1UBYr9zUBEPv2AyrGSBlk+kIcMQehG
         g5KA==
X-Gm-Message-State: AFq9FYIgMie6st/7G0ryWcRZi1fL5l/5bAsbw8knHQ7glYJ1Q3CN9mQF
	ccAMPTUY9TWOt/JXF1FYvgmu/N5G4+DOicBGIO7mU4Kd0O3qnEMSMkQI9YAecA==
X-Gm-Gg: AYBFou3SoYanUgVtrYiS8cNBruKbSPWdjUuyrRnTXnUs+1Gy2rUX6C6z7dddmusM+ot
	LzLZct7tfe6vvSSDvG3j4RWOqzoKrGC63WMGNj1BNRmVbpUCrZlhlCib96a7gdnxZh8nc64O8MF
	RtaIEw2AzzvO+sMUYlfUwNhS8FQgt+BhlL+wY77NYOq3d8GwbxTpRdCghb5RNV9AovujToWRrzW
	TXCWq/rqYriSsyELUzSe0jvu/6p0Z8CXprfJjVJ0i0RtHN2TVi18SY5ADYzasLwjdYx0gmzxQ2M
	rJ4EhV3fE+pLvkkUUGxwD65CMA6Mh1ZzO/QRCs1nZ3OOd97GIwtw1LL2/R8rGIdBP0C9hvmmzU3
	W8vazSwo2REIzO6/KIHHH7Gg4y5GOYUj5NyTCqFaMpHCjsW4drHIYFwn7GLUoP+fuXk3Voyz7DF
	ApYDKI/mzW4Af5nyp3PliQZ1fd44oDQHGM2jRQ2XH0xDi1K3edXkVWXo1cU27GlcentTpnu4H2/
	L6dJICf/3C/nz1CeKiwgsuvoKtMzVMzahGpZbgMsmS33lsZSevxe2tuOe3VHzWHeSISJgJS7ew3
	6BXDFwgsWA==
X-Received: by 2002:a05:6000:188a:b0:48d:fbee:3dec with SMTP id ffacd0b85a97d-48e3eb8d50emr662722f8f.29.1792796533218;
        Fri, 23 Oct 2026 16:02:13 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd354asm752274f8f.43.2026.10.23.16.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 16:02:12 -0700 (PDT)
Message-ID: <35e9d20a-4f0c-42c3-9d06-358a5620251c@gmail.com>
Date: Sat, 24 Oct 2026 02:02:10 +0300
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH rtw-next 4/5] wifi: rtw88: pci: Add functions to support older
 chips
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Language: en-US
In-Reply-To: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Add pci_old.{c,h} to support older chips, like RTL8821AE and RTL8812AE.
They handle the PCI communications differently.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/Makefile  |   2 +-
 drivers/net/wireless/realtek/rtw88/pci.c     |   9 +-
 drivers/net/wireless/realtek/rtw88/pci.h     |   6 +
 drivers/net/wireless/realtek/rtw88/pci_old.c | 522 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/pci_old.h |  39 ++
 drivers/net/wireless/realtek/rtw88/reg.h     |   3 +
 drivers/net/wireless/realtek/rtw88/rx.h      |   4 +
 drivers/net/wireless/realtek/rtw88/tx.h      |   5 +
 8 files changed, 584 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci_old.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci_old.h

diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index 6889b3796449..d4007ca2b2ca 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -110,7 +110,7 @@ obj-$(CONFIG_RTW88_8814AU)	+= rtw88_8814au.o
 rtw88_8814au-objs		:= rtw8814au.o
 
 obj-$(CONFIG_RTW88_PCI)		+= rtw88_pci.o
-rtw88_pci-objs			:= pci.o
+rtw88_pci-objs			:= pci.o pci_old.o
 
 obj-$(CONFIG_RTW88_SDIO)	+= rtw88_sdio.o
 rtw88_sdio-objs			:= sdio.o
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index c51ad15cfba7..35f45e3ede81 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -16,7 +16,7 @@
 #include "mac.h"
 
 static bool rtw_disable_msi;
-static bool rtw_pci_disable_aspm;
+bool rtw_pci_disable_aspm;
 module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
 module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
 MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
@@ -32,8 +32,7 @@ static const u32 rtw_pci_tx_queue_idx_addr[] = {
 	[RTW_TX_QUEUE_H2C]	= RTK_PCI_TXBD_IDX_H2CQ,
 };
 
-static u8 rtw_pci_get_tx_qsel(struct sk_buff *skb,
-			      enum rtw_tx_queue_type queue)
+u8 rtw_pci_get_tx_qsel(struct sk_buff *skb, enum rtw_tx_queue_type queue)
 {
 	switch (queue) {
 	case RTW_TX_QUEUE_BCN:
@@ -675,8 +674,8 @@ static void rtw_pci_deep_ps(struct rtw_dev *rtwdev, bool enter)
 	spin_unlock_bh(&rtwpci->irq_lock);
 }
 
-static void rtw_pci_release_rsvd_page(struct rtw_pci *rtwpci,
-				      struct rtw_pci_tx_ring *ring)
+void rtw_pci_release_rsvd_page(struct rtw_pci *rtwpci,
+			       struct rtw_pci_tx_ring *ring)
 {
 	struct sk_buff *prev = skb_dequeue(&ring->queue);
 	struct rtw_pci_tx_data *tx_data;
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 5ab78ba3255d..92532f842ebc 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -144,6 +144,8 @@
 /* IMR 3 */
 #define IMR_H2CDOK		BIT(16)
 
+extern bool rtw_pci_disable_aspm;
+
 enum rtw_pci_flags {
 	RTW_PCI_FLAG_NAPI_RUNNING,
 
@@ -268,6 +270,10 @@ extern const struct dev_pm_ops rtw_pm_ops;
 extern const struct pci_error_handlers rtw_pci_err_handler;
 extern const struct rtw_pci_gen rtw_pci_gen_new;
 
+u8 rtw_pci_get_tx_qsel(struct sk_buff *skb, enum rtw_tx_queue_type queue);
+void rtw_pci_release_rsvd_page(struct rtw_pci *rtwpci,
+			       struct rtw_pci_tx_ring *ring);
+
 int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
 void rtw_pci_remove(struct pci_dev *pdev);
 void rtw_pci_shutdown(struct pci_dev *pdev);
diff --git a/drivers/net/wireless/realtek/rtw88/pci_old.c b/drivers/net/wireless/realtek/rtw88/pci_old.c
new file mode 100644
index 000000000000..464b57d8a629
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/pci_old.c
@@ -0,0 +1,522 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2026  Realtek Corporation
+ */
+
+#include <linux/pci.h>
+#include "main.h"
+#include "debug.h"
+#include "fw.h"
+#include "pci.h"
+#include "pci_old.h"
+#include "reg.h"
+#include "rx.h"
+#include "tx.h"
+
+static int rtw_pci_old_init_tx_ring(struct rtw_dev *rtwdev,
+				    struct rtw_pci_tx_ring *tx_ring,
+				    u8 desc_size, u32 len)
+{
+	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
+	struct rtw_tx_desc_pci_old *tx_desc;
+	int ring_sz = desc_size * len;
+	dma_addr_t dma, next;
+	u8 *head;
+	int i;
+
+	head = dma_alloc_coherent(&pdev->dev, ring_sz, &dma, GFP_KERNEL);
+	if (!head) {
+		rtw_err(rtwdev, "failed to allocate tx ring\n");
+		return -ENOMEM;
+	}
+
+	skb_queue_head_init(&tx_ring->queue);
+	tx_ring->r.head = head;
+	tx_ring->r.dma = dma;
+	tx_ring->r.len = len;
+	tx_ring->r.desc_size = desc_size;
+	tx_ring->r.wp = 0;
+	tx_ring->r.rp = 0;
+
+	tx_desc = (struct rtw_tx_desc_pci_old *)head;
+
+	for (i = 0; i < len; i++) {
+		next = dma + ((i + 1) % len) * desc_size;
+
+		le32p_replace_bits(&tx_desc[i].w12, next,
+				   RTW_TX_DESC_W12_NEXT_DESC_ADDRESS);
+	}
+
+	return 0;
+}
+
+static int rtw_pci_old_reset_rx_desc(struct rtw_dev *rtwdev,
+				     struct sk_buff *skb,
+				     struct rtw_pci_rx_ring *rx_ring,
+				     u32 idx, u32 desc_sz)
+{
+	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
+	struct rtw_rx_desc_pci_old *rx_desc;
+	dma_addr_t dma;
+
+	if (!skb)
+		return -EINVAL;
+
+	dma = dma_map_single(&pdev->dev, skb->data, RTK_PCI_RX_BUF_SIZE,
+			     DMA_FROM_DEVICE);
+	if (dma_mapping_error(&pdev->dev, dma))
+		return -EBUSY;
+
+	*((dma_addr_t *)skb->cb) = dma;
+
+	rx_desc = (struct rtw_rx_desc_pci_old *)rx_ring->r.head;
+
+	memset(&rx_desc[idx], 0, sizeof(*rx_desc));
+
+	le32p_replace_bits(&rx_desc[idx].w6, dma, RTW_RX_DESC_W6_BUF_ADDR);
+	le32p_replace_bits(&rx_desc[idx].w0_5.w0, RTK_PCI_RX_BUF_SIZE,
+			   RTW_RX_DESC_W0_PKT_LEN);
+	le32p_replace_bits(&rx_desc[idx].w0_5.w0, 1, RTW_RX_DESC_W0_OWN);
+
+	if (idx == rx_ring->r.len - 1)
+		le32p_replace_bits(&rx_desc[idx].w0_5.w0, 1,
+				   RTW_RX_DESC_W0_EOR);
+
+	return 0;
+}
+
+static void rtw_pci_old_reset_buf_desc(struct rtw_dev *rtwdev)
+{
+	static const u32 addr[] = {
+		[RTW_TX_QUEUE_BK]	= REG_BKQ_DESA,
+		[RTW_TX_QUEUE_BE]	= REG_BEQ_DESA,
+		[RTW_TX_QUEUE_VI]	= REG_VIQ_DESA,
+		[RTW_TX_QUEUE_VO]	= REG_VOQ_DESA,
+		[RTW_TX_QUEUE_BCN]	= REG_BCNQ_DESA,
+		[RTW_TX_QUEUE_MGMT]	= REG_MGQ_DESA,
+		[RTW_TX_QUEUE_HI0]	= REG_HQ_DESA,
+	};
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	struct rtw_pci_tx_ring *ring;
+	u8 queue;
+
+	for (queue = 0; queue <= RTW_TX_QUEUE_HI0; queue++) {
+		ring = &rtwpci->tx_rings[queue];
+
+		ring->r.rp = 0;
+		ring->r.wp = 0;
+		rtw_write32(rtwdev, addr[queue], ring->r.dma);
+	}
+
+	rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.rp = 0;
+	rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.wp = 0;
+	rtw_write32(rtwdev, REG_RX_DESA,
+		    rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.dma);
+
+	rtw_write8(rtwdev, RTK_PCI_CTRL + 3, 0x77);
+}
+
+static void rtw_pci_old_reset_dma(struct rtw_dev *rtwdev)
+{
+	u8 mac_power_on, trx_hang, pcie_dma_pause;
+	u32 rxdma;
+
+	mac_power_on = rtw_read8(rtwdev, REG_CR);
+	if (mac_power_on == 0xea)
+		mac_power_on = 0;
+
+	if (!rtw_read8_mask(rtwdev, REG_DBI_CTRL + 3, BIT(2))) {
+		rtw_write8_set(rtwdev, REG_DBI_CTRL + 3, BIT(2));
+		msleep(100);
+	}
+
+	trx_hang = rtw_read8_mask(rtwdev, REG_DBI_CTRL + 3, GENMASK(1, 0));
+
+	if (!trx_hang)
+		return;
+
+	if (trx_hang & BIT(0))
+		rtw_warn(rtwdev, "PCIe TX hang detected, resetting\n");
+
+	if (trx_hang & BIT(1))
+		rtw_warn(rtwdev, "PCIe RX hang detected, resetting\n");
+
+	/* 1. Disable register write lock. */
+	rtw_write8_clr(rtwdev, REG_RSV_CTRL, BIT(1));
+	if (rtwdev->chip->id != RTW_CHIP_TYPE_8812A)
+		rtw_write8_set(rtwdev, REG_PMC_DBG_CTRL2, BIT(2));
+
+	/* 2. Check and pause TRX DMA */
+	rxdma = rtw_read32(rtwdev, REG_RXPKT_NUM);
+	if (!(rxdma & BIT_RW_RELEASE))
+		rtw_write32(rtwdev, REG_RXPKT_NUM, rxdma | BIT_RW_RELEASE);
+
+	pcie_dma_pause = rtw_read8(rtwdev, RTK_PCI_CTRL + 1);
+	if (pcie_dma_pause != 0xFF)
+		rtw_write8(rtwdev, RTK_PCI_CTRL + 1, 0xFF);
+
+	if (mac_power_on)
+		/* 3. reset TRX function */
+		rtw_write8(rtwdev, REG_CR, 0);
+
+	/* 4. Reset PCIe DMA. */
+	rtw_write16_clr(rtwdev, REG_SYS_FUNC_EN, BIT_FEN_PCIED);
+
+	/* 5. Enable PCIe DMA. */
+	rtw_write16_set(rtwdev, REG_SYS_FUNC_EN, BIT_FEN_PCIED);
+
+	if (mac_power_on)
+		/* 6. enable TRX function */
+		rtw_write8(rtwdev, REG_CR, 0xFF);
+
+	/*
+	 * 7. Restore PCIe autoload down bit. 8812AE does not have
+	 * the definition.
+	 */
+	if (rtwdev->chip->id != RTW_CHIP_TYPE_8812A)
+		rtw_write8_set(rtwdev, REG_SYS_STATUS2 + 2, BIT(1));
+
+	/* 8. release TRX DMA */
+	if (!(rxdma & BIT_RW_RELEASE))
+		rtw_write32_clr(rtwdev, REG_RXPKT_NUM, BIT_RW_RELEASE);
+
+	rtw_write8(rtwdev, RTK_PCI_CTRL + 1, pcie_dma_pause);
+
+	/* 9. lock system register */
+	if (rtwdev->chip->id != RTW_CHIP_TYPE_8812A)
+		rtw_write8_clr(rtwdev, REG_PMC_DBG_CTRL2, BIT(2));
+}
+
+static int rtw_pci_old_reset(struct rtw_dev *rtwdev)
+{
+	rtw_pci_old_reset_dma(rtwdev);
+
+	rtw_pci_old_reset_buf_desc(rtwdev);
+
+	rtw_write32(rtwdev, REG_INT_MIG, 0);
+
+	rtw_write32(rtwdev, REG_MCUTST_1, 0);
+
+	rtw_write8(rtwdev, REG_MISC_CTRL, BIT_DIS_SECOND_CCA);
+
+	return 0;
+}
+
+static void rtw_pci_old_flush_queue(struct rtw_dev *rtwdev, u8 pci_q, bool drop)
+{
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	struct rtw_pci_tx_ring *ring = &rtwpci->tx_rings[pci_q];
+	u8 i;
+
+	/*
+	 * Because the time taked by the I/O in __pci_get_hw_tx_ring_rp is a
+	 * bit dynamic, it's hard to define a reasonable fixed total timeout to
+	 * use read_poll_timeout* helper. Instead, we can ensure a reasonable
+	 * polling times, so we just use for loop with udelay here.
+	 */
+	for (i = 0; i < 50; i++) {
+		if (skb_queue_len(&ring->queue) == 0)
+			return;
+
+		udelay(1);
+	}
+
+	if (!drop)
+		rtw_dbg(rtwdev, RTW_DBG_UNEXP,
+			"timed out to flush pci tx ring[%d]\n", pci_q);
+}
+
+static void rtw_pci_old_tx_kick_off_queue(struct rtw_dev *rtwdev,
+					  enum rtw_tx_queue_type queue)
+{
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	u16 queue_bit;
+
+	spin_lock_bh(&rtwpci->irq_lock);
+
+	if (queue >= RTW_TX_QUEUE_MGMT)
+		queue_bit = BIT(queue + 1);
+	else
+		queue_bit = BIT(queue);
+
+	rtw_write16(rtwdev, RTK_PCI_CTRL, queue_bit);
+
+	spin_unlock_bh(&rtwpci->irq_lock);
+}
+
+static int rtw_pci_old_tx_write_data(struct rtw_dev *rtwdev,
+				     struct rtw_tx_pkt_info *pkt_info,
+				     struct sk_buff *skb,
+				     enum rtw_tx_queue_type queue)
+{
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	struct rtw_tx_desc_pci_old *tx_desc;
+	struct rtw_tx_desc tmp_tx_desc = {};
+	struct rtw_pci_tx_data *tx_data;
+	struct rtw_pci_tx_ring *ring;
+	dma_addr_t dma;
+	u32 wp;
+
+	ring = &rtwpci->tx_rings[queue];
+
+	wp = ring->r.wp;
+	tx_desc = (struct rtw_tx_desc_pci_old *)ring->r.head;
+
+	if (queue == RTW_TX_QUEUE_BCN)
+		rtw_pci_release_rsvd_page(rtwpci, ring);
+	else if (le32_get_bits(tx_desc[wp].w0_9.w0, RTW_TX_DESC_W0_OWN))
+		return -ENOSPC;
+
+	dma = dma_map_single(&rtwpci->pdev->dev, skb->data, skb->len,
+			     DMA_TO_DEVICE);
+	if (dma_mapping_error(&rtwpci->pdev->dev, dma))
+		return -EBUSY;
+
+	pkt_info->qsel = rtw_pci_get_tx_qsel(skb, queue);
+
+	rtw_tx_fill_tx_desc(rtwdev, pkt_info, &tmp_tx_desc);
+
+	/*
+	 * OWN (same bit as DISQSELSEQ) can only be set when everything
+	 * is ready for DMA, or bad things will happen.
+	 */
+	le32p_replace_bits(&tmp_tx_desc.w0, 0, RTW_TX_DESC_W0_OWN);
+
+	memcpy(&tx_desc[wp].w0_9, &tmp_tx_desc, sizeof(tmp_tx_desc));
+
+	le32p_replace_bits(&tx_desc[wp].w0_9.w0, 1, RTW_TX_DESC_W0_FS);
+	le32p_replace_bits(&tx_desc[wp].w0_9.w7, skb->len,
+			   RTW_TX_DESC_W7_TX_BUFFER_SIZE);
+	le32p_replace_bits(&tx_desc[wp].w10, dma,
+			   RTW_TX_DESC_W10_TX_BUFFER_ADDRESS);
+
+	tx_data = rtw_pci_get_tx_data(skb);
+	tx_data->dma = dma;
+	tx_data->sn = pkt_info->sn;
+
+	spin_lock_bh(&rtwpci->irq_lock);
+
+	skb_queue_tail(&ring->queue, skb);
+
+	/* The hardware must see this bit after all of the above. */
+	wmb();
+	le32p_replace_bits(&tx_desc[wp].w0_9.w0, 1, RTW_TX_DESC_W0_OWN);
+
+	if (queue == RTW_TX_QUEUE_BCN)
+		goto out_unlock;
+
+	/* update write-index, and kick it off later */
+	set_bit(queue, rtwpci->tx_queued);
+
+	ring->r.wp = (ring->r.wp + 1) % ring->r.len;
+
+out_unlock:
+	spin_unlock_bh(&rtwpci->irq_lock);
+
+	return 0;
+}
+
+static void rtw_pci_old_kick_beacon_queue(struct rtw_dev *rtwdev)
+{
+	rtw_write16(rtwdev, RTK_PCI_CTRL, BIT(RTW_TX_QUEUE_BCN));
+}
+
+static void rtw_pci_old_tx_isr(struct rtw_dev *rtwdev,
+			       struct rtw_pci *rtwpci, u8 hw_queue)
+{
+	struct ieee80211_hw *hw = rtwdev->hw;
+	struct rtw_tx_desc_pci_old *tx_desc;
+	struct rtw_pci_tx_data *tx_data;
+	struct ieee80211_tx_info *info;
+	struct rtw_pci_tx_ring *ring;
+	struct sk_buff *skb;
+	dma_addr_t dma;
+
+	ring = &rtwpci->tx_rings[hw_queue];
+
+	tx_desc = (struct rtw_tx_desc_pci_old *)ring->r.head;
+
+	while (skb_queue_len(&ring->queue)) {
+		if (le32_get_bits(tx_desc[ring->r.rp].w0_9.w0,
+				  RTW_TX_DESC_W0_OWN))
+			return;
+
+		skb = skb_dequeue(&ring->queue);
+
+		tx_data = rtw_pci_get_tx_data(skb);
+
+		dma = le32_get_bits(tx_desc[ring->r.rp].w10,
+				    RTW_TX_DESC_W10_TX_BUFFER_ADDRESS);
+
+		if (dma != tx_data->dma)
+			rtw_err(rtwdev,
+				"tx_data dma %pad != tx_desc dma %pad\n",
+				&tx_data->dma, &dma);
+
+		dma_unmap_single(&rtwpci->pdev->dev, dma, skb->len,
+				 DMA_TO_DEVICE);
+
+		ring->r.rp = (ring->r.rp + 1) % ring->r.len;
+
+		if (ring->queue_stopped &&
+		    avail_desc(ring->r.wp, ring->r.rp, ring->r.len) <= 4) {
+			ieee80211_wake_queue(hw, skb_get_queue_mapping(skb));
+			ring->queue_stopped = false;
+		}
+
+		info = IEEE80211_SKB_CB(skb);
+
+		/* enqueue to wait for tx report */
+		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
+			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
+			continue;
+		}
+
+		/* always ACK for others, then they won't be marked as drop */
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+			info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+		else
+			info->flags |= IEEE80211_TX_STAT_ACK;
+
+		ieee80211_tx_info_clear_status(info);
+		ieee80211_tx_status_irqsafe(hw, skb);
+	}
+}
+
+static int rtw_pci_old_get_hw_rx_ring_nr(struct rtw_dev *rtwdev,
+					 struct rtw_pci *rtwpci)
+{
+	/*
+	 * TODO: is it correct? it seems to work, but should we count
+	 * the number of occupied buffers for rtw_pci_napi_poll?
+	 */
+	return 0;
+}
+
+static u32 rtw_pci_old_rx_napi(struct rtw_dev *rtwdev,
+			       struct rtw_pci *rtwpci,
+			       u8 hw_queue, u32 limit)
+{
+	struct rtw_pci_rx_ring *ring = &rtwpci->rx_rings[RTW_RX_QUEUE_MPDU];
+	struct ieee80211_rx_status rx_status;
+	struct rtw_rx_desc_pci_old *rx_desc;
+	struct device *dev = rtwdev->dev;
+	struct rtw_rx_pkt_stat pkt_stat;
+	struct sk_buff *skb, *new;
+	u32 cur_rp = ring->r.rp;
+	u32 count, rx_done = 0;
+	dma_addr_t dma;
+	u32 pkt_offset;
+	u32 new_len;
+	u8 *rx_buf;
+	int ret;
+
+	rx_desc = (struct rtw_rx_desc_pci_old *)ring->r.head;
+
+	count = min(ring->r.len, limit);
+
+	while (count--) {
+		/* Wait for data to be filled by hardware */
+		if (le32_get_bits(rx_desc[cur_rp].w0_5.w0, RTW_RX_DESC_W0_OWN))
+			break;
+
+		skb = ring->buf[cur_rp];
+		dma = *((dma_addr_t *)skb->cb);
+		dma_sync_single_for_cpu(dev, dma, RTK_PCI_RX_BUF_SIZE,
+					DMA_FROM_DEVICE);
+
+		rx_buf = skb->data;
+		ret = rtw_rx_query_rx_desc(rtwdev, &rx_desc[cur_rp].w0_5,
+					   rx_buf, &pkt_stat, &rx_status);
+		if (ret)
+			goto next_rp;
+
+		pkt_offset = pkt_stat.shift + pkt_stat.drv_info_sz;
+
+		new_len = pkt_stat.pkt_len + pkt_offset;
+		new = dev_alloc_skb(new_len);
+		if (WARN_ONCE(!new, "rx routine starvation\n"))
+			goto next_rp;
+
+		skb_put_data(new, skb->data, new_len);
+
+		if (pkt_stat.is_c2h) {
+			rtw_fw_c2h_cmd_rx_irqsafe(rtwdev, pkt_offset, new);
+		} else {
+			/* remove phy_status */
+			skb_pull(new, pkt_offset);
+
+			rtw_rx_stats(rtwdev, pkt_stat.vif, new);
+			memcpy(new->cb, &rx_status, sizeof(rx_status));
+			ieee80211_rx_napi(rtwdev->hw, NULL, new, &rtwpci->napi);
+			rx_done++;
+		}
+
+next_rp:
+		/* new skb delivered to mac80211, re-enable original skb DMA */
+		dma_sync_single_for_device(dev, dma, RTK_PCI_RX_BUF_SIZE,
+					   DMA_FROM_DEVICE);
+
+		/* Reset the descriptor */
+		le32p_replace_bits(&rx_desc[cur_rp].w6, dma, RTW_RX_DESC_W6_BUF_ADDR);
+		le32p_replace_bits(&rx_desc[cur_rp].w0_5.w0,
+				   RTK_PCI_RX_BUF_SIZE, RTW_RX_DESC_W0_PKT_LEN);
+		/* The hardware must see this bit after all of the above. */
+		wmb();
+		le32p_replace_bits(&rx_desc[cur_rp].w0_5.w0, 1,
+				   RTW_RX_DESC_W0_OWN);
+
+		if (cur_rp == ring->r.len - 1)
+			le32p_replace_bits(&rx_desc[cur_rp].w0_5.w0, 1,
+					   RTW_RX_DESC_W0_EOR);
+
+		cur_rp = (cur_rp + 1) % ring->r.len;
+	}
+
+	ring->r.rp = cur_rp;
+
+	return rx_done;
+}
+
+static void rtw_pci_old_clkreq_set(struct rtw_dev *rtwdev, bool enable)
+{
+}
+
+static void rtw_pci_old_aspm_set(struct rtw_dev *rtwdev, bool enable)
+{
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	struct pci_dev *pdev = rtwpci->pdev;
+
+	if (rtw_pci_disable_aspm)
+		return;
+
+	if (enable) {
+		pcie_capability_set_word(pdev, PCI_EXP_LNKCTL,
+			PCI_EXP_LNKCTL_CCC | PCI_EXP_LNKCTL_ASPMC);
+
+		pcie_capability_set_word(pdev, PCI_EXP_LNKCTL,
+					 PCI_EXP_LNKCTL_CLKREQ_EN);
+	} else {
+		pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_CLKREQ_EN);
+
+		pcie_capability_clear_and_set_word(pdev, PCI_EXP_LNKCTL,
+			PCI_EXP_LNKCTL_CCC | PCI_EXP_LNKCTL_ASPMC,
+			PCI_EXP_LNKCTL_CCC);
+	}
+}
+
+const struct rtw_pci_gen rtw_pci_gen_old = {
+	.init_tx_ring = rtw_pci_old_init_tx_ring,
+	.reset_rx_desc = rtw_pci_old_reset_rx_desc,
+	.reset = rtw_pci_old_reset,
+	.flush_queue = rtw_pci_old_flush_queue,
+	.tx_kick_off_queue = rtw_pci_old_tx_kick_off_queue,
+	.tx_write_data = rtw_pci_old_tx_write_data,
+	.kick_beacon_queue = rtw_pci_old_kick_beacon_queue,
+	.tx_isr = rtw_pci_old_tx_isr,
+	.get_hw_rx_ring_nr = rtw_pci_old_get_hw_rx_ring_nr,
+	.rx_napi = rtw_pci_old_rx_napi,
+	.clkreq_set = rtw_pci_old_clkreq_set,
+	.aspm_set = rtw_pci_old_aspm_set,
+};
+EXPORT_SYMBOL(rtw_pci_gen_old);
diff --git a/drivers/net/wireless/realtek/rtw88/pci_old.h b/drivers/net/wireless/realtek/rtw88/pci_old.h
new file mode 100644
index 000000000000..56ca3dd1581a
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/pci_old.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2026  Realtek Corporation.*/
+
+#ifndef __RTW_PCI_OLD_H__
+#define __RTW_PCI_OLD_H__
+
+#include "rx.h"
+#include "tx.h"
+
+#define REG_BCNQ_DESA				0x0308
+#define REG_HQ_DESA				0x0310
+#define REG_MGQ_DESA				0x0318
+#define REG_VOQ_DESA				0x0320
+#define REG_VIQ_DESA				0x0328
+#define REG_BEQ_DESA				0x0330
+#define REG_BKQ_DESA				0x0338
+#define REG_RX_DESA				0x0340
+
+#define REG_DBI_CTRL				0x0350
+
+struct rtw_rx_desc_pci_old {
+	struct rtw_rx_desc w0_5;
+	__le32 w6;
+	__le32 w7;
+} __packed;
+
+struct rtw_tx_desc_pci_old {
+	struct rtw_tx_desc w0_9;
+	__le32 w10;
+	__le32 w11;
+	__le32 w12;
+	__le32 w13;
+	__le32 w14;
+	__le32 w15;
+} __packed;
+
+extern const struct rtw_pci_gen rtw_pci_gen_old;
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index afcdb66fdb9a..b406d0729d16 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -11,6 +11,7 @@
 #define BIT_FEN_PPLL		BIT(7)
 #define BIT_FEN_PCIEA		BIT(6)
 #define BIT_FEN_DIO_PCIE	BIT(5)
+#define BIT_FEN_PCIED		BIT(8)
 #define BIT_FEN_CPUEN		BIT(2)
 #define BIT_FEN_USBA		BIT(2)
 #define BIT_FEN_BB_GLB_RST	BIT(1)
@@ -188,6 +189,8 @@
 #define BIT_USB_MODE_U2		1
 #define BIT_USB_MODE_U3		2
 
+#define REG_PMC_DBG_CTRL2	0x00CC
+
 #define REG_EFUSE_ACCESS	0x00CF
 #define EFUSE_ACCESS_ON		0x69
 #define EFUSE_ACCESS_OFF	0x00
diff --git a/drivers/net/wireless/realtek/rtw88/rx.h b/drivers/net/wireless/realtek/rtw88/rx.h
index ebef85a3f848..d5a6f57b5d87 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.h
+++ b/drivers/net/wireless/realtek/rtw88/rx.h
@@ -31,6 +31,8 @@ struct rtw_rx_desc {
 #define RTW_RX_DESC_W0_SHIFT		GENMASK(25, 24)
 #define RTW_RX_DESC_W0_PHYST		BIT(26)
 #define RTW_RX_DESC_W0_SWDEC		BIT(27)
+#define RTW_RX_DESC_W0_EOR		BIT(30)
+#define RTW_RX_DESC_W0_OWN		BIT(31)
 
 #define RTW_RX_DESC_W1_MACID		GENMASK(6, 0)
 
@@ -43,6 +45,8 @@ struct rtw_rx_desc {
 
 #define RTW_RX_DESC_W5_TSFL		GENMASK(31, 0)
 
+#define RTW_RX_DESC_W6_BUF_ADDR		GENMASK(31, 0)
+
 void rtw_rx_stats(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 		  struct sk_buff *skb);
 int rtw_rx_query_rx_desc(struct rtw_dev *rtwdev, void *rx_desc8,
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index af031c02b4b7..b92f03cf7d54 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -27,7 +27,9 @@ struct rtw_tx_desc {
 #define RTW_TX_DESC_W0_OFFSET GENMASK(23, 16)
 #define RTW_TX_DESC_W0_BMC BIT(24)
 #define RTW_TX_DESC_W0_LS BIT(26)
+#define RTW_TX_DESC_W0_FS BIT(27)
 #define RTW_TX_DESC_W0_DISQSELSEQ BIT(31)
+#define RTW_TX_DESC_W0_OWN BIT(31)
 #define RTW_TX_DESC_W1_MACID GENMASK(7, 0)
 #define RTW_TX_DESC_W1_QSEL GENMASK(12, 8)
 #define RTW_TX_DESC_W1_RATE_ID GENMASK(20, 16)
@@ -54,11 +56,14 @@ struct rtw_tx_desc {
 #define RTW_TX_DESC_W5_DATA_RTS_SHORT BIT(12)
 #define RTW_TX_DESC_W6_SW_DEFINE GENMASK(11, 0)
 #define RTW_TX_DESC_W7_TXDESC_CHECKSUM GENMASK(15, 0)
+#define RTW_TX_DESC_W7_TX_BUFFER_SIZE GENMASK(15, 0)
 #define RTW_TX_DESC_W7_DMA_TXAGG_NUM GENMASK(31, 24)
 #define RTW_TX_DESC_W8_EN_HWSEQ BIT(15)
 #define RTW_TX_DESC_W9_SW_SEQ GENMASK(23, 12)
 #define RTW_TX_DESC_W9_TIM_EN BIT(7)
 #define RTW_TX_DESC_W9_TIM_OFFSET GENMASK(6, 0)
+#define RTW_TX_DESC_W10_TX_BUFFER_ADDRESS GENMASK(31, 0)
+#define RTW_TX_DESC_W12_NEXT_DESC_ADDRESS GENMASK(31, 0)
 
 enum rtw_tx_desc_queue_select {
 	TX_DESC_QSEL_TID0	= 0,
-- 
2.55.0

