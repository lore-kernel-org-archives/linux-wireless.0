Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56446 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1KWIvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 03:51:39 -0500
Received: by ghrr1 with SMTP id r1so1127094ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 00:51:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111123080506.GB9833@redhat.com>
References: <20111116100915.GA2191@redhat.com>
	<20111122214940.GH8452@tuxdriver.com>
	<20111123080506.GB9833@redhat.com>
Date: Wed, 23 Nov 2011 09:51:38 +0100
Message-ID: <CAGXE3d-HE8MWV5Xv9e407iDn83UFvjua52mYGEJuJnQuQvnyog@mail.gmail.com> (sfid-20111123_095142_678314_388B76EF)
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2011 at 9:05 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Nov 22, 2011 at 04:49:40PM -0500, John W. Linville wrote:
>> On Wed, Nov 16, 2011 at 11:09:17AM +0100, Stanislaw Gruszka wrote:
>> Perhaps there is some way to convince the hardware not to generate
>> spurious interrupts?
>
> Ivo, Gertjan, Helmut, is there a possibility that I can get hardware
> documentation or any other support from Ralink, that could help to
> solve this (and possible other issues)?

There is sort of documentation for this hardware but not freely available :(

Are we 100% sure that the rt2800pci device is generating the interrupts?

Just a shot in the dark but instead of masking out interrupts we don't handle
just enable all device interrupts. Mind to try the below patch?

Helmut

---
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c
b/drivers/net/wireless/rt2x00/rt2800pci.c
index 4dc2d0f..c0badec 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -437,24 +437,24 @@ static void rt2800pci_toggle_irq(struct
rt2x00_dev *rt2x00dev,

 	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
 	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC0_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC1_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC2_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_AC3_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_HCCA_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_MGMT_DMA_DONE, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_MCU_COMMAND, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RXTX_COHERENT, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_AC0_DMA_DONE, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_AC1_DMA_DONE, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_AC2_DMA_DONE, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_AC3_DMA_DONE, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_HCCA_DMA_DONE, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_MGMT_DMA_DONE, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_MCU_COMMAND, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_RXTX_COHERENT, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_GPTIMER, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, 0);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, 0);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_GPTIMER, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, mask);
+	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, mask);
 	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
 	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
