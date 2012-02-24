Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2BXHPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 02:15:15 -0500
Subject: Re: [PATCH] mac80211 radiotap injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@google.com>
Cc: Lars Bro <larsbro@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <CA+yqC4ZEqv+fwG61yeTQCdj2qaEm5xz_o2FUWeH+GkLuvz_zBA@mail.gmail.com> (sfid-20120223_231203_701825_15763B97)
References: <loom.20120221T000341-610@post.gmane.org>
	 <1330004589.3448.12.camel@jlt3.sipsolutions.net>
	 <CA+yqC4be_Zn48LyRMLCX5bDJt3+Ls5+y4hwb1WZ9gK=9Yd++ZA@mail.gmail.com>
	 <1330022846.3448.18.camel@jlt3.sipsolutions.net>
	 <CA+yqC4ZEqv+fwG61yeTQCdj2qaEm5xz_o2FUWeH+GkLuvz_zBA@mail.gmail.com>
	 (sfid-20120223_231203_701825_15763B97)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 08:15:09 +0100
Message-ID: <1330067709.3426.0.camel@jlt3.sipsolutions.net> (sfid-20120224_081541_162409_84830462)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 14:11 -0800, Sam Leffler wrote:
> On Thu, Feb 23, 2012 at 10:47 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-02-23 at 10:45 -0800, Sam Leffler wrote:
> 
> >> >> + * @IEEE80211_TX_CTL_NO_RC: This frame does not require rate control.
> >> >> + *   This flag is used when an injected frame includes a transmit
> >> >> + *   rate (and possibly flags and retry count) in the radiotap header.
> >> >
> >> > Does that really have to be here? This is the last bit we have, and it
> >> > seems this is internal so ... ?
> >>
> >> So ... what?  I saw it was the last bit didn't see another way to tag
> >> state in the skb (and the cb looked to be max size so there was no
> >> room to expand it).
> >
> > I was thinking it could be in struct ieee80211_tx_data.flags?
> 
> I don't see how to get a handle on a ieee80211_tx_data struct in
> ieee80211_monitor_start_xmit.  It looks like the tx path allocates it
> on the stack for all the subhandlers but this is called through the
> netdevice ops vector.

Ok, fair enough. I wasn't sure any more if it was allocated early enough
or if maybe it would be possible to move it. Felix had promised to make
some space in the tx info anyway :)

johannes

