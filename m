Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37169 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaBBWOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 17:14:39 -0500
Received: by mail-ee0-f51.google.com with SMTP id b57so3290226eek.24
        for <linux-wireless@vger.kernel.org>; Sun, 02 Feb 2014 14:14:38 -0800 (PST)
Message-ID: <52EEC34B.2030208@gmail.com> (sfid-20140202_231446_148544_0603B18C)
Date: Sun, 02 Feb 2014 23:14:35 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: move frequent messages to debug
 level
References: <1391170689-23038-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1391170689-23038-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/14 13:18, Stanislaw Gruszka wrote:
> On commit 28f2bce9f8bbf704c86f8c684337f82c51592c81 I make change that
> print various messages as default. This can cause flood of messages
> related to TX status timeout on some environments. I partially fixed
> problem on commit bb9c298f3193ac5b80e47b325c690700580b6bcf, but forgot
> to move two more messages to debug level.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index caddc1b..14a90dd 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -125,9 +125,9 @@ static inline bool rt2800usb_entry_txstatus_timeout(struct queue_entry *entry)
>  
>  	tout = time_after(jiffies, entry->last_action + msecs_to_jiffies(100));
>  	if (unlikely(tout))
> -		rt2x00_warn(entry->queue->rt2x00dev,
> -			    "TX status timeout for entry %d in queue %d\n",
> -			    entry->entry_idx, entry->queue->qid);
> +		rt2x00_dbg(entry->queue->rt2x00dev,
> +			   "TX status timeout for entry %d in queue %d\n",
> +			   entry->entry_idx, entry->queue->qid);
>  	return tout;
>  
>  }
> @@ -566,8 +566,8 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
>  		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
>  
>  		if (unlikely(rt2x00queue_empty(queue))) {
> -			rt2x00_warn(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
> -				    qid);
> +			rt2x00_dbg(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
> +				   qid);
>  			break;
>  		}
>  
> 


-- 
---
Gertjan
