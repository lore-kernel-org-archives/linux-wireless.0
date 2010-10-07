Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129Ab0JGHwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 03:52:41 -0400
Subject: Re: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	nbd@openwrt.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, adrian@freebsd.org,
	vasanth@atheros.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jonathan Guerin <jonathan@guerin.id.au>
In-Reply-To: <AANLkTin3xh4+aQvMfZH_UF3mnKZp-eYdt3+y++8mEJHb@mail.gmail.com>
References: <20101005095510.3083.46174.stgit@tt-desk>
	 <201010071003.37599.br1@einfach.org>
	 <AANLkTimf=f1DhP68=aHZ7WKVCN9RPBq7sh+46ExnYRVa@mail.gmail.com>
	 <201010071606.37134.br1@einfach.org>
	 <AANLkTin3xh4+aQvMfZH_UF3mnKZp-eYdt3+y++8mEJHb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 09:52:34 +0200
Message-ID: <1286437954.3657.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 09:44 +0200, Helmut Schaa wrote:

> So, I guess it makes sense to just return the calculated channel
> utilization value (u8)
> and keep it up to date within the driver.

Not good, that means drivers implementing this will have to wake the CPU
to do calculations even if nobody cares.

johannes

