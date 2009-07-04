Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:49009 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZGDT4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 15:56:21 -0400
Message-ID: <4A4FB3F2.5050405@lwfinger.net>
Date: Sat, 04 Jul 2009 14:56:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
References: <200907040053.05654.chunkeey@web.de> <200907041211.49115.chunkeey@web.de> <4A4F85EE.5090007@lwfinger.net> <200907041928.32269.chunkeey@web.de>
In-Reply-To: <200907041928.32269.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Saturday 04 July 2009 18:40:14 Larry Finger wrote:
>> I have logged the usb transfers, but not yet analyzed them.
> great!
> 
>> This time I got a new failure - I hit this warning at
>>            net/mac80211/tx.c:1299
>>                         retries++;
>>                         if (WARN(retries > 10, "tx refused but queue
>> active\n"))
>>                                 goto drop;
>>                         goto retry;
>>
> 
>> If I have analyzed this correctly, I hit this section of
>> p54_tx_qos_accounting_alloc at drivers/net/wireless/p54/txrx.c:204.
>> I'm running the splitup patches.
>>
>>         if (unlikely(queue->len > queue->limit &&
>> IS_QOS_QUEUE(p54_queue))) {
>>                 spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
>>                 return -ENOSPC;
>>         }
>>
>> Any suggestions on debugging this would be appreciated.
> ---
> diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
> index ea074a6..69fc70a 100644
> --- a/drivers/net/wireless/p54/txrx.c
> +++ b/drivers/net/wireless/p54/txrx.c
> @@ -25,6 +25,7 @@
>  #include "p54.h"
>  #include "lmac.h"
>  
> +#define P54_MM_DEBUG
>  #ifdef P54_MM_DEBUG
>  static void p54_dump_tx_queue(struct p54_common *priv)
>  {
> @@ -200,7 +201,18 @@ static int p54_tx_qos_accounting_alloc(struct p54_common *priv,
>  
>  	spin_lock_irqsave(&priv->tx_stats_lock, flags);
>  	if (unlikely(queue->len > queue->limit && IS_QOS_QUEUE(p54_queue))) {
> +		u16 ac_queue = p54_queue - P54_QUEUE_DATA;
> +		int i;
> +
> +		printk(KERN_DEBUG "TX queue stats\n");
> +		for (i = 0; i < 8; i++)
> +			printk(KERN_DEBUG "\ttxq[%d]: used %d [of %d] => %s\n",
> +			       i, priv->tx_stats[i].len,
> +			       priv->tx_stats[i].limit,
> +			       ieee80211_queue_stopped(priv->hw, ac_queue) ?
> +			       "stopped" : "running");
>  		spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
> +		p54_dump_tx_queue(priv);
>  		return -ENOSPC;
>  	}
>  
> ---
> let's hope the queue .len count does not turn negative!

Sorry. It did. The output of the printk is:

 TX queue stats
        txq[0]: used 0 [of 1] => running
        txq[1]: used 0 [of 1] => running
        txq[2]: used 0 [of 3] => running
        txq[3]: used 0 [of 3] => running
        txq[4]: used 0 [of 16] => running
        txq[5]: used 0 [of 16] => running
        txq[6]: used -1 [of 16] => running
        txq[7]: used 0 [of 16] => running
 phy5: / --- tx queue dump (0 entries) ---
 phy5: \ --- [free: 14592], largest free block: 14592 ---

I added this statement for debugging:

@@ -224,6 +236,7 @@ static void p54_tx_qos_accounting_free(s
                struct p54_tx_data *data = (void *) hdr->data;

                priv->tx_stats[data->hw_queue].len--;
+               WARN_ON(priv->tx_stats[data->hw_queue].len < 0);
        }
        p54_wake_queues(priv);
 }

Since I added that, I have gotten about 15 of the "wlan0: no probe
response from AP 00:1a:70:46:ba:b1 - disassociating" situations where
the interface goes offline, but no more of the negative queue len
variety. It looks as if I will need to debug it first.

Larry
