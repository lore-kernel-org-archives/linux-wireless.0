Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDIMne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 08:43:34 -0400
Message-ID: <1397047400.4964.13.camel@jlt4.sipsolutions.net> (sfid-20140409_144338_752488_A05DFDB9)
Subject: Re: [PATCH 8/8] cfg80211: remove unnecessary include clauses
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Apr 2014 14:43:20 +0200
In-Reply-To: <1397047019.4964.8.camel@jlt4.sipsolutions.net> (sfid-20140409_143809_742831_27C557D7)
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	 <c02aba28b27fe39da9730cd965e322054815713f.1397006688.git.gamerh2o@gmail.com>
	 <1397029770.4964.2.camel@jlt4.sipsolutions.net> <87d2gqg05o.fsf@gmail.com>
	 (sfid-20140409_142534_582747_BF7AE6C3) <1397047019.4964.8.camel@jlt4.sipsolutions.net>
	 (sfid-20140409_143809_742831_27C557D7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 14:36 +0200, Johannes Berg wrote:

> At the current point in time. If some of the headers that you rely on
> including something no longer does in the future because it no longer
> needs that, then you just broke everything.

Take the first of those patches for example. You say

<linux/bug.h> and <linux/net.h> is included by <linux/skbuff.h>.

However, this is a side effect of some implementation detail in
skbuff.h. If, in the future, some function in skbuff.h is no longer
inlined, then skbuff.h will no longer have to include bug.h and can
remove it. That change would break the build due to your patches.

The way you should think about this isn't the mechanic include chain,
it's the API that each file defines. skbuff.h includes bug.h due to an
implementation detail, but it doesn't intentionally re-export all the
bug.h API, that's not the purpose of skbuff.h. The purpose of skbuff.h
is to capture the SKB related APIs and structures, so that's the only
thing you should rely on getting from it.

Similarly, you should include bug.h if you need the APIs from that,
rather than relying on it being included more or less accidentally
through something else.

Obviously, the lack of namespaces etc. in the compiler makes it
impossible to actually enforce this, and as a result we often *miss*
includes that should be there, which sometimes gets found later when
things change or on different platforms if the recursive include was
platform specific, but we shouldn't exacerbate this problem by actively
removing correct includes.

Now, of course, if you find includes that aren't actually *needed* (e.g.
bug.h in a file that doesn't use BUG() or WARN() variants) then those
should be removed.

johannes

