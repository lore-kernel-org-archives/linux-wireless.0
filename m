Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab2JYTyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 15:54:54 -0400
Message-ID: <1351194926.10421.19.camel@jlt4.sipsolutions.net> (sfid-20121025_215457_954077_60DB919C)
Subject: Re: [PATCH] mac80211: Don't inspect Sequence Control field on
 control frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linville@tuxdriver.com, Javier Lopez <jlopex@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Thu, 25 Oct 2012 21:55:26 +0200
In-Reply-To: <CAPjQAd-L4jJqaw7aXw6_Yi17c5-p67edQgR+=Zu2F+W=_V+T4A@mail.gmail.com> (sfid-20121025_214515_809051_FC9E969B)
References: <1351188618-11155-1-git-send-email-javier@cozybit.com>
	 <1351194222.10421.18.camel@jlt4.sipsolutions.net>
	 <CAPjQAd-L4jJqaw7aXw6_Yi17c5-p67edQgR+=Zu2F+W=_V+T4A@mail.gmail.com>
	 (sfid-20121025_214515_809051_FC9E969B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-25 at 12:44 -0700, Javier Cardona wrote:

> >> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> >> index f975f64..bf54336 100644
> >> --- a/net/mac80211/rx.c
> >> +++ b/net/mac80211/rx.c
> >> @@ -1467,6 +1467,10 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
> >>
> >>       hdr = (struct ieee80211_hdr *)rx->skb->data;
> >>       fc = hdr->frame_control;
> >> +
> >> +     if (ieee80211_is_ctl(fc))
> >
> > Different question -- why check _is_ctl rather than !_is_data?
> 
> Per the Std, management frames can also be fragmented (not that I've
> ever seen one).  The standard only excludes control frames.

Oh, really? Ok. Applied.

johannes

