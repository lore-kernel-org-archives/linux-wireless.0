Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59675 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1E3H5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 03:57:34 -0400
Received: by bwz15 with SMTP id 15so2669289bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 00:57:33 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH 1/3] rt2x00: Serialize TX operations on a queue.
Date: Mon, 30 May 2011 09:55:43 +0200
Cc: users@rt2x00.serialmonkey.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
References: <cover.1306586311.git.gwingerde@gmail.com> <201105281647.35855.helmut.schaa@googlemail.com> <4DE288DB.7040309@gmail.com>
In-Reply-To: <4DE288DB.7040309@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201105300955.43779.helmut.schaa@googlemail.com> (sfid-20110530_095738_092833_3850D674)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[CC'ed Johannes & linux-wireless]

Am Sonntag, 29. Mai 2011 schrieb Gertjan van Wingerde:
> On 05/28/11 16:47, Helmut Schaa wrote:
> > Am Samstag, 28. Mai 2011 schrieb Gertjan van Wingerde:
> >>>> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> >>>> index f1e1381..2ace0f9 100644
> >>>> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> >>>> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> >>>> @@ -555,15 +555,21 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
> >>>>  			       bool local)
> >>>>  {
> >>>>  	struct ieee80211_tx_info *tx_info;
> >>>> -	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
> >>>> +	struct queue_entry *entry;
> >>>>  	struct txentry_desc txdesc;
> >>>>  	struct skb_frame_desc *skbdesc;
> >>>>  	u8 rate_idx, rate_flags;
> >>>> +	int ret = 0;
> >>>> +
> >>>> +	spin_lock_bh(&queue->tx_lock);
> >>>> +
> >>>
> >>> Shouldn't spin_lock be enough already? All tx calls from mac80211 are already
> >>> done in softirq context or protected by local_bh_disable/enable. This would be
> >>> especially useful on single CPU machines since spin_lock (without _bh) can be
> >>> optimized out on these.
> >>
> >> AFAICT not all tx calls from mac80211 are protected by local_bh_disable/enable. I believe
> >> that this is the case for the "process" context tx calls from
> > 
> >> ieee80211_subif_start_xmit
> > 
> > This should only be called from the network softirq and thus doesn't require bottom halves
> > to be disabled (AFAIK).
> > 
> >> and
> >> ieee80211_monitor_start_xmit.
> > 
> > Same here.
> 
> Hmm, are you sure about this?

Maybe Johannes can clarify this for us ;)

Johannes, are all calls to the drivers tx callback done in softirq context or
adequately protected by local_bh_disable/enable? Or is this presumption wrong?

Thanks,
Helmut
