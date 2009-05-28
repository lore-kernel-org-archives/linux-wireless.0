Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:48686 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbZE1QDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 12:03:44 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFT 1/2] ar9170: add initial support for 1-stage firmware
Date: Thu, 28 May 2009 18:03:43 +0200
Cc: linux-wireless@vger.kernel.org, jal2@gmx.de,
	Peter.Grabienski@atheros.com, Stephen.Chen@atheros.com,
	Michael.Fortin@atheros.com, Johnny.Cheng@atheros.com,
	Yuan-Gu.Wei@atheros.com, otus-devel@lists.madwifi-project.org
References: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com> <1243475326-28867-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1243475326-28867-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200905281803.44198.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 May 2009 03:48:45 Luis R. Rodriguez wrote:
> You can get the stage 1 firmware from here:
> 
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/ar9170.fw
> 
> Its license:
> 
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/LICENSE
> 
> It seems with some devices this works, with some others
> I see only scan working. We shall not push this firmware
> into the linux-firmware tree until these issues have been
> resolved.
> 
> Cc: Peter Grabienski <Peter.Grabienski@Atheros.com>
> Cc: Stephen Chen <Stephen.Chen@Atheros.com>
> Cc: Michael Fortin <Michael.Fortin@Atheros.com>
> Cc: Johnny Cheng <Johnny.Cheng@Atheros.com>
> Cc: Yuan-Gu Wei <Yuan-Gu.Wei@atheros.com>
> Cc: Joerg Albert <jal2@gmx.de>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ar9170/phy.c |   13 ++++++++++---
>  drivers/net/wireless/ath/ar9170/usb.c |   22 +++++++++++++++++-----
>  2 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
> index 6ce2075..0675dc8 100644
> --- a/drivers/net/wireless/ath/ar9170/phy.c
> +++ b/drivers/net/wireless/ath/ar9170/phy.c
> @@ -39,6 +39,7 @@
>  #include <linux/bitrev.h>
>  #include "ar9170.h"
>  #include "cmd.h"
> +#include "usb.h"
>  
>  static int ar9170_init_power_cal(struct ar9170 *ar)
>  {
> @@ -996,6 +997,10 @@ static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
>  	int idx, i, n;
>  	u8 ackpower, ackchains, f;
>  	u8 pwr_freqs[AR5416_MAX_NUM_TGT_PWRS];
> +	struct ar9170_usb *aru;
> +
> +	/* All ar9170 devices are USB */
> +	aru = container_of(ar, struct ar9170_usb, common);
>  
>  	if (freq < 3000)
>  		f = freq - 2300;
> @@ -1102,9 +1107,11 @@ static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
>  	else
>  		ackpower = ar->power_5G_leg[0] & 0x3f;
>  
> -	ar9170_regwrite(0x1c3694, ackpower << 20 | ackchains << 26);
> -	ar9170_regwrite(0x1c3bb4, ackpower << 5 | ackchains << 11 |
> -				  ackpower << 21 | ackchains << 27);
> +	if (aru->init_values)  {
> +		ar9170_regwrite(0x1c3694, ackpower << 20 | ackchains << 26);
> +		ar9170_regwrite(0x1c3bb4, ackpower << 5 | ackchains << 11 |
> +					  ackpower << 21 | ackchains << 27);
> +	}
>  
>  	ar9170_regwrite_finish();
>  	return ar9170_regwrite_result();
I guess you can drop this changes. see hpmain.c line 4039, 4061, 4069

--> #if_N_def ZM_OTUS_LINUX_PHASE_2 <--
zfDelayWriteInternalReg(dev, 0x1c3694, ((hpPriv->tPow2x2g[0]&0x3f) << 20) | (0x5<<26));
zfDelayWriteInternalReg(dev, 0x1c3bb4, ((hpPriv->tPow2x2g[0]&0x3f) << 5 ) | (0x5<<11) |
                                           ((hpPriv->tPow2x2g[0]&0x3f) << 21) | (0x5<<27)  );
#endif

so, the current ar9170 code is actually _wrong_ (but works!)...
and we should not touch these fields with the 2-stage firmware.

OT: since the firmware will (inevitably end up in the firmware-git-tree)
we should convert it to ihex, so it can be downloaded with the git-web.
(this can be done by: objcopy -I binary -O ihex ar9170.fw ar9170.fw.ihex )

And for future: it might be a good idea to add a little header/tail on the
firmware files. e.g.: 
	- firmware version and variant (e.g. 1-stage or 2-stage firmware)
	- supported hardware variants/interfaces
	- maybe API revision / feature bitmap
	- maybe more: e.g: vendor string / build / build-date / build no. etc.

Regards,
	Chr
