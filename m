Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36156 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab0LDVjG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 16:39:06 -0500
Date: Sat, 4 Dec 2010 13:38:54 -0800
From: Jouni Malinen <j@w1.fi>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Saqeb Akhter <saqeb.akhter@gmail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH for-2.6.37 v2] mac80211: ignore non-bcast mcast
 deauth/disassoc franes
Message-ID: <20101204213854.GA10286@jm.kir.nu>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
 <201011291937.25195.chunkeey@googlemail.com>
 <1291056330.3532.8.camel@jlt3.sipsolutions.net>
 <201011292053.24717.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201011292053.24717.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 29, 2010 at 08:53:23PM +0100, Christian Lamparter wrote:
> This patch fixes an curious issue due to insufficient
> rx frame filtering.

Well.. In theory, there is nothing saying that Deauthentication /
Disassociation frames could not be used with multicast addresses.. Not
that I would expect anyone to really use this option ever.

>  [ 2352.453804] Ignore 0d:1f:31:f8:64:ff
>  [ 2352.453808] Ignore 0d:1f:31:f8:64:ff
>  					   ^^ the group-address flag is set!
>  (the correct SA/TA would be: 00:1f:31:f8:64:ff)
>  
> Since the AP does not know from where the frames come, it
> generates a DEAUTH response for the (invalid) mcast address.
> This mcast deauth frame then passes through all filters and
> tricks the stack into thinking that the AP brutally kicked
> us!

This is an interesting frame for from the AP view point, too.. I don't
remember whether there is any explicit statement about the SA being
individual address, but it would sounds reasonable to avoid sending out
Deauth/Disassoc frames based on this type of bogus addresses if the
result would go out as a multicast frame.

> This patch fixes the problem by simply ignoring
> non-broadcast, group-addressed deauth/disassoc frames.

While this is not strictly speaking correct (i.e., we would need to
check whether we are part of the multicast group group), this sounds
like a reasonable thing to do in case of Deauthentication and
Disassociation frames. I don't really see any reasonable use cases for
non-broadcast multicast with them. Action frames may actually get such
use, so the v2 is a good update.

-- 
Jouni Malinen                                            PGP id EFC895FA
