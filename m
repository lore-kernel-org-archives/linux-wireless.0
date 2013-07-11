Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:56977 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3GKNCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 09:02:08 -0400
Received: by mail-lb0-f180.google.com with SMTP id o10so6699720lbi.39
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jul 2013 06:02:06 -0700 (PDT)
Message-ID: <51DEACCB.4000206@cogentembedded.com> (sfid-20130711_150226_647611_E5D21076)
Date: Thu, 11 Jul 2013 17:02:03 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH 17/50] USB: serial: sierra: spin_lock in complete() cleanup
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-18-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-18-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 11-07-2013 13:05, Ming Lei wrote:

> Complete() will be run with interrupt enabled, so change to
> spin_lock_irqsave().

> Cc: Johan Hovold <jhovold@gmail.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   drivers/usb/serial/sierra.c |    9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)

> diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
> index de958c5..e79b6ad 100644
> --- a/drivers/usb/serial/sierra.c
> +++ b/drivers/usb/serial/sierra.c
> @@ -433,6 +433,7 @@ static void sierra_outdat_callback(struct urb *urb)
>   	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
>   	struct sierra_intf_private *intfdata;
>   	int status = urb->status;
> +	unsigned long flags;
>
>   	intfdata = port->serial->private;
>
> @@ -443,12 +444,12 @@ static void sierra_outdat_callback(struct urb *urb)
>   		dev_dbg(&port->dev, "%s - nonzero write bulk status "
>   		    "received: %d\n", __func__, status);
>
> -	spin_lock(&portdata->lock);
> +	spin_lock_irqsave(&portdata->lock, flags);
>   	--portdata->outstanding_urbs;
> -	spin_unlock(&portdata->lock);
> -	spin_lock(&intfdata->susp_lock);
> +	spin_unlock_irqrestore(&portdata->lock, flags);
> +	spin_lock_irqsave(&intfdata->susp_lock, flags);

     You are allowing an interrupt enabled window where previously it 
wasn't possible. Why notleave these 2 lines as is?

>   	--intfdata->in_flight;
> -	spin_unlock(&intfdata->susp_lock);
> +	spin_unlock_irqrestore(&intfdata->susp_lock, flags);
>
>   	usb_serial_port_softint(port);
>   }

WBR, Sergei

