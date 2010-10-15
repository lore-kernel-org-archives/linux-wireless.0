Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0JOFwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 01:52:49 -0400
Subject: Re: [PATCH 2/2] mac80211: Add support for CQM tx bitrate monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinyc56O-xeYEMSD+B=yWNnd_Ch-NUrPv5uGQyr1@mail.gmail.com>
References: <20101014224326.9E9912005F@glenhelen.mtv.corp.google.com>
	 <AANLkTinyc56O-xeYEMSD+B=yWNnd_Ch-NUrPv5uGQyr1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 07:53:30 +0200
Message-ID: <1287122010.3640.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-14 at 22:21 -0700, Paul Stewart wrote:
> On Thu, Oct 14, 2010 at 2:40 PM, Paul Stewart <pstew@google.com> wrote:
> > +       if (mcs_rate_table_cache[mcs] == 0) {
> > +               modulation = mcs & 7;
> > +               streams = (mcs >> 3) + 1;
> > +               base_rate = (rate_ptr->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ?
> > +                 13500000 : 6500000;
> > +               gi_div = (rate_ptr->flags & IEEE80211_TX_RC_SHORT_GI) ? 9 : 10;
> > +               rate_val = base_rate * mod_table[modulation] * streams / gi_div;
> > +               mcs_rate_table_cache[mcs] = (rate_val + 5000) / 10000;
> > +       }
> > +
> > +       return  mcs_rate_table_cache[mcs] * 100;
> > +}
> 
> Um, that doesn't work right.  The cache needs to be 4 times as big to
> account for account from 40MHZ and SHORT_GI.  I'll send a revised
> version of this tomorrow.

Can't you just precalculate it anyway? Like at compile time?

johannes

