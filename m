Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46477 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab0DAO2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 10:28:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <zajec5@gmail.com>
Subject: Re: [PATCH V3] ssb: do not read SPROM if it does not exist
Date: Thu, 1 Apr 2010 15:28:19 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <1270064375-3138-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1270064375-3138-2-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004011628.19654.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 31 March 2010 21:39:35 John W. Linville wrote:
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 9e50896..a4b2b99 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -620,6 +620,11 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
>  	int err = -ENOMEM;
>  	u16 *buf;
>  
> +	if (!ssb_is_sprom_available(bus)) {
> +		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
> +		return -ENODEV;
> +	}

Note that in ssb_pci_init() you might also want to add such a check to avoid
registering the "sprom" sysfs file in case there's no sprom. Otherwise root is
able to crash the machine via that file. Same goes for ssb_pci_exit(), of course.

-- 
Greetings, Michael.
