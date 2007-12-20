Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:13909 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbXLTMcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 07:32:54 -0500
Received: by fk-out-0910.google.com with SMTP id z23so3216805fkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2007 04:32:52 -0800 (PST)
Message-ID: <c85cb4470712200432w3640359dje70f57c86be3497a@mail.gmail.com> (sfid-20071220_123258_276259_08A7C94D)
Date: Thu, 20 Dec 2007 14:32:52 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1198145667.16241.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1198145667.16241.23.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > This patch handles the reordering of the Rx A-MPDU.
>
> I thought about this a bit more, here's a counter-proposal. :)
>
> Your current patch means that when a monitor mode interface is up, it
> will receive frames twice because the A-MPDU frames have already passed
> __ieee80211_rx() when they were sent up by the hardware, and that copies
> the frame to the monitor first thing.

true, i forgot monitor is no longer a handle like it used to be, and i
do pass there twice. this can be fixed by checking .ordered field
there

> Also, what you're doing means that
> the frame is accounted for channel load twice (yeah, I know, the stats
> there suck... but still...)

here i am already checking the .ordered field (like i proposed for
monitor), and ignore the in-order frames.

>
> What we'd really want I think is to
>  (1) put the frame to monitor regularly [indicating A-MPDU in the
>     radiotap header, this will need radiotap standard work, so not now]
>  (2) "keep" the frame in the ieee80211_rx_h_reorder_ampdu rx-pre-handler
>  (3) "release" the frame with an appropriate status later
>
> Hence, I think it'd be best to first reorganise the current code:
>  (1) split __ieee80211_rx() right after the pre handler invocation and
>     call e.g. __ieee80211_rx_handlers() which contains all the code
>     from "if (sta && !(sta->flags & (WLAN_STA_WDS | WLAN_STA_ASSOC_AP"
>     to "} else dev_kfree_skb(skb);"
>     The function would have certain requirements like a filled
>     ieee80211_txrx_data and running under rcu_read_lock().
>  (2) then, you don't need status.ordered but can drop the frame right
>     away or pass it to __ieee80211_rx_handlers().
>
> That way, we guarantee that each frame only passes through the complete
> RX path once and your dropping the unordered frames is equivalent to the
> reorder_ampdu handler having an oracle that tells it which frames to

so you suggest to remove ieee80211_rx_h_reorder_ampdu in favor of a
function that will call ieee80211_sta_manage_reorder_buf?
in any case, function or handler, i think it is better to leave this
separation - filtering and reordering -  in 2 different place.

> drop and which to keep :)
>
> Comments?
>

I looked at your proposal, generally it can be done, yet there are
pros and cons we need to consider:
1 - (con) by inserting the .ordered check to ieee80211_rx_monitor or
before it i can avoid changing the code - just 2 more lines and
problem is solved
2 - (pro) yet, i'll end up checking the .ordered field in 3 places -
monitor,statistics and reordering buf, which lowers the encapsulation
of work inside ieee80211_rx_h_reorder_ampdu
3 - (con) i will have to free un-needed sk_buffs in
ieee80211_sta_stop_rx_BA_session without going back to __ieee80211_rx,
 which may confuse othere.
4 - (pro) i'll use less variables (with a little more code, but a clear one)

> johannes
>
>
