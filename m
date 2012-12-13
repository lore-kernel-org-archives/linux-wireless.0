Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab2LMX0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 18:26:19 -0500
Message-ID: <1355441201.9463.42.camel@jlt4.sipsolutions.net> (sfid-20121214_002622_512285_CB520C0E)
Subject: Re: [PATCH 2/5] mac80211: use del_timer_sync for final sta cleanup
 timer deletion
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Eliad Peller <eliad@wizery.com>
Date: Fri, 14 Dec 2012 00:26:41 +0100
In-Reply-To: <1355439573-13206-3-git-send-email-johannes@sipsolutions.net> (sfid-20121213_235927_069921_DDF2F57A)
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
	 <1355439573-13206-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121213_235927_069921_DDF2F57A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 23:59 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This is a very old bug, but there's nothing that prevents the
> timer from running while the module is being removed when we
> only do del_timer() instead of del_timer_sync().
> 
> The timer should normally not be running at this point, but
> it's not clearly impossible (or we could just remove this.)

Ok it's very unlikely -- the timer would have to rearm itself and the
fire the exact same moment we try to del_timer() it, so it's still
running when we return, and then we'd have to unload the module quickly
enough to invalidate that code that's running there ... it's a bit of a
stretch, but not completely impossible.

johannes

