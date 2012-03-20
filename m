Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1515 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736Ab2CTEXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 00:23:37 -0400
Message-ID: <4F680646.4040707@gmail.com> (sfid-20120320_052410_141158_8FCEE425)
Date: Tue, 20 Mar 2012 05:23:34 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <moorray@wp.pl>
Subject: Re: [PATCH] rt2x00: rt2800usb: schedule txdone work on timeout
References: <1332146385-10330-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1332146385-10330-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/12 09:39, Stanislaw Gruszka wrote:
> This is fix for my current commit
> ed61e2b02027935520d1be884fac0b2ffce8379a
> "rt2x00: rt2800usb: rework txdone code"
> 
> We should schedule txdone work on timeout, otherwise if newer get
> tx status from hardware, we will never report tx status to mac80211
> and eventually never wakeup tx queue.
> 
> Reported-by: Jakub Kicinski <moorray@wp.pl>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index cd490ab..f97f846 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -163,7 +163,13 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
>  
>  		/* Reschedule urb to read TX status again instantly */
>  		return true;
> -	} else if (rt2800usb_txstatus_pending(rt2x00dev)) {
> +	}
> +
> +	/* Check if there is any entry that timedout waiting on TX status */
> +	if (rt2800usb_txstatus_timeout(rt2x00dev))
> +		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
> +
> +	if (rt2800usb_txstatus_pending(rt2x00dev)) {
>  		/* Read register after 250 us */
>  		hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 250000),
>  			      HRTIMER_MODE_REL);


-- 
---
Gertjan
