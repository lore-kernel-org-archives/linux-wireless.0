Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54216 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757235AbZAMNuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:50:00 -0500
Date: Tue, 13 Jan 2009 15:49:48 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: New command for adding extra IE(s) into
	management frames
Message-ID: <20090113134948.GA16694@jm.kir.nu> (sfid-20090113_145006_753391_F244C56B)
References: <20090113115128.GA11245@jm.kir.nu> <1231853937.3671.28.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231853937.3671.28.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 02:38:57PM +0100, Johannes Berg wrote:

> kmemdup? Might also make sense to not try the allocation if we're going
> to refuse it anyway, but that might be complicated to do and probably
> doesn't matter.

I did not know there is such a thing as kmemdup (apparently not that
many other people, either, taken into account it is not used anywhere in
the generic wireless code). Anyway, yes, it would work here.

Moving the allocation to be done for each subtype separately would add
quite a bit of extra code and error paths. Doing it once resulted in
simpler implementation. The array version was much simpler on this area,
but with separate variables for each subtype, I think it is better to
just allocate (and deal with NULL) once even if we will immediately
after this need to free the buffer in the case the request is going to
be refused.

-- 
Jouni Malinen                                            PGP id EFC895FA
