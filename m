Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:20614 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYGaOQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 10:16:33 -0400
Received: by ik-out-1112.google.com with SMTP id c28so556832ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 07:16:31 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: query EV_SW states when rfkill-input (re)?connects to a input device
Date: Thu, 31 Jul 2008 16:38:09 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
References: <20080730013024.GB22649@anvil.corenet.prv> <1217512437-20890-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1217512437-20890-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807311638.10270.IvDoorn@gmail.com> (sfid-20080731_161637_128949_897D1596)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 31 July 2008, Henrique de Moraes Holschuh wrote:
> Every time a new input device that is capable of one of the rfkill EV_SW events
> (currently only SW_RFKILL_ALL) is connected to rfkill-input, we must check the
> states of the input EV_SW switches and take action.  Otherwise, we will ignore
> the initial switch state.
> 
> We also need to re-check the states of the EV_SW switches after a device that
> was under an exclusive grab is released back to us, since we got no input
> events from that device while it was grabbed.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>

Sounds sane enough for me.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill-input.c |   54 ++++++++++++++++++++++++++++++++------------
>  1 files changed, 39 insertions(+), 15 deletions(-)
> 
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index 8aa8227..e5b6955 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -109,6 +109,25 @@ static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
>  static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
>  static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WWAN);
>  
> +static void rfkill_schedule_evsw_rfkillall(int state)
> +{
> +	/* EVERY radio type. state != 0 means radios ON */
> +	/* handle EPO (emergency power off) through shortcut */
> +	if (state) {
> +		rfkill_schedule_set(&rfkill_wwan,
> +				    RFKILL_STATE_UNBLOCKED);
> +		rfkill_schedule_set(&rfkill_wimax,
> +				    RFKILL_STATE_UNBLOCKED);
> +		rfkill_schedule_set(&rfkill_uwb,
> +				    RFKILL_STATE_UNBLOCKED);
> +		rfkill_schedule_set(&rfkill_bt,
> +				    RFKILL_STATE_UNBLOCKED);
> +		rfkill_schedule_set(&rfkill_wlan,
> +				    RFKILL_STATE_UNBLOCKED);
> +	} else
> +		rfkill_schedule_epo();
> +}
> +
>  static void rfkill_event(struct input_handle *handle, unsigned int type,
>  			unsigned int code, int data)
>  {
> @@ -132,21 +151,7 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
>  	} else if (type == EV_SW) {
>  		switch (code) {
>  		case SW_RFKILL_ALL:
> -			/* EVERY radio type. data != 0 means radios ON */
> -			/* handle EPO (emergency power off) through shortcut */
> -			if (data) {
> -				rfkill_schedule_set(&rfkill_wwan,
> -						    RFKILL_STATE_UNBLOCKED);
> -				rfkill_schedule_set(&rfkill_wimax,
> -						    RFKILL_STATE_UNBLOCKED);
> -				rfkill_schedule_set(&rfkill_uwb,
> -						    RFKILL_STATE_UNBLOCKED);
> -				rfkill_schedule_set(&rfkill_bt,
> -						    RFKILL_STATE_UNBLOCKED);
> -				rfkill_schedule_set(&rfkill_wlan,
> -						    RFKILL_STATE_UNBLOCKED);
> -			} else
> -				rfkill_schedule_epo();
> +			rfkill_schedule_evsw_rfkillall(data);
>  			break;
>  		default:
>  			break;
> @@ -168,6 +173,7 @@ static int rfkill_connect(struct input_handler *handler, struct input_dev *dev,
>  	handle->handler = handler;
>  	handle->name = "rfkill";
>  
> +	/* causes rfkill_start() to be called */
>  	error = input_register_handle(handle);
>  	if (error)
>  		goto err_free_handle;
> @@ -185,6 +191,23 @@ static int rfkill_connect(struct input_handler *handler, struct input_dev *dev,
>  	return error;
>  }
>  
> +static void rfkill_start(struct input_handle *handle)
> +{
> +	/* Take event_lock to guard against configuration changes, we
> +	 * should be able to deal with concurrency with rfkill_event()
> +	 * just fine (which event_lock will also avoid). */
> +	spin_lock_irq(&handle->dev->event_lock);
> +
> +	if (test_bit(EV_SW, handle->dev->evbit)) {
> +		if (test_bit(SW_RFKILL_ALL, handle->dev->swbit))
> +			rfkill_schedule_evsw_rfkillall(test_bit(SW_RFKILL_ALL,
> +							handle->dev->sw));
> +		/* add resync for further EV_SW events here */
> +	}
> +
> +	spin_unlock_irq(&handle->dev->event_lock);
> +}
> +
>  static void rfkill_disconnect(struct input_handle *handle)
>  {
>  	input_close_device(handle);
> @@ -225,6 +248,7 @@ static struct input_handler rfkill_handler = {
>  	.event =	rfkill_event,
>  	.connect =	rfkill_connect,
>  	.disconnect =	rfkill_disconnect,
> +	.start =	rfkill_start,
>  	.name =		"rfkill",
>  	.id_table =	rfkill_ids,
>  };


