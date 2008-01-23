Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:55116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYAWVau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 16:30:50 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2351061fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2008 13:30:48 -0800 (PST)
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Subject: Re: [PATCH] rfkill: add the WiMAX radio type
Date: Wed, 23 Jan 2008 22:30:39 +0100
Cc: linux-wireless@vger.kernel.org
References: <200801231324.39483.inaky@linux.intel.com>
In-Reply-To: <200801231324.39483.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801232230.39590.IvDoorn@gmail.com> (sfid-20080123_213054_453745_BBB41AF9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 January 2008, Inaky Perez-Gonzalez wrote:
> rfkill: add the WiMAX radio type
> 
> Teach rfkill about wimax radios.
> 
> Had to define a KEY_WIMAX as a 'key for disabling only wimax radios',
> as other radio technologies have. This makes sense as hardware has
> specific keys for disabling specific radios.
> 
> The RFKILL enabling part is, otherwise, a copy and paste of any other
> radio technology. 
> 
> Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

For the rfkill part of the patch:
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> diff -r a52d5e9e9c91 include/linux/input.h
> --- a/include/linux/input.h	Mon Jan 14 16:13:06 2008 -0800
> +++ b/include/linux/input.h	Mon Jan 14 16:23:40 2008 -0800
> @@ -362,6 +362,8 @@ struct input_absinfo {
>  #define KEY_BRIGHTNESS_CYCLE	243	/* brightness up, after max is min */
>  #define KEY_BRIGHTNESS_ZERO	244	/* brightness off, use ambient */
>  #define KEY_DISPLAY_OFF		245	/* display device to off state */
> +
> +#define KEY_WIMAX		246
>  
>  #define BTN_MISC		0x100
>  #define BTN_0			0x100
> diff -r a52d5e9e9c91 include/linux/rfkill.h
> --- a/include/linux/rfkill.h	Mon Jan 14 16:13:06 2008 -0800
> +++ b/include/linux/rfkill.h	Mon Jan 14 16:23:40 2008 -0800
> @@ -33,11 +33,13 @@
>   * RFKILL_TYPE_WLAN: switch is on a 802.11 wireless network device.
>   * RFKILL_TYPE_BLUETOOTH: switch is on a bluetooth device.
>   * RFKILL_TYPE_UWB: switch is on a ultra wideband device.
> + * RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
>   */
>  enum rfkill_type {
>  	RFKILL_TYPE_WLAN ,
>  	RFKILL_TYPE_BLUETOOTH,
>  	RFKILL_TYPE_UWB,
> +	RFKILL_TYPE_WIMAX,
>  	RFKILL_TYPE_MAX,
>  };
>  
> diff -r a52d5e9e9c91 net/rfkill/rfkill-input.c
> --- a/net/rfkill/rfkill-input.c	Mon Jan 14 16:13:06 2008 -0800
> +++ b/net/rfkill/rfkill-input.c	Mon Jan 14 16:23:40 2008 -0800
> @@ -84,6 +84,7 @@ static DEFINE_RFKILL_TASK(rfkill_wlan, R
>  static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
>  static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
>  static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
> +static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
>  
>  static void rfkill_event(struct input_handle *handle, unsigned int type,
>  			unsigned int code, int down)
> @@ -98,6 +99,9 @@ static void rfkill_event(struct input_ha
>  			break;
>  		case KEY_UWB:
>  			rfkill_schedule_toggle(&rfkill_uwb);
> +			break;
> +		case KEY_WIMAX:
> +			rfkill_schedule_toggle(&rfkill_wimax);
>  			break;
>  		default:
>  			break;
> @@ -150,7 +154,7 @@ static const struct input_device_id rfki
>  		.keybit = { [BIT_WORD(KEY_WLAN)] = BIT_MASK(KEY_WLAN) },
>  	},
>  	{
> -		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
> + 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
>  		.evbit = { BIT_MASK(EV_KEY) },
>  		.keybit = { [BIT_WORD(KEY_BLUETOOTH)] = BIT_MASK(KEY_BLUETOOTH) },
>  	},
> @@ -158,6 +162,11 @@ static const struct input_device_id rfki
>  		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
>  		.evbit = { BIT_MASK(EV_KEY) },
>  		.keybit = { [BIT_WORD(KEY_UWB)] = BIT_MASK(KEY_UWB) },
> +	},
> +	{
> +		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
> +		.evbit = { BIT_MASK(EV_KEY) },
> +		.keybit = { [BIT_WORD(KEY_WIMAX)] = BIT_MASK(KEY_WIMAX) },
>  	},
>  	{ }
>  };
> diff -r a52d5e9e9c91 net/rfkill/rfkill.c
> --- a/net/rfkill/rfkill.c	Mon Jan 14 16:13:06 2008 -0800
> +++ b/net/rfkill/rfkill.c	Mon Jan 14 16:23:40 2008 -0800
> @@ -126,6 +126,9 @@ static ssize_t rfkill_type_show(struct d
>  	case RFKILL_TYPE_UWB:
>  		type = "ultrawideband";
>  		break;
> +	case RFKILL_TYPE_WIMAX:
> +		type = "wimax";
> +		break;
>  	default:
>  		BUG();
>  	}
> 


