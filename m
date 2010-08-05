Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab0HEJDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 05:03:14 -0400
Subject: Re: [PATCH 3/3 v2] mac80211: AMPDU rx reorder timeout timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201008050136.41821.chunkeey@googlemail.com>
References: <201008050136.41821.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 11:04:37 +0200
Message-ID: <1280999077.4058.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-08-05 at 01:36 +0200, Christian Lamparter wrote:
> This patch introduces a new timer, which will release
> queued-up MPDUs from the reorder buffer, whenever
> they've waited for more than HT_RX_REORDER_BUF_TIMEOUT
> (which is at around 100 ms).
> 
> The advantage of having a dedicated timer, instead of
> relying on a constant stream of freshly arriving aMPDUs
> to release the old ones, is particularly observable when
> even a small fraction of MPDUs are forever lost at
> low network speeds.
> 
> Previously under these circumstances frames would become
> stuck in the reorder buffer and the network stack of both
> HT peers throttled back, instead of revving up and
> gunning the pipes.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> WIP -> v1:
>  	- thread-safe ampdu reordering
>  	- do the reorder release in the timer
> 
> v1 -> v2:
> 	- update documentation entries
> 	- refine locking
> 
> NB:
> I hope the timed release stuff is now probably protected against
> races from the RX - path. The code was tested and nothing blew up,
> that said the testbed only had a puny single-core Pentium M engine...
> 
> But nevertheless, it managed to hold tcp speed high enough to
> qualify as an 11n device (~ 60mbps) over the bad link.

This set looks fine to me. I may do some cleanup afterwards wrt. the rx
struct :-)

johannes

