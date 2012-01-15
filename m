Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52941 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2AOJUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jan 2012 04:20:44 -0500
Received: by vcbfo1 with SMTP id fo1so499253vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jan 2012 01:20:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120113115931.GC2214@redhat.com>
References: <20120113115931.GC2214@redhat.com>
Date: Sun, 15 Jan 2012 10:20:41 +0100
Message-ID: <CAOZOX0WgJOP=W_k0UF+f1rXbHi4NkTNWRvezAgVeLJ8SL2qZmg@mail.gmail.com> (sfid-20120115_102051_539752_F308525D)
Subject: Re: [PATCH] rt2800pci: fix spurious interrupts generation
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amir Hedayaty <hedayaty@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 13, 2012 at 12:59 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Same devices can generate interrupt without properly setting bit in
> INT_SOURCE_CSR register (spurious interrupt), what will cause IRQ line
> will be disabled by interrupts controller driver.
>
> We discovered that clearing INT_MASK_CSR stops such behaviour. We
> previously first read that register, and then clear all know interrupt
> sources bits and do not touch reserved bits. After this patch, we write
> to all register content (I believe writing to reserved bits on that
> register will not cause any problems, I tested that on my rt2800pci
> device).
>
> This fix very bad performance problem, practically making device
> unusable (since worked without interrupts), reported in:
> https://bugzilla.redhat.com/show_bug.cgi?id=658451
>
> We previously tried to workaround that issue in commit
> 4ba7d9997869d25bd223dea7536fc1ce9fab3b3b "rt2800pci: handle spurious
> interrupts", but it was reverted in commit
> 82e5fc2a34fa9ffea38f00c4066b7e600a0ca5e6
> as thing, that will prevent to detect real spurious interrupts.
>
> Reported-and-tested-by: Amir Hedayaty <hedayaty@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   28 ++++++++--------------------
>  1 files changed, 8 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 4941a1a..dc88bae 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -422,7 +422,6 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
>  static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
>                                 enum dev_state state)
>  {
> -       int mask = (state == STATE_RADIO_IRQ_ON);
>        u32 reg;
>        unsigned long flags;
>
> @@ -436,25 +435,14 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
>        }
>
>        spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
> -       rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, mask);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_AC0_DMA_DONE, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_AC1_DMA_DONE, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_AC2_DMA_DONE, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_AC3_DMA_DONE, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_HCCA_DMA_DONE, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_MGMT_DMA_DONE, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_MCU_COMMAND, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_RXTX_COHERENT, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, mask);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, mask);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, mask);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, mask);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_GPTIMER, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, 0);
> -       rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, 0);
> +       reg = 0;
> +       if (state == STATE_RADIO_IRQ_ON) {
> +               rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, 1);
> +               rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, 1);
> +               rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, 1);
> +               rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, 1);
> +               rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, 1);
> +       }
>        rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
>        spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
>
> --
> 1.7.1
>
