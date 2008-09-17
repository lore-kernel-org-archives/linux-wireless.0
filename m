Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39881 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYIQXEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 19:04:11 -0400
Date: Wed, 17 Sep 2008 16:03:57 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: re-enable aggregation
Message-ID: <20080917230357.GA7410@tesla> (sfid-20080918_010415_392178_6A9D45A8)
References: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com> <1221547036.8916.1.camel@johannes.berg> <1ba2fa240809171357p1b190760h19c3e521e100f7e4@mail.gmail.com> <43e72e890809171545k5aeaa52dje2223bdbeb97ce7e@mail.gmail.com> <1ba2fa240809171557i498cb5e1rcacb5961d8e1c3c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1ba2fa240809171557i498cb5e1rcacb5961d8e1c3c6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 17, 2008 at 03:57:25PM -0700, Tomas Winkler wrote:
> On Thu, Sep 18, 2008 at 1:45 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, Sep 17, 2008 at 1:57 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> >> On Tue, Sep 16, 2008 at 9:37 AM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >>> On Mon, 2008-09-15 at 20:17 -0700, Luis R. Rodriguez wrote:
> >>>
> >>>> +/**
> >>>> + * is_part_ampdu - tells us whether this buffer is part of an AMPDU
> >>>> + *
> >>>> + * @skb: the buffer we want to check
> >>>> + * @hw: the &struct ieee80211_hw to check the queue mapping on
> >>>> + */
> >>>> +static inline bool is_part_ampdu(struct sk_buff *skb, struct ieee80211_hw *hw)
> >>>> +{
> >>>> +     return (skb_get_queue_mapping(skb) >=
> >>>> +             ieee80211_num_regular_queues(hw));
> >>>> +}
> >>>> +
> >>>
> >>> This is making the patch needlessly large and makes it change drivers
> >>> etc, please just keep the flag and set it based on this in master xmit
> >>> after we've cleared the info.
> >>>
> >> Yes, please keep the flag. Otherwise our rate scale algorithm won't work
> >
> > OK -- you can ignore this I like the path you took better.
> 
> What I need to next is to add is rtnl_lock
> qdisc_root_lock requires this. This root lock is held during requeuing
> which can be triggered by removal or addition of an aggregation queue.

I saw that, but rtnl_lock() is mutex basd so no good. Hence we need
something that works around this.

  Luis
