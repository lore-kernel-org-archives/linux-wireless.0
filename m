Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaBCMng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 07:43:36 -0500
Message-ID: <1391431407.4488.9.camel@jlt4.sipsolutions.net> (sfid-20140203_134402_047400_66535498)
Subject: Re: [RFC 0/2] cfg80211: add channel switching awareness
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Feb 2014 13:43:27 +0100
In-Reply-To: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com> (sfid-20140203_110347_817013_693B94E8)
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110347_817013_693B94E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:

> The patchset aims at making cfg80211 aware of
> channel switches.

That seems like a worthy goal :)

> This makes it possible for more elegant channel
> switching behavior by moving the decision up to
> cfg80211.
> 
> Until now mac80211 could start channel switching
> internally for STA, mesh and IBSS interfaces
> without userspace interaction. This bypassed
> interface combination checks at the very least.
> 
> Now mac80211 requests cfg80211 to channel switch
> an interface, in a similar manner as userspace
> asks cfg80211 for a channel switch. This makes it
> possible to perform interface combination checks
> (albeit it is not implemented yet).

Couldn't you just return the decision to mac80211? It would also have to
keep track of start/end of the CSA period, I guess, since a few things
that Ilan is working on shouldn't be allowed while the AP announces CSA.

> The channel switch is split into two phases now -
> start and finalize. This is required to make
> cfg80211 in control of the whole channel
> switching process. It also makes it apparent that
> mac80211's STA CSA offload doesn't work quite well
> here. Can we kill it?

No. Well, you could make cfg80211 be in charge, but not wpa_supplicant,
I think.

> The initial patchset has a lot of TODOs in the
> code and the idea is to provide follow up patches
> that implement missing functionality.
> 
> Major drawback now is cfg80211 will refuse a
> channel switch if there's one in progress already,
> although this shouldn't be much of a problem in
> most use cases.
> 
> This approach should be suited for multi-interface
> CSA as well as some other cases such as
> "GO-follows-STA".
> 
> The patchset seemed to work in my limited testing
> (ath9k as AP and iwldvm as STA).

Nice. I hope Luca can take a look too :)

johannes

