Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2KMID6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 03:03:58 -0500
Message-ID: <1352793873.9466.3.camel@jlt4.sipsolutions.net> (sfid-20121113_090401_699122_89EA51D5)
Subject: Re: [PATCH] mac80211: support RX_FLAG_MACTIME_END
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Nov 2012 09:04:33 +0100
In-Reply-To: <CAG6hwVPwYX5Uw+_Y9enGeubeCkWi3OM-qs+qAvKDjwTrNhS0uw@mail.gmail.com> (sfid-20121112_225231_617028_4FC5CCFF)
References: <1352745513-1265-1-git-send-email-thomas@cozybit.com>
	 <1352752959.12957.2.camel@jlt4.sipsolutions.net>
	 <CAG6hwVPwYX5Uw+_Y9enGeubeCkWi3OM-qs+qAvKDjwTrNhS0uw@mail.gmail.com>
	 (sfid-20121112_225231_617028_4FC5CCFF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-12 at 13:52 -0800, Thomas Pedersen wrote:
> On Mon, Nov 12, 2012 at 12:42 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2012-11-12 at 10:38 -0800, Thomas Pedersen wrote:
> >
> >> +     if (ieee80211_have_rx_timestamp(rx_status))
> >> +             /* time when timestamp field was received */
> >> +             t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
> >> +                                                    24 + 12 +
> >> +                                                    elems->total_len + 4,
> >> +                                                    24);
> >
> > This doesn't seem quite right, the FCS isn't accounted for correctly?
> 
> That's what the +4 is for. Is this wrong?

No, ok, I guess that's correct then. I didn't do the calculations to
check. Why not use skb->len though, rather than 24+12+...?

Btw, I think there's a define for FCS_LEN somewhere, that might be
worthwhile to use just for documentation.

> > I think it might be wortwhile to pass the SKB to the function instead of
> > rx_status though, then it could get skb->len and check whether or not
> > FCS was before the timestamp
> 
> How would you check this?

Never mind, you can't know.

> > (which, btw, you should mention in the documentation for the new flag!)
> 
> I'll make it clear MACTIME_END includes the FCS.

Ok.

> > And then I suspect the check for IEEE80211_HW_RX_INCLUDES_FCS is also
> > incorrect -- even if the driver didn't report the FCS maybe the
> > timestamping semantic was such that it was after the FCS?
> 
> Right, if the driver doesn't report the FCS, the radiotap code will
> add an extra 4 bytes to account for this.

Oh, yes, I misread the code, sorry.

johannes

