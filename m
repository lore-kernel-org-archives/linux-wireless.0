Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1IPLtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 07:49:06 -0400
Subject: Re: [PATCH] mac80211: don't allow zero mac bssid to be configured
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316173301.4130.12.camel@jlt3.sipsolutions.net> (sfid-20110916_134153_147550_D2413B5C)
References: <1316102844-29970-1-git-send-email-lindner_marek@yahoo.de>
	 <201109160514.16603.lindner_marek@yahoo.de>
	 <1316153956.4130.1.camel@jlt3.sipsolutions.net>
	 <201109161327.50915.lindner_marek@yahoo.de>
	 <1316173301.4130.12.camel@jlt3.sipsolutions.net>
	 (sfid-20110916_134153_147550_D2413B5C)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 13:49:05 +0200
Message-ID: <1316173745.4130.15.camel@jlt3.sipsolutions.net> (sfid-20110916_134910_374111_EB0968B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-16 at 13:41 +0200, Johannes Berg wrote:

> FWIW, I think the check there pre-dates the current cfg80211/mac80211
> design. The current assumption in mac80211 clearly is that ifibss->bssid
> is *always* valid since it's set to a random address when asked to join.
> Hence the only way it can be invalid is the bug case you reported (join
> fixed zeroes BSSID).

Actually, that's not true. And in fact, setting a fixed BSSID with a
zero address will cause some funny things to happen, but not necessarily
what you think :-)

The is_zero_ether_addr() check there means "have we found an IBSS
already?" and as such must stay. It doesn't mean "do we have a valid
configuration" at all...

johannes

