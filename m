Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:53717 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbdI0P2c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Sep 2017 11:28:32 -0400
Date: Wed, 27 Sep 2017 17:28:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Drake <drake@endlessm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, linux@endlessm.com
Subject: Re: [PATCH] PCI MSI: allow alignment restrictions on vector
 allocation
In-Reply-To: <20170925041153.26574-1-drake@endlessm.com>
Message-ID: <alpine.DEB.2.20.1709271555430.2027@nanos> (sfid-20170927_172905_959782_A96880A4)
References: <20170925041153.26574-1-drake@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 25 Sep 2017, Daniel Drake wrote:

Please send x86 related patches to LKML as documented in MAINTAINERS. That
patch is mainly x86 and not PCI.

> ath9k hardware claims to support up to 4 MSI vectors, and when run in
> that configuration, it would be allowed to modify the lower bits of the
> MSI Message Data when generating interrupts in order to signal which
> of the 4 vectors the interrupt is being raised on.
> 
> Linux's PCI-MSI irqchip only supports a single MSI vector for each
> device, and it tells the device this, but the device appears to assume
> it is working with 4, as it will unset the lower 2 bits of Message Data
> presumably to indicate that it is an IRQ for the first of 4 possible
> vectors.
> 
> Linux will then receive an interrupt on the wrong vector, so the
> ath9k interrupt handler will not be invoked.
> 
> To work around this, introduce a mechanism where the vector assignment
> algorithm can be restricted to only a subset of available vector numbers
> based on a bitmap.
> 
> As a user of this bitmap, introduce a pci_dev.align_msi_vector flag which
> can be used to state that MSI vector numbers must be aligned to a specific
> amount. If we 4-align the ath9k MSI vector then the lower bits will
> already be 0 and hence the device will not modify the Message Data away
> from its original value.
> 
> This is needed in order to support the wifi card in at least 8 new Acer
> consumer laptop models which come with the Foxconn NFA335 WiFi module.
> Legacy interrupts do not work on that module, so MSI support is required.

Sigh, what a mess.

> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> index 6dfe366a8804..7f35178586a1 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -77,6 +77,7 @@ struct irq_alloc_info {
>  		struct {
>  			struct pci_dev	*msi_dev;
>  			irq_hw_number_t	msi_hwirq;
> +			DECLARE_BITMAP(allowed_vectors, NR_VECTORS);

Uurgh. No. You want to express an alignment requirement. Why would you need
a bitmap for that? A simple

	unsigned int align_vector;

is sufficient.


> @@ -178,6 +179,9 @@ static int __assign_irq_vector(int irq, struct apic_chip_data *d,
>  		if (test_bit(vector, used_vectors))
>  			goto next;
>  
> +		if (allowed_vectors && !test_bit(vector, allowed_vectors))
> +			goto next;

This code is gone in -next and replaced by a new vector allocator.

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/apic

> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index f68c58a93dd0..7755450be02d 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -419,6 +419,8 @@ struct pci_dev {
>  #endif
>  #ifdef CONFIG_PCI_MSI
>  	const struct attribute_group **msi_irq_groups;
> +	int align_msi_vector;	/* device requires MSI vector numbers aligned
> +				 * by this amount */

This wants to be unsigned int and please get rid of this butt ugly
formatted comment.

But the real question is how this is supposed to work with

 - interrupt remapping

 - non X86 machines

I doubt that this can be made generic enough to make it work all over the
place. Tell Acer/Foxconn to fix their stupid firmware.

Thanks,

	tglx
