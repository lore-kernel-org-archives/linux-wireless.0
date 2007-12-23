Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:41875 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbXLWQPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 11:15:24 -0500
Received: by fg-out-1718.google.com with SMTP id e21so686060fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 23 Dec 2007 08:15:22 -0800 (PST)
Message-ID: <c85cb4470712230815u158cd19fjc1ff58a7e2c83fbc@mail.gmail.com> (sfid-20071223_161530_246214_F8E329B8)
Date: Sun, 23 Dec 2007 18:15:22 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1198154463.16241.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1198145667.16241.23.camel@johannes.berg>
	 <c85cb4470712200432w3640359dje70f57c86be3497a@mail.gmail.com>
	 <1198154463.16241.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Basically, it seems to me that you're injecting frames down the same
> __ieee80211_rx() path when they have already gone through that, and then
> after the fact annotate pretty much all of that path before the actual
> rx handlers (after pre-handlers) with "skip if reordered frame". That I
> don't really like, it means we need to special-case everything we ever
> put there.
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
> RX path once and your dropping the unordered frames is equivalent to

Johannes, i re-inspected the code to implement your solution, and it
is not straight forward as you have seen it.
what we do now in __ieee80211_rx is:
- invoke monitor
- fill in txrx_data
- invoke michael_mic_report (if needed)
- call pre-handlers of QoS that change txrx_data as well.
- call pre-handlers of statistics that change txrx_data
- call reorder buffer prehandler
    - saving sk_buff to reordering buffer.
    - if we can, send sk_buffs back to __ieee80211_rx, that will
properly fill txrx_data

now, in order to proceed according to your implementation, as i do not
call again  __ieee80211, and do not get the txrx_data restored,  i
will either:
1 - have to fill in txrx_data inside reordering function, which will
end in massive code duplication, and i don't like this solution
2 - keep the whole txrx_data and not only the sk_buff inside
reordering buffer, which will end up in allocation of the txrx_data
struct for every incoming frame, or in a big maximum possible size of
64 pre-allocated array of txrx_data per tid - this is either waste of
cpu or memory
3 - stick to my current implementation, but assure that no function
will be called for ordered frames on their second call in __ieee80211.
we already mentioned it may lead to low encapsulation of reordering
mechanism.

so, what do you think about next solution:

1 - move the rxtx_data indifferent functionality out of __ieee80211_rx
(monitor, load and reordering) to, lets say __ieee80211_rx_pre_handle.
2 - __ieee80211_rx_pre_handle will be called for each frame. either
directly or through tasklet.
3 - in regular state, proceed to __ieee80211_rx immediately, in
reorder state loop over __ieee80211_rx for each already ordered frame.
4 - I thought to eliminate __ieee80211_invoke_rx_handlers(local,
local->rx_pre_handlers), as QoS will be the only one to inhabit it
now, so it may move to ieee80211_invoke_rx_handlers(local,
local->rx_handlers)

sorry for the long mail, but i wanted to write my full opinion about this issue.
