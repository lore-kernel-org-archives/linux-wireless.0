Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663Ab2BWSr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 13:47:28 -0500
Subject: Re: [PATCH] mac80211 radiotap injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@google.com>
Cc: Lars Bro <larsbro@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <CA+yqC4be_Zn48LyRMLCX5bDJt3+Ls5+y4hwb1WZ9gK=9Yd++ZA@mail.gmail.com> (sfid-20120223_194532_916934_DF8FF208)
References: <loom.20120221T000341-610@post.gmane.org>
	 <1330004589.3448.12.camel@jlt3.sipsolutions.net>
	 <CA+yqC4be_Zn48LyRMLCX5bDJt3+Ls5+y4hwb1WZ9gK=9Yd++ZA@mail.gmail.com>
	 (sfid-20120223_194532_916934_DF8FF208)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 19:47:26 +0100
Message-ID: <1330022846.3448.18.camel@jlt3.sipsolutions.net> (sfid-20120223_194744_567313_618A6F56)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 10:45 -0800, Sam Leffler wrote:

> > Please read
> > http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches, particularly the references at the bottom of the page.
> >
> > Please also follow the style of the surrounding code.
> 
> I tried (for my stuff); it's helpful if you can point out at least one
> specific issue.  The code went through checkpatch for example.

Commit log for instance, in this particular patch.

> >>     IEEE80211_RADIOTAP_F_FRAG: frame will be fragmented if longer than the
> >>                             current fragmentation threshold.
> >>
> >> + * IEEE80211_RADIOTAP_RATE
> >> +   legacy transmit rate in .5 Mb/s units (u8)
> >
> > This looks quite strange, for example.
> 
> Strange how?  The .5 units are consistent w/ IEEE legacy rate codes.
> Not sure how you want to express values like 5.5 to the kernel.

Oh, just the formatting -- the above is indented, this isn't.

> >> + * @IEEE80211_TX_CTL_NO_RC: This frame does not require rate control.
> >> + *   This flag is used when an injected frame includes a transmit
> >> + *   rate (and possibly flags and retry count) in the radiotap header.
> >
> > Does that really have to be here? This is the last bit we have, and it
> > seems this is internal so ... ?
> 
> So ... what?  I saw it was the last bit didn't see another way to tag
> state in the skb (and the cb looked to be max size so there was no
> room to expand it).

I was thinking it could be in struct ieee80211_tx_data.flags?

johannes

