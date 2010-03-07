Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49687 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab0CGVX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 16:23:29 -0500
Date: Sun, 7 Mar 2010 23:23:19 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix sta_mtx unlocking on insert STA failure
 path
Message-ID: <20100307212319.GA11281@jm.kir.nu>
References: <20100306163508.GA9236@jm.kir.nu>
 <1267988567.3912.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1267988567.3912.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 07, 2010 at 08:02:47PM +0100, Johannes Berg wrote:
> > By the way, that roaming between two vifs did not work either, but
> > regardless, fixing missing mutex_unlock is of higher priority.. The STA
> > entry was not updated to point to the correct dev when the STA roamed
> > from one BSS to another one (both BSSes running on the same wiphy). To
> > be more exact, I think it was updated once, but not when roaming back to
> > the original BSS.
> 
> This must be due to the sta_find_bss thing Felix did because hostapd
> wasn't using the right ifindex...

Yes, it was and I finally remembered to go through the patches from
Felix to get this fixed. Multi-BSS works now with the current hostap.git
version of hostapd and driver_nl80211.c.

-- 
Jouni Malinen                                            PGP id EFC895FA
