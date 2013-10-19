Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54173 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3JSIdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Oct 2013 04:33:08 -0400
Received: by mail-ea0-f174.google.com with SMTP id z15so2472549ead.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Oct 2013 01:33:07 -0700 (PDT)
Message-ID: <526243C2.7090607@gmail.com> (sfid-20131019_103313_846732_6F5D8C85)
Date: Sat, 19 Oct 2013 10:33:06 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3.12] rt2800usb: slow down TX status polling
References: <20131017100431.GA9603@redhat.com> <525FF68A.8030806@lwfinger.net> <20131018094238.GA7506@redhat.com>
In-Reply-To: <20131018094238.GA7506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/13 11:42, Stanislaw Gruszka wrote:
> On Thu, Oct 17, 2013 at 09:39:06AM -0500, Larry Finger wrote:
>> I suggest getting rid of the magic numbers as long as you are making
>> this change. A single define could handle the delay time for the two
>> cases.
> 
> Thanks for sugestion Larry, though I do not see clear benefit of
> introduce define since those magic numbers are just time values
> expressed in nano seconds. Anyway patch with define added below.
> John can pick it, if he thinks it is better.
> 
> Stanislaw
> ---
> From 813e0bde7340bad7d3401c6aa2a3f8635ec49597 Mon Sep 17 00:00:00 2001
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> Date: Fri, 18 Oct 2013 11:36:54 +0200
> Subject: [PATCH] rt2800usb: slow down TX status polling
> 
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

I don't care which version gets picked. In both cases:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 96677ce5..997df03 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -148,6 +148,8 @@ static bool rt2800usb_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
>  	return false;
>  }
>  
> +#define TXSTATUS_READ_INTERVAL 1000000
> +
>  static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
>  						 int urb_status, u32 tx_status)
>  {
> @@ -176,8 +178,9 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
>  		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
>  
>  	if (rt2800usb_txstatus_pending(rt2x00dev)) {
> -		/* Read register after 250 us */
> -		hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 250000),
> +		/* Read register after 1 ms */
> +		hrtimer_start(&rt2x00dev->txstatus_timer,
> +			      ktime_set(0, TXSTATUS_READ_INTERVAL),
>  			      HRTIMER_MODE_REL);
>  		return false;
>  	}
> @@ -202,8 +205,9 @@ static void rt2800usb_async_read_tx_status(struct rt2x00_dev *rt2x00dev)
>  	if (test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
>  		return;
>  
> -	/* Read TX_STA_FIFO register after 500 us */
> -	hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 500000),
> +	/* Read TX_STA_FIFO register after 2 ms */
> +	hrtimer_start(&rt2x00dev->txstatus_timer,
> +		      ktime_set(0, 2*TXSTATUS_READ_INTERVAL),
>  		      HRTIMER_MODE_REL);
>  }
>  
> 


-- 
---
Gertjan
