Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54652 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab3ALOTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:19:00 -0500
Message-ID: <50F170C9.8000905@hauke-m.de> (sfid-20130112_151906_477954_6A3EFF30)
Date: Sat, 12 Jan 2013 15:18:49 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Nathan Hintz <nlhintz@hotmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] bcma: jump to 'out' label for invalid 'func' value
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com> <BLU0-SMTP98AD32E757F0A7255A238DAC280@phx.gbl>
In-Reply-To: <BLU0-SMTP98AD32E757F0A7255A238DAC280@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2013 11:46 AM, Nathan Hintz wrote:
> Consistently jump to the 'out' label for error conditions (adds
> missing check for 'func' validity in bcma_extpci_write_config).
> 
> Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  drivers/bcma/driver_pci_host.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> index 56073a5..187cc9f 100644
> --- a/drivers/bcma/driver_pci_host.c
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -94,7 +94,7 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
>  	if (dev == 0) {
>  		/* we support only two functions on device 0 */
>  		if (func > 1)
> -			return -EINVAL;
> +			goto out;
>  
>  		/* accesses to config registers with offsets >= 256
>  		 * requires indirect access.
> @@ -157,6 +157,10 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
>  	if (unlikely(len != 1 && len != 2 && len != 4))
>  		goto out;
>  	if (dev == 0) {
> +		/* we support only two functions on device 0 */
> +		if (func > 1)
> +			goto out;
> +
>  		/* accesses to config registers with offsets >= 256
>  		 * requires indirect access.
>  		 */
> 

