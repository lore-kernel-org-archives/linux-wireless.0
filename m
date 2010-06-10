Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53945 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab0FJXWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 19:22:52 -0400
Received: by pvg16 with SMTP id 16so193573pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jun 2010 16:22:52 -0700 (PDT)
Message-ID: <4C1173E7.6010201@lwfinger.net>
Date: Thu, 10 Jun 2010 18:23:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Leann Ogasawara <leann.ogasawara@canonical.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54usb: Remove duplicate Medion MD40900 device id
References: <1276208913.1221.3646.camel@emiko>
In-Reply-To: <1276208913.1221.3646.camel@emiko>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2010 05:28 PM, Leann Ogasawara wrote:
> The Medion MD40900 device id [0x0cde, 0x0006] is defined twice.  Remove
> the duplicate.
> 
> Originally-by: Ben Collins <ben.collins@ubuntu.com>
> Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
> ---
>  drivers/net/wireless/p54/p54usb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
> index 7307325..d6d8713 100644
> --- a/drivers/net/wireless/p54/p54usb.c
> +++ b/drivers/net/wireless/p54/p54usb.c
> @@ -69,7 +69,6 @@ static struct usb_device_id p54u_table[] __devinitdata = {
>  	{USB_DEVICE(0x0915, 0x2002)},	/* Cohiba Proto board */
>  	{USB_DEVICE(0x0baf, 0x0118)},   /* U.S. Robotics U5 802.11g Adapter*/
>  	{USB_DEVICE(0x0bf8, 0x1009)},   /* FUJITSU E-5400 USB D1700*/
> -	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
>  	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
>  	{USB_DEVICE(0x0cde, 0x0015)},	/* Zcomax XG-705A */
>  	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */

Do you know for certain that this device is a Version 1 chip, and for
that reason, you are removing it from the version 2 list?

If not, NACK.

Larry

