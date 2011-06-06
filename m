Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58398 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab1FFLcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:32:12 -0400
Received: by qwk3 with SMTP id 3so1596073qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 04:32:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307311658-15853-8-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<1307311658-15853-8-git-send-email-hauke@hauke-m.de>
Date: Mon, 6 Jun 2011 13:32:11 +0200
Message-ID: <BANLkTik93+7ujHyv0_Zk2Ma9BPsHvJTttg@mail.gmail.com> (sfid-20110606_133216_597219_B42E421B)
Subject: Re: [RFC][PATCH 07/10] bcma: add pci(e) host mode
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
> +config BCMA_PCICORE_HOSTMODE
> +       bool "Hostmode support for BCMA PCI core"
> +       depends on BCMA_DRIVER_MIPS
> +       help
> +         PCIcore hostmode operation (external PCI bus).

I think you started to use BCMA_DRIVER_corename. Could you stick to it
(one schema), please? Maybe just
BCMA_DRIVER_PCI_HOSTMODE
?


> +#ifdef CONFIG_BCMA_PCICORE_HOSTMODE
> +       pc->hostmode = bcma_pcicore_is_in_hostmode(pc);
> +       if (pc->hostmode)
> +               bcma_pcicore_init_hostmode(pc);
> +#endif /* CONFIG_BCMA_PCICORE_HOSTMODE */
> +       if (!pc->hostmode)
> +               bcma_pcicore_serdes_workaround(pc);

Does it make sense to init hostmode PCI like clientmode if we just
disable CONFIG_BCMA_PCICORE_HOSTMODE?

I think we should always check if core is host or client mode and use
correct initialization only. We should not init it as clientmode just
because we do not have driver for host mode.


> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> new file mode 100644
> index 0000000..b52c6c9
> --- /dev/null
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -0,0 +1,44 @@
> +/*
> + * Broadcom specific AMBA
> + * PCI Core

Please rename "PCI Core", add something about hostmode.

-- 
Rafał
