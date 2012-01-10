Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:46182 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933544Ab2AJAZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 19:25:21 -0500
Message-ID: <4F0B8571.1040106@boundarydevices.com> (sfid-20120110_012541_994124_C10FAD4D)
Date: Mon, 09 Jan 2012 17:25:21 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] rtl8192cu: Fix WARNING on suspend/resume
References: <4f0b6e4d.P81fZnkPWac6eQEc%Larry.Finger@lwfinger.net>
In-Reply-To: <4f0b6e4d.P81fZnkPWac6eQEc%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/9/2012 3:46 PM, Larry Finger wrote:
>
> +#ifdef CONFIG_PM_SLEEP
> +static int rtl8192cu_usb_suspend(struct usb_interface *pusb_intf,
> +				 pm_message_t message)
> +{
> +	/* Increase usage_count to Save loaded fw across suspend/resume */
> +	atomic_inc(&usage_count);
> +	return 0;
> +}
> +
>
If firmware is not actively loaded on a 0 to 1 transition of 
usage_count, what good is this
atomic_inc doing?

I admit that my understanding is probably at fault, but it looks odd.


I took off list because this message is probably just noise.

Troy

