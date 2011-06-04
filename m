Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40986 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1FDIHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 04:07:14 -0400
Date: Sat, 4 Jun 2011 17:07:18 +0900
From: Mattia Dongili <malattia@linux.it>
To: Marco Chiappero <marco@absence.it>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 12/25] sony-laptop: input core improvements improvements
Message-ID: <20110604080717.GC7194@kamineko.org> (sfid-20110604_100724_075937_0806F37E)
References: <4DE8FC4A.9010401@absence.it>
 <4DE9012E.5040207@absence.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DE9012E.5040207@absence.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 03, 2011 at 05:43:42PM +0200, Marco Chiappero wrote:
> The code is now forwarding the SW_RFKILL_ALL event; added a couple

I don't think we should do this.
4eeb50220a4efd8c33598a228d03aff203a7ad07 removed the notification for
the SPIC part of the module and I'd rather not add it now for SNC. The
notification has proven to cause race conditions (see the bug referenced
in the commit message).
Moreover it should be left to the rfkill subsystem to notify userspace
for consistency with all the other drivers implementing rfkill switches.

> of Fn combos too.

the additional key codes are fine though.

> Signed-off-by: Marco Chiappero <marco@absence.it>
> ---
> 
> --- a/include/linux/sonypi.h
> +++ b/include/linux/sonypi.h
> @@ -114,6 +114,7 @@
>  #define SONYPI_EVENT_BRIGHTNESS_PRESSED		71
>  #define SONYPI_EVENT_MEDIA_PRESSED		72
>  #define SONYPI_EVENT_VENDOR_PRESSED		73
> +#define SONYPI_EVENT_RFKILL_ALL			74
> 
>  /* get/set brightness */
>  #define SONYPI_IOCGBRT		_IOR('v', 0, __u8)
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -142,6 +142,7 @@ MODULE_PARM_DESC(kbd_backlight_timeout,
> 
> 
>  static int sony_rfkill_handle = -1;
> +static int sony_nc_get_rfkill_hwblock(void);
> 
>  /*********** Input Devices ***********/
> 
> @@ -241,7 +242,8 @@ static int sony_laptop_input_index[] = {
>  	57,	/* 70 SONYPI_EVENT_VOLUME_DEC_PRESSED */
>  	-1,	/* 71 SONYPI_EVENT_BRIGHTNESS_PRESSED */
>  	58,	/* 72 SONYPI_EVENT_MEDIA_PRESSED */
> -	59,	/* 72 SONYPI_EVENT_VENDOR_PRESSED */
> +	59,	/* 73 SONYPI_EVENT_VENDOR_PRESSED */
> +	-1,	/* 74 SONYPI_EVENT_RFKILL_ALL */
>  };
> 
>  static int sony_laptop_input_keycode_map[] = {
> @@ -335,6 +337,7 @@ static void sony_laptop_report_input_eve
>  	struct input_dev *jog_dev = sony_laptop_input.jog_dev;
>  	struct input_dev *key_dev = sony_laptop_input.key_dev;
>  	struct sony_laptop_keypress kp = { NULL };
> +	int rfk_switch;
> 
>  	if (event == SONYPI_EVENT_FNKEY_RELEASED ||
>  			event == SONYPI_EVENT_ANYBUTTON_RELEASED) {
> @@ -363,6 +366,14 @@ static void sony_laptop_report_input_eve
>  		kp.dev = jog_dev;
>  		break;
> 
> +	case SONYPI_EVENT_RFKILL_ALL:
> +		rfk_switch = sony_nc_get_rfkill_hwblock();
> +		if (!(rfk_switch < 0)) {
> +			input_report_switch(key_dev, SW_RFKILL_ALL, rfk_switch);
> +			input_sync(key_dev);
> +		}
> +		return;
> +
>  	default:
>  		if (event >= ARRAY_SIZE(sony_laptop_input_index)) {
>  			dprintk("sony_laptop_report_input_event, event not known: %d\n",
> event);
> @@ -438,6 +449,14 @@ static int sony_laptop_setup_input(struc
>  		__set_bit(sony_laptop_input_keycode_map[i], key_dev->keybit);
>  	__clear_bit(KEY_RESERVED, key_dev->keybit);
> 
> +	if (sony_rfkill_handle != -1) {
> +		int rfk_switch;
> +
> +		rfk_switch = sony_nc_get_rfkill_hwblock();
> +		input_set_capability(key_dev, EV_SW, SW_RFKILL_ALL);
> +		input_report_switch(key_dev, SW_RFKILL_ALL, rfk_switch);
> +	}
> +
>  	error = input_register_device(key_dev);
>  	if (error)
>  		goto err_free_keydev;
> @@ -1079,10 +1098,6 @@ struct sony_nc_event {
>  };
> 
>  static struct sony_nc_event sony_100_events[] = {
> -	{ 0x90, SONYPI_EVENT_PKEY_P1 },
> -	{ 0x10, SONYPI_EVENT_ANYBUTTON_RELEASED },
> -	{ 0x91, SONYPI_EVENT_PKEY_P2 },
> -	{ 0x11, SONYPI_EVENT_ANYBUTTON_RELEASED },
>  	{ 0x81, SONYPI_EVENT_FNKEY_F1 },
>  	{ 0x01, SONYPI_EVENT_FNKEY_RELEASED },
>  	{ 0x82, SONYPI_EVENT_FNKEY_F2 },
> @@ -1097,12 +1112,20 @@ static struct sony_nc_event sony_100_eve
>  	{ 0x06, SONYPI_EVENT_FNKEY_RELEASED },
>  	{ 0x87, SONYPI_EVENT_FNKEY_F7 },
>  	{ 0x07, SONYPI_EVENT_FNKEY_RELEASED },
> +	{ 0x88, SONYPI_EVENT_FNKEY_F8 },
> +	{ 0x08, SONYPI_EVENT_FNKEY_RELEASED },
>  	{ 0x89, SONYPI_EVENT_FNKEY_F9 },
>  	{ 0x09, SONYPI_EVENT_FNKEY_RELEASED },
>  	{ 0x8A, SONYPI_EVENT_FNKEY_F10 },
>  	{ 0x0A, SONYPI_EVENT_FNKEY_RELEASED },
> +	{ 0x8B, SONYPI_EVENT_FNKEY_F11 },
> +	{ 0x0B, SONYPI_EVENT_FNKEY_RELEASED },
>  	{ 0x8C, SONYPI_EVENT_FNKEY_F12 },
>  	{ 0x0C, SONYPI_EVENT_FNKEY_RELEASED },
> +	{ 0x90, SONYPI_EVENT_PKEY_P1 },
> +	{ 0x10, SONYPI_EVENT_ANYBUTTON_RELEASED },
> +	{ 0x91, SONYPI_EVENT_PKEY_P2 },
> +	{ 0x11, SONYPI_EVENT_ANYBUTTON_RELEASED },
>  	{ 0x9d, SONYPI_EVENT_ZOOM_PRESSED },
>  	{ 0x1d, SONYPI_EVENT_ANYBUTTON_RELEASED },
>  	{ 0x9f, SONYPI_EVENT_CD_EJECT_PRESSED },
-- 
mattia
:wq!
