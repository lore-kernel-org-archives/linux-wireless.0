Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3BTKGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:06:48 -0500
Message-ID: <1361354804.8629.15.camel@jlt4.sipsolutions.net> (sfid-20130220_110710_686710_F2EC05E0)
Subject: Re: [RFC 1/2] mac80211: disconnect on suspend in managed mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Feb 2013 11:06:44 +0100
In-Reply-To: <20130219164714.GA27140@redhat.com>
References: <20130219164714.GA27140@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-19 at 17:47 +0100, Stanislaw Gruszka wrote:
> If possible that after suspend cfg80211 receive request to disconnect
> what require action on interface that was removed during suspend.
> Problem can manifest itself by various warnings similar to below one:
[...]
> To fix the problem disconnect from AP during suspend.

This will fix the immediate problem, but not in general. What if we're
joined to an IBSS while suspending? A similar thing could happen. Or
operating as an AP? Or joined to a mesh? etc.

I think it'd be better to implement this as explicit disconnect, leave,
teardown, whatever ... in cfg80211 rather than mac80211, although then
of course mac80211 could have a bunch of cleanups, e.g. the various
_quiesce functions could be reduced then I think.

johannes

