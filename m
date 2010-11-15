Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60836 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556Ab0KOUbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 15:31:02 -0500
Date: Mon, 15 Nov 2010 22:30:48 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH] mac80211: match only assigned bss in sta_info_get_bss
Message-ID: <20101115203048.GA6757@jm.kir.nu>
References: <1284492854.3703.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1284492854.3703.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 09:34:14PM +0200, Johannes Berg wrote:
> sta_info_get_bss() is used to match STA pointers
> for VLAN/AP interfaces, but if the same station
> is also added to multiple other interfaces it
> will erroneously match because both pointers are
> NULL, fix this by ignoring NULL pointers here.

> @@ -125,7 +125,7 @@ struct sta_info *sta_info_get_bss(struct
>  				    lockdep_is_held(&local->sta_mtx));
>  	while (sta) {
>  		if ((sta->sdata == sdata ||
> -		     sta->sdata->bss == sdata->bss) &&
> +		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&

This (commit a2c1e3dad516618cb0fbfb1a62c36d0b0744573a) seems to cause
some changes that may not have been intended.. I'm not sure whether to
call them all regressions, but it does break my 802.11w test setup.. ;-)

With this change in place, robust management frames injected on a cooked
monitor interface do not get protected by mac80211 in station mode
(i.e., PMF in use on wlan0 and PTK in place; use mon0 to inject a
frame) while they used to get protected before this change. Reverting
this on top of wireless-testing.git now gets the old behavior back, too.
I have not verified whether this applies to other uses of cooked monitor
(e.g., Data frames or AP mode where Shared Key auth actually expects
injected frame to get protected in normal, non-testing-only use case).

Is this a bug? Or do I need to figure out another way of getting the
frames injected on a monitor interface encrypted by mac80211?

-- 
Jouni Malinen                                            PGP id EFC895FA
