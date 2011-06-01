Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51232 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab1FAM1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 08:27:40 -0400
Received: by qyk7 with SMTP id 7so1807965qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 05:27:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-8-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com> <1306928768-7501-8-git-send-email-rvossen@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Wed, 1 Jun 2011 14:27:20 +0200
Message-ID: <BANLkTimhuScx64utGbS_g0OU-S8B5G2MXQ@mail.gmail.com> (sfid-20110601_142743_275561_5DC512E3)
Subject: Re: [PATCH 08/83] staging: brcm80211: replaced #ifdef __mips__
 sections by W_REG_FLUSH
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 June 2011 13:44, Roland Vossen <rvossen@broadcom.com> wrote:
> --- a/drivers/staging/brcm80211/include/bcmutils.h
> +++ b/drivers/staging/brcm80211/include/bcmutils.h
> @@ -366,6 +366,17 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
>        } while (0)
>  #endif                         /* __BIG_ENDIAN */
>
> +#ifdef __mips__
> +/*
> + * bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
> + * transactions. As a fix, a read after write is performed on certain places
> + * in the code. Older chips and the newer 5357 family don't require this fix.
> + */

Checking for CONFIG_BCM47XX instead of __mips__ would be a bit cleaner
and less broad. Although the bcm47x6s are not supported by BCM47XX
yet, when the support gets added they will be caught by this without
affecting other mips platforms.
Perhaps a clean solution would be to introduce a quirk option/value in
the pci_bus or pci_dev the driver can use to decide at runtime whether
it needs this workaround or not. This would also allow other drivers
to check for it if they are also affected by it (even if the
probability of this is rather low - at least I haven't seen a bcm47x6
yet with anything other than a broadcom wifi connected to its pcie
;-).

Jonas
