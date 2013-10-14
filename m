Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lizzard.sbs.de ([194.138.37.39]:25311 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab3JNPBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 11:01:30 -0400
Message-ID: <1381762681.3711.36.camel@djensen-laptop> (sfid-20131014_170132_794613_C73511EA)
Subject: Re: [PATCH] cfg80211: fix channel to frequency mapping in 5.9GHz
 range
From: Dennis H Jensen <dennis.h.jensen@siemens.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 14 Oct 2013 16:58:01 +0200
In-Reply-To: <1381759370.13092.11.camel@jlt4.sipsolutions.net>
References: <1381492780-3068-1-git-send-email-dennis.h.jensen@siemens.com>
	 <1381499778.14293.21.camel@jlt4.sipsolutions.net>
	 <1381506302.3711.10.camel@djensen-laptop>
	 <1381752176.13092.10.camel@jlt4.sipsolutions.net>
	 <1381752976.3711.14.camel@djensen-laptop>
	 <1381759370.13092.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-14 at 16:02 +0200, Johannes Berg wrote:
> On Mon, 2013-10-14 at 14:16 +0200, Dennis H Jensen wrote:
> > On Mon, 2013-10-14 at 14:02 +0200, Johannes Berg wrote:
> > > On Fri, 2013-10-11 at 17:45 +0200, Dennis H Jensen wrote:
> > > 
> > > > > > +		else if (chan > 196)
> > > > > > +			return 5000 + (chan - 15) * 5;
> > > > > 
> > > > > Where does the +/- 15 come from? I can't find any evidence for this in
> > > > > Annex E.
> > > > 
> > > > I didn't double check Annex E. I just wanted to recover the lost
> > > > frequencies that the 15 channels (182 - 196), map into 4.9 GHz.
> > > 
> > > "Recover"? When did they work? What broke them?
> > 
> > The commit 59eb21a6504731fc16db4cf9463065dd61093e08 moved those channels
> > to 4.9 GHz but left a hole in the 5.9 Ghz range.
> 
> But there was no +/- 15 before, so what gives?

Well no :) but there also wasn't a special case for that particular
channel set (182 - 196).

So now, when you configure the frequency 5910, it is mapped to channel
182 which is mapped back to 4910 and nothing works, at least let the
functions be the inverse of the other.

In case that doesn't do it. What is needed to get channel 182 to be 5910
MHz as Annex E defines for the US and Europe? Channel to frequency
mapping based on operating class?

//Dennis

