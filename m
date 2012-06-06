Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2FFJWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:22:13 -0400
Message-ID: <1338974532.4513.53.camel@jlt3.sipsolutions.net> (sfid-20120606_112228_438567_4D0084D9)
Subject: Re: [RFC] multi-channel work
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 11:22:12 +0200
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

Sorry it took me so long to go through all your work.

> The patchset clarifies channel handling by cfg80211. As I understand
> we want to treat monitor interface as a special case. Monitor
> interface can be used as a passive way to sniff data on other
> interfaces. Monitor may have a channel set - this should be only
> possible when there are no other interfaces running. Otherwise we
> can't easily do channels accounting (with regard to interface
> combinations). In other words the virtual monitor interface concept is
> copied from mac80211 to cfg80211 itself making the whole thing more
> consitent in my opinion.
> 
> The patchset also introduces num_different_channel checks. It hasn't
> been thoroughly tested yet.

I think this looks good. The monitor/software iftypes thing is something
we should discuss more with other people like Kalle & Bing who work on
non-mac80211 drivers, but maybe we can remove the software iftypes thing
from the driver API (not from nl80211) and make monitor always have the
semantics that mac80211 has today.

The only other non-trivial issue I see is the IBSS handling.

Thanks for doing this!

johannes

