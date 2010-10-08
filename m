Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48817 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759314Ab0JHRl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 13:41:58 -0400
Received: by fxm14 with SMTP id 14so633672fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 10:41:56 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
Date: Fri, 8 Oct 2010 19:41:06 +0200
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	nbd@openwrt.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, adrian@freebsd.org,
	vasanth@atheros.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jonathan Guerin <jonathan@guerin.id.au>
References: <20101005095510.3083.46174.stgit@tt-desk> <AANLkTin3xh4+aQvMfZH_UF3mnKZp-eYdt3+y++8mEJHb@mail.gmail.com> <1286437954.3657.17.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286437954.3657.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010081941.07134.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 07 Oktober 2010 schrieb Johannes Berg:
> On Thu, 2010-10-07 at 09:44 +0200, Helmut Schaa wrote:
> 
> > So, I guess it makes sense to just return the calculated channel
> > utilization value (u8)
> > and keep it up to date within the driver.
> 
> Not good, that means drivers implementing this will have to wake the CPU
> to do calculations even if nobody cares.

You're obviously right. But that would be the same if mac80211 would do
the calculation. And if we would only calculate it when the survey is
requested the measurement window could be very large or very small which
both might be unwanted.

This could also introduce problems related to register overflows. Since
on rt2800 the register (32bit) is in units of [us] it would overflow after
a bit more then one hour making the calculation flawed in that (maybe
unusual) case.

Nevertheless I fully agree that it doesn't make sense to always calculate
the busy time values if nobody actually needs it. But if somebody cares it
would be nice to have it as a percentage value.

Helmut
