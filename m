Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbYFELrW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 07:47:22 -0400
Subject: Re: [PATCH 3/4] libertas: check for old, unsupported hardware
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200806051308.35863.hs4233@mail.mn-solutions.de>
References: <200806051308.35863.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 07:46:59 -0400
Message-Id: <1212666420.25730.4.camel@localhost.localdomain> (sfid-20080605_134738_545220_FDB0E48E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-05 at 13:08 +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Looks OK to me; how old are the B1 and earlier chips?  Do we just not
have any samples to work with?

Acked-by: Dan Williams <dcbw@redhat.com>

> --- linux.orig/drivers/net/wireless/libertas/if_cs.c
> +++ linux/drivers/net/wireless/libertas/if_cs.c
> @@ -268,6 +268,12 @@
>  #define IF_CS_SCRATCH_BOOT_OK		0x00
>  #define IF_CS_SCRATCH_HELPER_OK		0x5a
>  
> +/*
> + * Used to detect ancient chips:
> + */
> +#define IF_CS_PRODUCT_ID		0x0000001C
> +#define IF_CS_CF8385_B1_REV		0x12
> +
>  
>  /********************************************************************/
>  /* I/O and interrupt handling                                       */
> @@ -864,6 +871,12 @@
>  	       p_dev->irq.AssignedIRQ, p_dev->io.BasePort1,
>  	       p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);
>  
> +	/* Check if we have a current silicon */
> +	if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
> +		lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
> +		ret = -ENODEV;
> +		goto out2;
> +	}
>  
>  	/* Load the firmware early, before calling into libertas.ko */
>  	ret = if_cs_prog_helper(card);

