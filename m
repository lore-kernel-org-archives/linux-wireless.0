Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4954 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1HWW3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 18:29:21 -0400
Date: Tue, 23 Aug 2011 15:29:08 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>
cc: driverdevel <devel@driverdev.osuosl.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH] staging: brcmsmac, fix build for SMP disabled
Message-ID: <20110823222908.GC4802@broadcom.com> (sfid-20110824_002924_411829_A19BA5BE)
References: <20110823145659.a22e1860.rdunlap@xenotime.net>
MIME-Version: 1.0
In-Reply-To: <20110823145659.a22e1860.rdunlap@xenotime.net>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2011 at 02:56:59PM -0700, Randy Dunlap wrote:
> ---
>  drivers/staging/brcm80211/brcmsmac/types.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- lnx-31-rc3.orig/drivers/staging/brcm80211/brcmsmac/types.h
> +++ lnx-31-rc3/drivers/staging/brcm80211/brcmsmac/types.h
> @@ -18,6 +18,7 @@
>  #define _BRCM_TYPES_H_
>  
>  #include <linux/types.h>
> +#include <asm/io.h>
>  
>  /* Bus types */
>  #define	SI_BUS			0	/* SOC Interconnect */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


I believe this is covered by a patch that Greg merged earlier today (which adds
'#include <linux/io.h>' to types.h).

- Henry


