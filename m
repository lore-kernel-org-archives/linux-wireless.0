Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14774 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYJTJdy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:33:54 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 02:33:54 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18684.20459.335157.171344@gargle.gargle.HOWL> (sfid-20081020_113410_151531_B726DAA0)
Date: Mon, 20 Oct 2008 15:01:23 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224493957.18024.47.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
	<18684.18492.94865.480736@gargle.gargle.HOWL>
	<1224493957.18024.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Can you change your quote string from " > " to "> "? Just asking, if you
> can't/don't want to that's fine, it just always confuses me for a
> second. I really should try to figure out if I can convince my mailer to
> highlight " > " indented text as quote too.

Sure, adding (setq vm-included-text-prefix "> ") in my .emacs did the trick. :)

> > Well, currently ath9k maintains a buffer list for each tid.
> > When mac80211 sends down a frame, if the recipient has an aggr. session going,
> > it is appended to the tid's buffer list. Non-HT frames are sent out immediately.
> 
> Incidentally, why the distinction between HT and non-HT frames?

HT frames for aggregation enabled STAs are processed in the TX completion path, so
they are buffered.

> > On TX completion, we run through all the ACs, STAs and TIDs and send out pending
> > frames as aggregates.
> 
> So basically you can always have one frame or one aggregation
> "pack" (for lack of a better word) queued to the hw?
> 

I am not sure, I should check.

> > mac80211 can probably help by maintaining the TX state for each TID, maintain the
> > buffer list, etc.  and provide appropriate mechanisms for drivers to obtain pending
> > frames as and when needed.
> 
> Sure could. Intel's hw would probably like a way to say "stop this TID"
> and "wake this TID" which is what they tried to do using real queues.
> mac80211 could queue up the frames in per-station state and provide a
> functions like
> 
> ieee80211_stop_aggr_stream(struct ieee80211_sta *sta, u8 tid);
> ieee80211_wake_aggr_stream(struct ieee80211_sta *sta, u8 tid);
> 
> or something like that. Then those frames would flow into the right
> queue. We might need a multi-layer start/stop management but we already
> do, we've just managed to get away without it without tx stalls. Or they
> just haven't been reported yet.
> 

Makes sense, ath9k currently has a similar set of functions ( pausing/resuming TIDs).
How would the pending frames for each TID be managed ?
Will the driver be able to pull them as and when needed or would mac80211
push them down on checking if the TID is awake ?

Sujith
