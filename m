Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:47173 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754157Ab2FWPkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 11:40:45 -0400
Message-ID: <1340466044.7758.4.camel@joe2Laptop> (sfid-20120623_174056_235437_702307D8)
Subject: Re: [PATCH 4/6] mac80211: clean up debugging
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
	Jason Baron <jbaron@redhat.com>
Date: Sat, 23 Jun 2012 08:40:44 -0700
In-Reply-To: <1340456697.4636.1.camel@jlt3.sipsolutions.net>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
	 <1340385525-14487-5-git-send-email-johannes@sipsolutions.net>
	 <1340438536.2274.9.camel@joe2Laptop>
	 <1340456697.4636.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-23 at 15:04 +0200, Johannes Berg wrote:
> On Sat, 2012-06-23 at 01:02 -0700, Joe Perches wrote:
> 
> > I think all the Kconfig debugging options aren't
> > particularly useful.
> > 
> > I think you should use a level/mask module debug
> > variable to enable these instead of appearing to try
> > to minimize the size of the objects via individual
> > Kconfig options.
> > 
> > I think it'd be better to enable them all the time
> > (or not at all when !DEBUG) and select them for output
> > via the debug level.
> 
> I agree, but I don't want to switch twice. Once pr_debug() has dynamic
> sub-selector capabilities, I'll use it here.
> 
> FWIW, I would definitely prefer named rather than bitmap selectors :-)

(Added Jason and Jim)

Given it's a debug-only facility, I think bitmap
selectors sufficient, Maybe adding an external
utility to map names to bits would be enough to
not need that feature in the kernel.

