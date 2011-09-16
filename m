Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1IPLln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 07:41:43 -0400
Subject: Re: [PATCH] mac80211: don't allow zero mac bssid to be configured
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201109161327.50915.lindner_marek@yahoo.de>
References: <1316102844-29970-1-git-send-email-lindner_marek@yahoo.de>
	 <201109160514.16603.lindner_marek@yahoo.de>
	 <1316153956.4130.1.camel@jlt3.sipsolutions.net>
	 <201109161327.50915.lindner_marek@yahoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 13:41:41 +0200
Message-ID: <1316173301.4130.12.camel@jlt3.sipsolutions.net> (sfid-20110916_134153_147550_D2413B5C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-16 at 13:27 +0200, Marek Lindner wrote:

> > Right. So that means you shouldn't be rejecting the configuration when
> > actually using it. You should be rejecting it when it's actually set.
> 
> I'd like to remind you that it was not me who designed the original check (my 
> patch does not add anything new). If you are looking for somebody to beautify 
> your code you'll have to look somewhere else.

If you're looking to fix a problem, I told you how to fix it.
If you're just reporting a bug along with "this is what I think the fix
might be" then maybe you shouldn't take rejection of the proposal so
badly.

I was, maybe erroneously, assuming that you wanted to fix the issue.

> As I said: Feel free to propose an alternative patch. I certainly won't.

Fair enough. I take it you're just reporting a bug then.

> > Also, this patch is wrong -- at that point, checking for zero address serves
> > a difference purpose I think, it means more something along the lines of
> > "did we previously find an IBSS".
> 
> Can't agree here. This check was conceived to hinder a fixed-bssid 
> configuration of 00:00:00:00:00:00.

You just said that you didn't originally design it so how do you know
the design intent? :-)

FWIW, I think the check there pre-dates the current cfg80211/mac80211
design. The current assumption in mac80211 clearly is that ifibss->bssid
is *always* valid since it's set to a random address when asked to join.
Hence the only way it can be invalid is the bug case you reported (join
fixed zeroes BSSID).

Anyway. The right fix remains in cfg80211, and the is_zero_ether_addr()
check in mac80211 can be deleted as it is completely pointless since
it'll never be false.

johannes

