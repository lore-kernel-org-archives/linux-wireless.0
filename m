Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1809 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab2EEGEO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 02:04:14 -0400
Message-ID: <4FA4C2CA.8000401@broadcom.com> (sfid-20120505_080417_798344_A3AF9EC1)
Date: Sat, 5 May 2012 08:03:54 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Nathan Hintz" <nlhintz@hotmail.com>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	hauke@hauke-m.de
Subject: Re: [PATCH v3 6/6] bcma: Add flush for BCMA_RESET_CTL write
References: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
 <BLU0-SMTP198AA334D9A1CD0C329E1A5AC2D0@phx.gbl>
In-Reply-To: <BLU0-SMTP198AA334D9A1CD0C329E1A5AC2D0@phx.gbl>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2012 06:56 AM, Nathan Hintz wrote:
> Adds a missing read to flush the previous write (per the Broadcom SDK).
> 
> Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
> ---
>  drivers/bcma/core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
> index 893f6e0..c4e6deb 100644
> --- a/drivers/bcma/core.c
> +++ b/drivers/bcma/core.c
> @@ -30,6 +30,7 @@ void bcma_core_disable(struct bcma_device *core, u32 flags)
>  	udelay(10);
>  
>  	bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
> +	bcma_aread32(core, BCMA_RESET_CTL);
>  	udelay(1);
>  }
>  EXPORT_SYMBOL_GPL(bcma_core_disable);

Hi Nathan,

The read after write is only needed on (certain) SoCs. As bcma is not
being used just for these SoCs I suggest to make the flush conditional.
In brcmsmac we introduced "flushed write" function, which does the read
only for those SoCs.

Gr. AvS

