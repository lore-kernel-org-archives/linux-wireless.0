Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46085 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031456Ab2CFXH6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 18:07:58 -0500
Message-ID: <4F5698BD.9080302@hauke-m.de> (sfid-20120307_000801_874497_2CA6E693)
Date: Wed, 07 Mar 2012 00:07:41 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Rafal Milecki <zajec5@gmail.com>
Subject: Re: [PATCH v2 1/2] bcma: return error in bcma_sprom_get() when fallback
 fails
References: <1331045448-12883-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1331045448-12883-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2012 03:50 PM, Arend van Spriel wrote:
> When not SPROM is available a fallback mechanism is used. However,
> when that fails the code currently continues. This patch assures
> that the bcma_sprom_get() function aborts when that happens.
> 
> Cc: Rafal Milecki <zajec5@gmail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/bcma/sprom.c |   27 +++++++++++++++++----------
>  1 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
> index 916ae25..fba8066 100644
> --- a/drivers/bcma/sprom.c
> +++ b/drivers/bcma/sprom.c
> @@ -49,10 +49,23 @@ int bcma_arch_register_fallback_sprom(int (*sprom_callback)(struct bcma_bus *bus
>  static int bcma_fill_sprom_with_fallback(struct bcma_bus *bus,
>  					 struct ssb_sprom *out)
>  {
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
>  }
>  
>  /**************************************************
> @@ -317,13 +330,7 @@ int bcma_sprom_get(struct bcma_bus *bus)
>  		 * available for this device in some other storage.
>  		 */
>  		err = bcma_fill_sprom_with_fallback(bus, &bus->sprom);
> -		if (err) {
> -			pr_warn("Using fallback SPROM failed (err %d)\n", err);
> -		} else {
> -			pr_debug("Using SPROM revision %d provided by"
> -				 " platform.\n", bus->sprom.revision);
> -			return 0;
> -		}
> +		return err;
>  	}
>  
>  	sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),

