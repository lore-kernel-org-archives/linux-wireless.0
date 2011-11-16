Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50421 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1KPNCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 08:02:53 -0500
Received: by vcbfk1 with SMTP id fk1so305673vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 05:02:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111116125841.GB4409@redhat.com>
References: <20111116125841.GB4409@redhat.com>
Date: Wed, 16 Nov 2011 14:02:52 +0100
Message-ID: <CAOZOX0X0=pg4UbxL+M7LGug8ETCAGeVFspvkvr=hJxMFrO8b1A@mail.gmail.com> (sfid-20111116_140256_996835_D4192400)
Subject: Re: [PATCH] rt2x00: handle spurious pci interrupts
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 1:58 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> We have documented case of very bad performance issue on rt2800pci
> device, because it generate spurious interrupt, what cause irq line
> is disabled: https://bugzilla.redhat.com/show_bug.cgi?id=658451
>
> We already address that problem in separate patch by returning
> IRQ_HANDLED from interrupt handler. We think similar fix is needed for
> other rt2x00 PCI devices, because users report performance problems on
> these devices too.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
>  drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
>  drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index 3a6b402..676c765 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -1380,7 +1380,7 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
>        rt2x00pci_register_write(rt2x00dev, CSR7, reg);
>
>        if (!reg)
> -               return IRQ_NONE;
> +               return IRQ_HANDLED;
>
>        if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
>                return IRQ_HANDLED;
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index dcc0e1f..d0b627c 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1512,7 +1512,7 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
>        rt2x00pci_register_write(rt2x00dev, CSR7, reg);
>
>        if (!reg)
> -               return IRQ_NONE;
> +               return IRQ_HANDLED;
>
>        if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
>                return IRQ_HANDLED;
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index bf55b4a..9d83e70 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2337,7 +2337,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
>        rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
>
>        if (!reg && !reg_mcu)
> -               return IRQ_NONE;
> +               return IRQ_HANDLED;
>
>        if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
>                return IRQ_HANDLED;
> --
> 1.7.1
>
>
