Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.solarflare.com ([12.187.104.25]:42319 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3HBI4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 04:56:03 -0400
Message-ID: <1375433758.24371.20.camel@deadeye.wl.decadent.org.uk> (sfid-20130802_105614_638017_845D5EF8)
Subject: Re: changing dev->needed_headroom/needed_tailroom?
From: Ben Hutchings <bhutchings@solarflare.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Date: Fri, 2 Aug 2013 10:55:58 +0200
In-Reply-To: <1374850210.8248.59.camel@jlt4.sipsolutions.net>
References: <1374850210.8248.59.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-26 at 16:50 +0200, Johannes Berg wrote:
> Does it seem reasonable to change dev->needed_headroom and
> dev->needed_tailroom on the fly?
> 
> We currently set needed_headroom to the max of what we need, but we
> could do better like making it depend on the interface type (e.g. only
> asking for mesh space on mesh interfaces). This would be done only when
> the interface isn't connected, I can't promise it would be down but the
> carrier would be off.
[...]

I don't think this is safe when the interface is running (even if
carrier is off).  Some functions may read dev->needed_headroom twice and
rely on getting the same value each time.

Also, stacked devices would need to adjust their own needed_headroom
accordingly.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

