Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2725 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab2BHWej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 17:34:39 -0500
Message-ID: <4F32F87C.3050202@gmail.com> (sfid-20120208_233442_536411_E49B5808)
Date: Wed, 08 Feb 2012 23:34:36 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: John Li <john.li.mediatek@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Subject: Re: [PATCH] rt2x00:Add RT5372 chipset support
References: <1328706002-11165-1-git-send-email-john.li.mediatek@gmail.com>
In-Reply-To: <1328706002-11165-1-git-send-email-john.li.mediatek@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On 02/08/12 14:00, John Li wrote:
> From: John Li <chen-yang.li@mediatek.com>
> 
> Signed-off-by: John Li <chen-yang.li@mediatek.com>

In addition to Helmut and Stanislaw, here are also some nitpicks and one
more serious question / comment from me.

> ---
>  drivers/net/wireless/rt2x00/rt2800.h    |    1 +
>  drivers/net/wireless/rt2x00/rt2800lib.c |  157 ++++++++++++++++++++++++++-----
>  drivers/net/wireless/rt2x00/rt2800pci.c |    3 +-
>  drivers/net/wireless/rt2x00/rt2800usb.c |   14 +++
>  drivers/net/wireless/rt2x00/rt2x00.h    |    2 +
>  5 files changed, 152 insertions(+), 25 deletions(-)
> 

<snip>

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 22a1a8f..852b57e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c

<snip>

> @@ -3482,6 +3522,67 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>  			rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
>  		rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
>  		rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
> +	}	else if (rt2x00_rt(rt2x00dev, RT5392) || 
> +			rt2x00_rt(rt2x00dev, RT5372)) {

I would prefer it here if you could list the checks in the numeric order
of the RT chipset (so just switch the two checks).

> +			rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
> +			rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
> +			rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
> +			rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
> +			rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
> +			rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
> +			rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
> +			rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
> +			rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
> +			rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
> +			rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
> +			rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
> +			rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
> +			rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
> +			rt2800_rfcsr_write(rt2x00dev, 19, 0x4d);
> +			rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
> +			rt2800_rfcsr_write(rt2x00dev, 21, 0x8d);
> +			rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
> +			rt2800_rfcsr_write(rt2x00dev, 23, 0x0b);
> +			rt2800_rfcsr_write(rt2x00dev, 24, 0x44);
> +			rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
> +			rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
> +			rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
> +			rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
> +			rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
> +			rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
> +			rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
> +			rt2800_rfcsr_write(rt2x00dev, 32, 0x20);
> +			rt2800_rfcsr_write(rt2x00dev, 33, 0xC0);
> +			rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
> +			rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
> +			rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
> +			rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
> +			rt2800_rfcsr_write(rt2x00dev, 38, 0x89);
> +			rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
> +			rt2800_rfcsr_write(rt2x00dev, 40, 0x0f);
> +			rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
> +			rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
> +			rt2800_rfcsr_write(rt2x00dev, 43, 0x9b);
> +			rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
> +			rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
> +			rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
> +			rt2800_rfcsr_write(rt2x00dev, 47, 0x0c);
> +			rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
> +			rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
> +			rt2800_rfcsr_write(rt2x00dev, 50, 0x94);
> +			rt2800_rfcsr_write(rt2x00dev, 51, 0x3a);
> +			rt2800_rfcsr_write(rt2x00dev, 52, 0x48);
> +			rt2800_rfcsr_write(rt2x00dev, 53, 0x44);
> +			rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
> +			rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
> +			rt2800_rfcsr_write(rt2x00dev, 56, 0xa1);
> +			rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
> +			rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
> +			rt2800_rfcsr_write(rt2x00dev, 59, 0x07);
> +			rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
> +			rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
> +			rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
> +			rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
>  	}
>  
>  	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {

<snip>

> @@ -3947,6 +4052,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	case RT3390:
>  	case RT3572:
>  	case RT5390:
> +	case RT5392:
> +	case RT5372:
>  		break;
>  	default:
>  		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");

Again, please put the RT chipset numbers in numeric order here.

> @@ -3966,6 +4073,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	case RF3320:
>  	case RF5370:
>  	case RF5390:
> +	case RF5372:
>  		break;
>  	default:
>  		ERROR(rt2x00dev, "Invalid RF chipset 0x%x detected.\n",

Same here

<snip>

> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 7f21005..c8619eb 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1107,6 +1107,20 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	/* Ralink */
>  	{ USB_DEVICE(0x148f, 0x5370) },
>  	{ USB_DEVICE(0x148f, 0x5372) },
> +	/* Alpha */
> +	{ USB_DEVICE(0x2001, 0x3c15) },
> +	{ USB_DEVICE(0x2001, 0x3c19) },
> +	/* Arcadyan */
> +	{ USB_DEVICE(0x043e, 0x7a12) },
> +	/* LG innotek */
> +	{ USB_DEVICE(0x043e, 0x7a22) },
> +	/* Panasonic */
> +	{ USB_DEVICE(0x04da, 0x1801) },
> +	{ USB_DEVICE(0x04da, 0x1800) },
> +	/* Unknown */
> +	{ USB_DEVICE(0x04da, 0x23f6) },
> +	/* Philips */
> +	{ USB_DEVICE(0x0471, 0x2104) },
>  #endif
>  #ifdef CONFIG_RT2800USB_UNKNOWN
>  	/*

Could you please insert these devices in the list in the correct
alphabetical ordering with respect to the vendor name (the one that is
in the comment above the USB device IDs)?

> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index b03b22c..7bc5cee 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -192,6 +192,8 @@ struct rt2x00_chip {
>  #define RT3593		0x3593
>  #define RT3883		0x3883	/* WSOC */
>  #define RT5390		0x5390  /* 2.4GHz */
> +#define RT5392		0x5392  /* 2.4GHz */
> +#define RT5372		0x5372  /* 2.4GHz */
>  
>  	u16 rf;
>  	u16 rev;

Again, please insert the RT chipset in the correct numeric order.

Also, a question from my side on the RT5372 chipset define here (and the
chip in general). The define is actually only used twice in the entire
patch, while the RT5392 define is used all over the place. In my
experience with Ralink chipsets this has not happened before (i.e.
needing a lot of code for the PCI / PCIe devices that is not needed for
USB devices). Are you sure that your patch is correct with respect to
this RT5372 chipset define?


---
Gertjan
