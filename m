Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1562 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030769Ab2CFOoQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 09:44:16 -0500
Message-ID: <4F5622B3.8000702@broadcom.com> (sfid-20120306_154419_791657_FF763181)
Date: Tue, 6 Mar 2012 15:44:03 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Arend van Spriel" <arend@broadcom.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcma: add support for on-chip OTP memory used for
 SPROM storage
References: <1331040873-10290-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1331040873-10290-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2012 02:34 PM, Arend van Spriel wrote:
> Wireless Broadcom chips can have either their SPROM data stored
> on either external SPROM or on-chip OTP memory. Both are accessed
> through the same register space. This patch adds support for the
> on-chip OTP memory.

John,

Please drop this patch. Better to split down this patch as it addresses 
two issues (although related).

> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
> index 916ae25..cdcf75c 100644
> --- a/drivers/bcma/sprom.c
> +++ b/drivers/bcma/sprom.c
> @@ -49,10 +49,23 @@ int bcma_arch_register_fallback_sprom(int (*sprom_callback)(struct bcma_bus *bus
>   static int bcma_fill_sprom_with_fallback(struct bcma_bus *bus,
>   					 struct ssb_sprom *out)
>   {
> -	if (!get_fallback_sprom)
> -		return -ENOENT;
> +	int err;
>
> -	return get_fallback_sprom(bus, out);
> +	if (!get_fallback_sprom) {
> +		err = -ENOENT;
> +		goto fail;
> +	}
> +
> +	err = get_fallback_sprom(bus, out);
> +	if (err)
> +		goto fail;
> +
> +	pr_debug("Using SPROM revision %d provided by"
> +		 " platform.\n", bus->sprom.revision);
> +	return 0;
> +fail:
> +	pr_warn("Using fallback SPROM failed (err %d)\n", err);
> +	return err;
>   }

Commit message does not cover the above change.

Gr. AvS


