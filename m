Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:36533 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbYABXHK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 18:07:10 -0500
Date: Thu, 3 Jan 2008 00:05:41 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
Message-ID: <20080103000541.38593206@morte> (sfid-20080102_230720_756179_E4F3C504)
In-Reply-To: <1199287652.4172.90.camel@johannes.berg>
References: <1198253375.16241.76.camel@johannes.berg>
	<20080102084532.GA17960@infradead.org>
	<1199263934.4172.69.camel@johannes.berg>
	<200801021623.36089.mb@bu3sch.de>
	<1199287652.4172.90.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 02 Jan 2008 16:27:32 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> > What about simply _not_ failing the initialization of mac80211, if no
> > rc algo is available? I mean, we can just use a fixed rate we get through
> > WEXT and stuff. Simply start at 1M on init in that case and stay at a fixed
> > 1M until the user sets a different fixed rate through WEXT.
> 
> Not sure. I think I'd prefer not to have all special cases all over, I'd
> much prefer a new rc80211_none or so then.

Agreed. But again, that should be built into mac80211, if we want to work
around issues caused by lack of module autoloading. And to me it looks like
'rc80211_none' implies yet another 'real' rate control algorithm.

I propose to just replace a few lines of code in mac80211 in order to look
for the lowest available rate and set it instead of failing. mac80211 should
[1] correctly deal with forced rates, so that would be everything we need.

[1] I know it doesn't right now. That should be fixed first anyway.


-- 
Ciao
Stefano
