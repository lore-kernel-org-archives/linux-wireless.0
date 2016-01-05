Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:51556 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbcAEKHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:07:03 -0500
Date: Tue, 5 Jan 2016 12:06:59 +0200
From: Jouni Malinen <j@w1.fi>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: add use_minrate param to
 ieee80211_tx_prepare_skb()
Message-ID: <20160105100659.GA3864@w1.fi> (sfid-20160105_110707_190191_4FCBFAEE)
References: <1451984419-5727-1-git-send-email-janusz.dziedzic@tieto.com>
 <20160105094504.GA3015@w1.fi>
 <CALhHN=qfmdQuTeHEAvE0BgS2XvZJrBVUhU3BYgXMCY-pe5Ur0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALhHN=qfmdQuTeHEAvE0BgS2XvZJrBVUhU3BYgXMCY-pe5Ur0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2016 at 10:56:18AM +0100, Janusz Dziedzic wrote:
> On 5 January 2016 at 10:45, Jouni Malinen <j@w1.fi> wrote:
> > On Tue, Jan 05, 2016 at 10:00:19AM +0100, Janusz Dziedzic wrote:
> >> Add use_minrate param to ieee80211_tx_prepare_skb() function.
> >> This is useful in case we would like to send frames
> >> with lowest rates, eg. nullfunc, probe_resp.
> >
> > I could kind of understand this for short frames like Data nullfunc and
> > PS-Poll, but why would we like to hard code Probe Response frames to be
> > sent at the lowest rate? Shouldn't the frames be sent at a rate that is
> > most likely to get them through and do so in a manner that does not use
> > excessive amount of air time?
> >
> This is used to get/send probe_req() frame, next used by ath9k
> "hw_scan" when chanctx used.

Sure, but that's not what I'm asking. I'm asking why would we want to
force Probe Response frames to use the lowest rate based on that commit
message above. If that's a typo and should have been Probe Request
frame, I'm going to ask the same question about Probe Request frames.
Why would we like to force the lowest rate to be used for them?

-- 
Jouni Malinen                                            PGP id EFC895FA
