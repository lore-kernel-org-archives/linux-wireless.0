Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:6424 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbYGWSW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 14:22:28 -0400
Received: by nf-out-0910.google.com with SMTP id d3so931797nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 11:22:26 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: add master_switch_mode functionality
Date: Wed, 23 Jul 2008 20:39:39 +0200
Cc: linux-wireless@vger.kernel.org
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <1216775046-9506-4-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216775046-9506-4-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807232039.39602.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> Let the user configure what rfkill-input should do upon EV_SW SW_RFKILL_ALL
> ON.
> 
> The mode of operation can be set through the master_switch_mode parameter.
> master_switch_mode 0 does nothing.  1 tries to restore the state before the
> last EV_SW SW_RFKILL_ALL OFF, or the default states of the switches if no
> EV_SW SW_RFKILL_ALL OFF ever happened.  2 tries to unblock all switches
> (default).
> 
> Note that the default mode of operation is unchanged.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  net/rfkill/rfkill-input.c |  129 +++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 107 insertions(+), 22 deletions(-)
> 
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index 827f178..273fb38 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -23,6 +23,18 @@ MODULE_AUTHOR("Dmitry Torokhov <dtor@mail.ru>");
>  MODULE_DESCRIPTION("Input layer to RF switch connector");
>  MODULE_LICENSE("GPL");
>  
> +enum rfkill_input_master_mode {
> +	RFKILL_INPUT_MASTER_DONOTHING = 0,
> +	RFKILL_INPUT_MASTER_RESTORE = 1,
> +	RFKILL_INPUT_MASTER_UNBLOCKALL = 2,

RFKILL_INPUT_MASTER_LAST, /* Internal */

See below for reason. :)

>  	spin_lock_irqsave(&task->lock, flags);
> @@ -114,18 +176,33 @@ static void rfkill_schedule_evsw_rfkillall(int state)
>  	/* EVERY radio type. state != 0 means radios ON */
>  	/* handle EPO (emergency power off) through shortcut */
>  	if (state) {
> -		rfkill_schedule_set(&rfkill_wwan,
> -				    RFKILL_STATE_UNBLOCKED);
> -		rfkill_schedule_set(&rfkill_wimax,
> -				    RFKILL_STATE_UNBLOCKED);
> -		rfkill_schedule_set(&rfkill_uwb,
> -				    RFKILL_STATE_UNBLOCKED);
> -		rfkill_schedule_set(&rfkill_bt,
> -				    RFKILL_STATE_UNBLOCKED);
> -		rfkill_schedule_set(&rfkill_wlan,
> -				    RFKILL_STATE_UNBLOCKED);
> +		switch (rfkill_master_switch_mode) {
> +		case RFKILL_INPUT_MASTER_UNBLOCKALL:
> +			rfkill_schedule_set(&rfkill_wwan,
> +					    RFKILL_STATE_UNBLOCKED);
> +			rfkill_schedule_set(&rfkill_wimax,
> +					    RFKILL_STATE_UNBLOCKED);
> +			rfkill_schedule_set(&rfkill_uwb,
> +					    RFKILL_STATE_UNBLOCKED);
> +			rfkill_schedule_set(&rfkill_bt,
> +					    RFKILL_STATE_UNBLOCKED);
> +			rfkill_schedule_set(&rfkill_wlan,
> +					    RFKILL_STATE_UNBLOCKED);
> +			break;
> +		case RFKILL_INPUT_MASTER_RESTORE:
> +			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_RESTORE);
> +			break;
> +		case RFKILL_INPUT_MASTER_DONOTHING:
> +			break;
> +		default:
> +			printk(KERN_ERR
> +				"rfkill-input: Illegal value for "
> +				"master_switch_mode parameter: %d\n",
> +				rfkill_master_switch_mode);

You probably need to move this printk below to rfkill_handler_init()
since there it will return -EINVAL so it won't reach this function.

> +			break;
> +		}
>  	} else
> -		rfkill_schedule_epo();
> +		rfkill_schedule_global_op(RFKILL_GLOBAL_OP_EPO);
>  }
>  
>  static void rfkill_event(struct input_handle *handle, unsigned int type,
> @@ -255,6 +332,14 @@ static struct input_handler rfkill_handler = {
>  
>  static int __init rfkill_handler_init(void)
>  {
> +	switch (rfkill_master_switch_mode) {
> +	case RFKILL_INPUT_MASTER_DONOTHING:
> +	case RFKILL_INPUT_MASTER_RESTORE:
> +	case RFKILL_INPUT_MASTER_UNBLOCKALL:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

if (rfkill_master_switch_mode >= RFKILL_INPUT_MASTER_LAST)
	return -EINVAL

This will make sure new entries in the enum are automatically handled.
Note that your next patch doesn't update the above switch statement,
and thus always returns -EINVAL when those values are used.

>  	return input_register_handler(&rfkill_handler);
>  }
>  

Ivo
