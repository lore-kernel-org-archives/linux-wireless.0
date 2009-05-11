Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38469 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZEKNqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 09:46:09 -0400
Date: Mon, 11 May 2009 08:54:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wext: fix get_wireless_stats locking
Message-ID: <20090511125442.GB2721@tuxdriver.com>
References: <1241953217.12068.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241953217.12068.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 10, 2009 at 01:00:17PM +0200, Johannes Berg wrote:
> Currently, get_wireless_stats is racy by _design_. This is
> because it returns a buffer, which needs to be statically
> allocated since it cannot be freed if it was allocated
> dynamically. Also, SIOCGIWSTATS and /proc/net/wireless use
> no common lock, and /proc/net/wireless accesses are not
> synchronised against each other. This is a design flaw in
> get_wireless_stats since the beginning.
> 
> This patch fixes it by wrapping /proc/net/wireless accesses
> with the RTNL so they are protected against each other and
> SIOCGIWSTATS. The more correct method of fixing this would
> be to pass in the buffer instead of returning it and have
> the caller take care of synchronisation of the buffer, but
> even then most drivers probably assume that their callback
> is protected by the RTNL like all other wext callbacks.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Is it acceptable to hold rtnl between ->open and ->release?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
