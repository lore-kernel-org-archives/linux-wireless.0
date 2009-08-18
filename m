Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:43731 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZHREAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 00:00:38 -0400
Date: Tue, 18 Aug 2009 06:00:39 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 10/29] mwl8k: fix mwl8k_configure_filter() parameter lifetime issue
Message-ID: <20090818040039.GA4116@mail.wantstofly.org>
References: <20090818035233.GO18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090818035233.GO18639@mail.wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 05:52:33AM +0200, Lennert Buytenhek wrote:

> mwl8k_configure_filter() passes pointers to total_flags and the
> multicast address list to a workqueue function, while there is no
> guarantee that those pointers will still be valid by the time the
> workqueue function runs.
> 
> Solve this by passing total_flags by value, and by passing an
> already built multicast address setup command packet to the workqueue
> function so that we don't have to look at the multicast address list
> itself outside of mwl8k_configure_filter().
> 
> Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>

This will clash with:

	http://article.gmane.org/gmane.linux.kernel.wireless.general/38141

But that is easy to fix up.  (The easiest would probably be to not
apply the mwl8k part of that patch, and I'll send a followup patch
to implement ->prepare_multicast() for mwl8k.)
