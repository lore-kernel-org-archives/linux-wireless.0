Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58830 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbbCIMwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 08:52:51 -0400
Message-ID: <1425905568.1928.7.camel@sipsolutions.net> (sfid-20150309_135255_585816_51683525)
Subject: Re: [PATCH] mac80211: handle hw roc cancel vs. expiration race
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Mar 2015 13:52:48 +0100
In-Reply-To: <1425902001-3163-1-git-send-email-eliad@wizery.com> (sfid-20150309_125330_250339_ED541C0C)
References: <1425902001-3163-1-git-send-email-eliad@wizery.com>
	 (sfid-20150309_125330_250339_ED541C0C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 13:53 +0200, Eliad Peller wrote:

> Fix it by cancelling hw_roc_done on roc cancel.
> Since hw_roc_done takes local->mtx, temporarily
> release it (before re-acquiring it and starting
> the next roc if needed).

I can't say I like this, and I'm not even sure it doesn't leave a race?
After all, the work will not take the RTNL.

Also, I think the whole concept is racy because you acquire "found"
before the unlock, but use it after the unlock, so if the work actually
ran (_sync, perhaps it already started) it may have freed the "found"
pointer.

I think the only way to really fix that is to make the driver return the
roc pointer or so and then we can either queue a work struct per roc
struct, or at least mark the roc struct as driver-destroyed and
double-check that in the work function?

Or perhaps we could flush the work before we even take the lock, but
then it might still race with the driver trying to cancel just after we
flushed I guess.

johannes


