Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41621 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbaLROBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 09:01:46 -0500
Message-ID: <1418911302.6134.11.camel@sipsolutions.net> (sfid-20141218_150149_770100_C4953C2D)
Subject: Re: [PATCH] nl80211: increase the max number of rules in regdomain
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Thu, 18 Dec 2014 15:01:42 +0100
In-Reply-To: <CA+XVXfcT5vevfSMHoeNobjLOrzeZdO-XerEB6rLxD_6LqLfhcQ@mail.gmail.com> (sfid-20141218_150014_621617_B447F870)
References: <1418832044-25582-1-git-send-email-arik@wizery.com>
	 <1418910981.6134.9.camel@sipsolutions.net>
	 <CA+XVXfcT5vevfSMHoeNobjLOrzeZdO-XerEB6rLxD_6LqLfhcQ@mail.gmail.com>
	 (sfid-20141218_150014_621617_B447F870)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-12-18 at 15:59 +0200, Arik Nemtsov wrote:
> On Thu, Dec 18, 2014 at 3:56 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-12-17 at 18:00 +0200, Arik Nemtsov wrote:
> >> Some network cards (Intel) produce per-channel regdomains and rely on
> >> cfg80211 to merge rules as needed. This hits the max rules limit and
> >> fails.
> >
> > Maybe we should consider just getting rid of this or bumping it to
> > something ridiculously large like 1000? Looking at how this is (not)
> > used, there's no real sense in limiting it. The only possible problem is
> > the O(n^2) complexity when doing an intersection, but processing a
> > million combinations is probably not a big deal? In fact, even if that
> > becomes a problem, we can easily optimise that complexity away by
> > sorting the rules or so. Then it becomes O(n log n)...
> 
> Well when someone does NL80211_CMD_GET_REG from usermode, we send the
> entire regdom in a single message, so 1000 rules may become
> problematic..

Good point. But arguably that's a different problem :)

johannes

