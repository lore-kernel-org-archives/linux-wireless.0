Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42769 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932388AbdA0MlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:41:05 -0500
Subject: Re: [PATCH] rt2x00: avoid introducing a USB dependency in the
 rt2x00lib module
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <20170127083426.22655-1-nbd@nbd.name>
 <20170127120959.GA28776@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        vishalthanki@gmail.com
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <cbdfab40-f775-61ef-4a4e-5e1c25042364@nbd.name> (sfid-20170127_134157_999617_1EEE61A6)
Date: Fri, 27 Jan 2017 13:23:10 +0100
MIME-Version: 1.0
In-Reply-To: <20170127120959.GA28776@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-27 13:10, Stanislaw Gruszka wrote:
> Hi
> 
> On Fri, Jan 27, 2017 at 09:34:26AM +0100, Felix Fietkau wrote:
>> Though protected by an ifdef, introducing an usb symbol dependency in
>> the rt2x00lib module is a major inconvenience for distributions that
>> package kernel modules split into individual packages.
>> 
>> Get rid of this unnecessary dependency by calling the usb related
>> function from a more suitable place
> <snip>
>>  	rt2x00lib_remove_dev(rt2x00dev);
>> +	usb_kill_anchored_urbs(anchor);
> 
> At this point killing urb's is too late, because we already free
> structures that are used by urb->callback.
> 
> Below patch should solve the problem and not break shutdown sequence:
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index eb7b714..9235e03 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -1441,21 +1441,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  	cancel_work_sync(&rt2x00dev->intf_work);
>  	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
>  	cancel_work_sync(&rt2x00dev->sleep_work);
> -#if IS_ENABLED(CONFIG_RT2X00_LIB_USB)
> -	if (rt2x00_is_usb(rt2x00dev)) {
> -		usb_kill_anchored_urbs(rt2x00dev->anchor);
> -		hrtimer_cancel(&rt2x00dev->txstatus_timer);
> -		cancel_work_sync(&rt2x00dev->rxdone_work);
> -		cancel_work_sync(&rt2x00dev->txdone_work);
> -	}
> -#endif
> -	if (rt2x00dev->workqueue)
> -		destroy_workqueue(rt2x00dev->workqueue);
> -
> -	/*
> -	 * Free the tx status fifo.
> -	 */
> -	kfifo_free(&rt2x00dev->txstatus_fifo);
>  
>  	/*
>  	 * Kill the tx status tasklet.
> @@ -1471,6 +1456,14 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  	 */
>  	rt2x00lib_uninitialize(rt2x00dev);
>  
> +	if (rt2x00dev->workqueue)
> +		destroy_workqueue(rt2x00dev->workqueue);
> +
> +	/*
> +	 * Free the tx status fifo.
> +	 */
> +	kfifo_free(&rt2x00dev->txstatus_fifo);
> +
>  	/*
>  	 * Free extra components
>  	 */
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> index 6005e14..a0a866e 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> @@ -744,6 +744,11 @@ void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev)
>  {
>  	struct data_queue *queue;
>  
> +	usb_kill_anchored_urbs(rt2x00dev->anchor);
> +	hrtimer_cancel(&rt2x00dev->txstatus_timer);
> +	cancel_work_sync(&rt2x00dev->rxdone_work);
> +	cancel_work_sync(&rt2x00dev->txdone_work);
> +

Looks good to me, please submit that.

- Felix
