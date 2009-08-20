Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:51737 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZHTT4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 15:56:11 -0400
Date: Thu, 20 Aug 2009 21:56:11 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: fix configure_filter invocation after stop
Message-ID: <20090820195611.GH6171@mail.wantstofly.org>
References: <1250790381.9307.5.camel@johannes.local> <1250791340.9307.6.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250791340.9307.6.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 20, 2009 at 08:02:20PM +0200, Johannes Berg wrote:

> Since configure_filter can sleep now, any multicast
> configuration needed to be postponed to a work struct.
> This, however, lead to a problem that we could queue
> the work, stop the device and then afterwards invoke
> configure_filter which may lead to driver hangs and is
> a bug. To fix this, we can just cancel the filter work
> since it's unnecessary to do after stopping the hw.
> 
> Since there are various places that call drv_stop, and
> two of them do very similar things, the code for them
> can be put into a shared function at the same time.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Reported-by: Lennert Buytenhek <buytenh@wantstofly.org>

Seems to work for me, I now no longer see firmware commands being
posted after ->stop() is called.

Tested-by: Lennert Buytenhek <buytenh@marvell.com>
