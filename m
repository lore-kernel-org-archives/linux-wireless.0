Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60480 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1DBBlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 21:41:20 -0400
Received: by wya21 with SMTP id 21so3411243wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 18:41:19 -0700 (PDT)
Message-ID: <4D967EB9.9070309@gmail.com>
Date: Sat, 02 Apr 2011 03:41:13 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com, gwingerde@gmail.com
Subject: Re: [PATCH] wireless: rt2x00: rt{2500,73}usb.c fix duplicate ids
References: <1301184953-18436-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1301184953-18436-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2011 01:15 AM, Xose Vazquez Perez wrote:
> based on the Ralink drivers:
> 
> W = Windows_ralink_driver
> L = Linux_ralink_driver
> 
> USB_IDs         W_73  W_2500 L_73  L_2500
> =============   ====  ====== ====  ======
> 0x050d,0x7050   -     -      -     YES
> 0x050d,0x705a   -     -      YES   -
> 0x1371,0x9022   -     YES    YES   -
> 0x148f,0x2573   YES   -      YES   -
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2500usb.c |    4 ----
>  drivers/net/wireless/rt2x00/rt73usb.c   |    1 -
>  2 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 979fe65..f6682f0 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1910,13 +1910,10 @@ static struct usb_device_id rt2500usb_device_table[] = {
>  	/* Belkin */
>  	{ USB_DEVICE(0x050d, 0x7050), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x050d, 0x7051), USB_DEVICE_DATA(&rt2500usb_ops) },
> -	{ USB_DEVICE(0x050d, 0x705a), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	/* Cisco Systems */
>  	{ USB_DEVICE(0x13b1, 0x000d), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x13b1, 0x0011), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x13b1, 0x001a), USB_DEVICE_DATA(&rt2500usb_ops) },
> -	/* CNet */
> -	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	/* Conceptronic */
>  	{ USB_DEVICE(0x14b2, 0x3c02), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	/* D-LINK */
> @@ -1939,7 +1936,6 @@ static struct usb_device_id rt2500usb_device_table[] = {
>  	/* Ralink */
>  	{ USB_DEVICE(0x148f, 0x1706), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x148f, 0x2570), USB_DEVICE_DATA(&rt2500usb_ops) },
> -	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	{ USB_DEVICE(0x148f, 0x9020), USB_DEVICE_DATA(&rt2500usb_ops) },
>  	/* Sagem */
>  	{ USB_DEVICE(0x079b, 0x004b), USB_DEVICE_DATA(&rt2500usb_ops) },
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 02f1148..bc7a957 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2407,7 +2407,6 @@ static struct usb_device_id rt73usb_device_table[] = {
>  	{ USB_DEVICE(0x0b05, 0x1723), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x0b05, 0x1724), USB_DEVICE_DATA(&rt73usb_ops) },
>  	/* Belkin */
> -	{ USB_DEVICE(0x050d, 0x7050), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x050d, 0x705a), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x050d, 0x905b), USB_DEVICE_DATA(&rt73usb_ops) },
>  	{ USB_DEVICE(0x050d, 0x905c), USB_DEVICE_DATA(&rt73usb_ops) },

John, is there any wrong in this patch ?
It wasn't included in your last 'pull request' to davem.

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
