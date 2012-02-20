Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35748 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2BTLKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 06:10:12 -0500
Received: by bkcjm19 with SMTP id jm19so4444914bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2012 03:10:11 -0800 (PST)
Message-ID: <4F4229C7.1070107@mvista.com> (sfid-20120220_121017_412032_8EF38285)
Date: Mon, 20 Feb 2012 15:08:55 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com, m@bues.ch
Subject: Re: [PATCH 11/11] MIPS: BCM47XX: provide sprom to bcma bus
References: <1329676345-15856-1-git-send-email-hauke@hauke-m.de> <1329676345-15856-12-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1329676345-15856-12-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 19-02-2012 22:32, Hauke Mehrtens wrote:

> On SoCs the sprom is often stored in nvram in the flashchip. This patch
> registers a sprom fallback callback handler in bcma and provides the
> sprom needed for this device.

> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> ---
>   arch/mips/bcm47xx/setup.c |   39 +++++++++++++++++++++++++++++++++++----
>   1 files changed, 35 insertions(+), 4 deletions(-)

> diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
> index 6b0dacd..6f8b073 100644
> --- a/arch/mips/bcm47xx/setup.c
> +++ b/arch/mips/bcm47xx/setup.c
[...]
> @@ -159,10 +159,41 @@ static void __init bcm47xx_register_ssb(void)
>   #endif
>
>   #ifdef CONFIG_BCM47XX_BCMA
> +static int bcm47xx_get_sprom_bcma(struct bcma_bus *bus, struct ssb_sprom *out)
> +{
> +	char prefix[10];
> +	struct bcma_device *core;
> +
> +	if (bus->hosttype == BCMA_HOSTTYPE_PCI) {

    Why not *switch* statement? It seems more natural in this situation...

> +		snprintf(prefix, sizeof(prefix), "pci/%u/%u/",
> +			 bus->host_pci->bus->number + 1,
> +			 PCI_SLOT(bus->host_pci->devfn));
> +		bcm47xx_fill_sprom(out, prefix);
> +		return 0;
> +	} else if (bus->hosttype == BCMA_HOSTTYPE_SOC) {
> +		bcm47xx_fill_sprom_ethernet(out, NULL);
> +		core = bcma_find_core(bus, BCMA_CORE_80211);
> +		if (core) {
> +			snprintf(prefix, sizeof(prefix), "sb/%u/",
> +				 core->core_index);
> +			bcm47xx_fill_sprom(out, prefix);
> +		}
> +		return 0;
> +	} else {
> +		printk(KERN_WARNING "bcm47xx: unable to fill SPROM for given bustype.\n");
> +		return -EINVAL;
> +	}
> +}
> +
>   static void __init bcm47xx_register_bcma(void)
>   {
>   	int err;
>
> +	err = bcma_arch_register_fallback_sprom(&bcm47xx_get_sprom_bcma);
> +	if (err)
> +		printk(KERN_WARNING "bcm47xx: someone else already registered"

    pr_warn(). And don't break the message to help grepping.

> +			" a bcma SPROM callback handler (err %d)\n", err);
> +

WBR, Sergei
