Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4517 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab1DETfj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 15:35:39 -0400
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	Arend van Spriel <arend@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	b43-dev@lists.infradead.org
In-Reply-To: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 12:35:37 -0700
Message-ID: <1302032137.3969.10.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 21:57 +0200, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Just some trivia.

> diff --git a/drivers/bcmai/b43_pci_ai_bridge.c b/drivers/bcmai/b43_pci_ai_bridge.c
[]
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/bcmai/bcmai_regs.h>
> +#include <linux/pci.h>
> +
> +static const struct pci_device_id b43_pci_ai_bridge_tbl[] = {

DEFINE_PCI_DEVICE_TABLE

> diff --git a/drivers/bcmai/core.c b/drivers/bcmai/core.c
[]
> +		bcmai_err("Power control not implemented!\n");
[]
> diff --git a/include/linux/bcmai/bcmai.h b/include/linux/bcmai/bcmai.h
[]
> +#define bcmai_info(fmt, args...)	printk(KERN_INFO "bcmai: " fmt, ##args)
> +#ifdef CONFIG_BCMAI_DEBUG
> +#define bcmai_dbg(fmt, args...)		printk(KERN_DEBUG "bcmai debug: " fmt, ##args)
> +#else
> +#define bcmai_dbg(fmt, args...)		do { } while (0)
> +#endif
> +#define bcmai_err(fmt, args...)		printk(KERN_ERR "bcmai error: " fmt, ##args)

I think there's very little value in prefixing
"error" and "debug" in front of equivalent
KERN_<level> message levels.

I think you might as well just use pr_<level>
and pr_fmt.

> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
[]
> +/* AI core, see drivers/bcmai/ */
> +struct bcmai_device_id {
> +	__u16	manuf;
> +	__u16	id;
> +	__u8	rev;
> +};

Do some of these structs need __packed declarations?


