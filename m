Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40617 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab3JQOjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:39:11 -0400
Received: by mail-ob0-f172.google.com with SMTP id vb8so1943721obc.31
        for <linux-wireless@vger.kernel.org>; Thu, 17 Oct 2013 07:39:10 -0700 (PDT)
Message-ID: <525FF68A.8030806@lwfinger.net> (sfid-20131017_163913_944180_02F23A3E)
Date: Thu, 17 Oct 2013 09:39:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3.12] rt2800usb: slow down TX status polling
References: <20131017100431.GA9603@redhat.com>
In-Reply-To: <20131017100431.GA9603@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/17/2013 05:04 AM, Stanislaw Gruszka wrote:
> Polling TX statuses too frequently has two negative effects. First is
> randomly peek CPU usage, causing overall system functioning delays.
> Second bad effect is that device is not able to fill TX statuses in
> H/W register on some workloads and we get lot of timeouts like below:
>
> ieee80211 phy4: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 7 in queue 2
> ieee80211 phy4: rt2800usb_entry_txstatus_timeout: Warning - TX status timeout for entry 7 in queue 2
> ieee80211 phy4: rt2800usb_txdone: Warning - Got TX status for an empty queue 2, dropping
>
> This not only cause flood of messages in dmesg, but also bad throughput,
> since rate scaling algorithm can not work optimally.
>
> In the future, we should probably make polling interval be adjusted
> automatically, but for now just increase values, this make mentioned
> problems gone.
>
> Resolve:
> https://bugzilla.kernel.org/show_bug.cgi?id=62781
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>   drivers/net/wireless/rt2x00/rt2800usb.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 96677ce5..e095e61 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -176,8 +176,8 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
>   		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
>
>   	if (rt2800usb_txstatus_pending(rt2x00dev)) {
> -		/* Read register after 250 us */
> -		hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 250000),
> +		/* Read register after 1 ms */
> +		hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 1000000),
>   			      HRTIMER_MODE_REL);
>   		return false;
>   	}
> @@ -202,8 +202,8 @@ static void rt2800usb_async_read_tx_status(struct rt2x00_dev *rt2x00dev)
>   	if (test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
>   		return;
>
> -	/* Read TX_STA_FIFO register after 500 us */
> -	hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 500000),
> +	/* Read TX_STA_FIFO register after 2 ms */
> +	hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 2000000),
>   		      HRTIMER_MODE_REL);
>   }

I suggest getting rid of the magic numbers as long as you are making this 
change. A single define could handle the delay time for the two cases.

Larry

