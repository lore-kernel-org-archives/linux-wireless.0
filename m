Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36661 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3HBNLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 09:11:24 -0400
Message-ID: <1375449082.3927.5.camel@edumazet-glaptop> (sfid-20130802_151132_530453_32527D50)
Subject: Re: changing dev->needed_headroom/needed_tailroom?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Fri, 02 Aug 2013 06:11:22 -0700
In-Reply-To: <1375433758.24371.20.camel@deadeye.wl.decadent.org.uk>
References: <1374850210.8248.59.camel@jlt4.sipsolutions.net>
	 <1375433758.24371.20.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-02 at 10:55 +0200, Ben Hutchings wrote:

> I don't think this is safe when the interface is running (even if
> carrier is off).  Some functions may read dev->needed_headroom twice and
> rely on getting the same value each time.

It should be no problem. Remaining unsafe places should be fixed.

We already had this discussion in the past, and some patches were
issued. Check commit ae641949df01b85117845bec45328eab6d6fada1
("net: Remove all uses of LL_ALLOCATED_SPACE")




