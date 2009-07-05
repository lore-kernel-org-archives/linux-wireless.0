Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:35587 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZGEN73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 09:59:29 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
Date: Sun, 5 Jul 2009 15:59:32 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200907040053.05654.chunkeey@web.de> <4A4FB3F2.5050405@lwfinger.net> <4A4FC61A.30004@lwfinger.net>
In-Reply-To: <4A4FC61A.30004@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907051559.32958.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 04 July 2009 23:14:02 Larry Finger wrote:
> Larry Finger wrote:
> > @@ -224,6 +236,7 @@ static void p54_tx_qos_accounting_free(s
> >                 struct p54_tx_data *data = (void *) hdr->data;
> > 
> >                 priv->tx_stats[data->hw_queue].len--;
> > +               WARN_ON(priv->tx_stats[data->hw_queue].len < 0);
> >         }
> >         p54_wake_queues(priv);
> >  }
> > 
> 
> The new WARN_ON did _NOT_ trigger when the len went negative.
Now that's what I call a really cool coincident!
The only _official_ codepath where the queue len actually could be
decremented is not really responsible for this -1!

maybe, after decreasing priv->tx_stats[data->hw_queue].len--;
we should override data->hw_queue (aka mark) and place WARN_ON
everywhere (e.g. p54_free_skb / p54_find_and_unlink_skb & p54_dump_tx_queue
whenever they spot the marker.

(OT: in there's a _wrong_ p54_tx_qos_accounting_free in p54_rx_eeprom_readback
 which will be removed... 
 however its a bit unlikely this causes this havok as the eeprom_readback is a
 control frame and therefore p54_tx_qos_accounting_free is a nop for those)

> The only other place where len could be decremented is through
> txhdr->backlog. I noticed that the p54common.c had
> 
> txhdr->backlog = current_queue->len;
> 
> This was replaced in txrx.c by
> 
> txhdr->backlog = priv->tx_stats[queue].len - 1;
>
> Was this intentional?
the spec only says "Number of backlogged frames for given queue."
however there's no word about if this count is for the number of
frames which [are already(now)]/[or will be(old behaviour)]
in the device memory window... 

and to add more confusion => there's even a third interpretation:
could be this the number of frames which are still buffered by the driver,
because they don't fit yet?

Now back to the lines:
I somehow fail to see how exactly tx_stats[queue].len gets
decremented here?
as the result of priv->tx_stats[queue].len - 1 will be written into
txhdr->backlog and not priv->tx_stats[queue].len?

it's really a txhdr->backlog = priv->tx_stats[queue].len - 1;
vs.
priv->tx_stats[queue].len = priv->tx_stats[queue].len - 1;

where as the second one is obviously wrong _here_...

> To test if this is the problem, I added the following hunk:
> 
> @@ -840,6 +853,7 @@ int p54_tx_80211(struct ieee80211_hw *de
>         txhdr->crypt_offset = crypt_offset;
>         txhdr->hw_queue = queue;
>         txhdr->backlog = priv->tx_stats[queue].len - 1;
> +       WARN_ON(!priv->tx_stats[queue].len);
>         memset(txhdr->durations, 0, sizeof(txhdr->durations));
>         txhdr->tx_antenna = ((info->antenna_sel_tx == 0) ?
>                 2 : info->antenna_sel_tx - 1) & priv->tx_diversity_mask;
> 
> This WARN_ON did trigger just before txq[6].len went negative. I'm now
> testing with that changed as follows:
> 
> @@ -839,7 +852,8 @@ int p54_tx_80211(struct ieee80211_hw *de
>         }
>         txhdr->crypt_offset = crypt_offset;
>         txhdr->hw_queue = queue;
> -       txhdr->backlog = priv->tx_stats[queue].len - 1;
> +       txhdr->backlog = priv->tx_stats[queue].len;
> +       WARN_ON(priv->tx_stats[queue].len < 0);
>         memset(txhdr->durations, 0, sizeof(txhdr->durations));
>         txhdr->tx_antenna = ((info->antenna_sel_tx == 0) ?
>                 2 : info->antenna_sel_tx - 1) & priv->tx_diversity_mask;
> 
> This WARN_ON did not trigger, but I still had the queue len go negative.
well, you have to change the WARN_ON to  priv->tx_stats[queue].len <= 0 (or ==)
as priv->tx_stats[queue].len will never be 0 here, because it was just 
incremented by p54_tx_qos_accounting_alloc.
> 
> One other question: struct p54_burst is defined in lmac.h, but it
> doesn't seem to be used anywhere. Will it be needed later?
It's on the todo list...... somewhere.
However, the LMAC API needs to be updated for this.
As there is no description (TBD) about the flags.

Regards,
	Chr
