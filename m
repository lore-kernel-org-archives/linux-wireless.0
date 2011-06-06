Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48118 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab1FFLXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:23:43 -0400
Received: by qwk3 with SMTP id 3so1593294qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 04:23:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307311658-15853-5-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<1307311658-15853-5-git-send-email-hauke@hauke-m.de>
Date: Mon, 6 Jun 2011 13:23:42 +0200
Message-ID: <BANLkTim_TtNVmmyH5J3G0pK-vrWNL1+24A@mail.gmail.com> (sfid-20110606_132346_040917_145BF6F4)
Subject: Re: [RFC][PATCH 04/10] bcma: add mips driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
> +/* driver_mips.c */
> +extern unsigned int bcma_core_mips_irq(struct bcma_device *dev);

Does it compile without CONFIG_BCMA_DRIVER_MIPS?


> +/* Get the MIPS IRQ assignment for a specified device.
> + * If unassigned, 0 is returned.
> + * If disabled, 5 is returned.
> + * If not supported, 6 is returned.
> + */

Does it ever return 6?


> +unsigned int bcma_core_mips_irq(struct bcma_device *dev)
> +{
> +       struct bcma_device *mdev = dev->bus->drv_mips.core;
> +       u32 irqflag;
> +       unsigned int irq;
> +
> +       irqflag = bcma_core_mips_irqflag(dev);
> +
> +       for (irq = 1; irq <= 4; irq++)
> +               if (bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq)) & (1 << irqflag))
> +                       break;

Use scripts/checkpatch*. Braces around "for" and split line to match
80 chars width.

Why don't you just use "return irq;" instead of break?


> +
> +       if (irq == 5)
> +               irq = 0;
> +
> +       return irq;

You can just make it "return 0;" after changing break to return.


> +                       for (i = 0; i < bus->nr_cores; i++)
> +                               if ((1 << bcma_core_mips_irqflag(&bus->cores[i])) == oldirqflag) {
> +                                       bcma_core_mips_set_irq(&bus->cores[i], 0);
> +                                       break;
> +                               }

Braces for "for".


> +       pr_info("after irq reconfiguration\n");

Make first letter uppercase. I'm not English expert, but doesn't
something like "IRQ reconfiguration done" sound better?

-- 
Rafał
