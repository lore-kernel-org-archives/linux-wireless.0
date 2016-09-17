Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:54059 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752891AbcIQRcI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 13:32:08 -0400
Message-ID: <1474133525.32273.97.camel@perches.com> (sfid-20160917_193212_036791_E26DCEF9)
Subject: Re: [PATCH] rtl8xxxu: Stop log spam from each successful interrupt
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Date: Sat, 17 Sep 2016 10:32:05 -0700
In-Reply-To: <1474132155-9330-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1474132155-9330-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-09-17 at 12:09 -0500, Larry Finger wrote:
> As soon as debugging is turned on, the logs are filled with messages
> reporting the interrupt status. As this quantity is usually zero, this
> output is not needed. In fact, there will be a report if the status is
> not zero, thus the debug line in question could probably be deleted.
> Rather than taking that action, I have changed it to only be printed
> when the RTL8XXXU_DEBUG_USB bit is set in the debug mask.

There are many uses of
	if (rtl8xxxu_debug & <DEFINE>) {
		dev_info(dev, ...)

Emitting debugging information at KERN_INFO is odd.

I think it'd be nicer to use dev_dbg for all these cases
and as well use some new macro that includes the test

Something like:

#define rtl8xxxu_dbg(type, fmt, ...)			\
do {							\
	if (rtl8xxxu_debug & (type))			\
		dev_dbg(dev, fmt, ##__VA_ARGS__);	\
} while (0)

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 9f6dbb4..236f33c 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -5260,7 +5260,8 @@ static void rtl8xxxu_int_complete(struct urb *urb)
>  	struct device *dev = &priv->udev->dev;
>  	int ret;
>  
> -	dev_dbg(dev, "%s: status %i\n", __func__, urb->status);
> +	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_USB)
> +		dev_dbg(dev, "%s: status %i\n", __func__, urb->status);
>  	if (urb->status == 0) {
>  		usb_anchor_urb(urb, &priv->int_anchor);
>  		ret = usb_submit_urb(urb, GFP_ATOMIC);
> 
> 
