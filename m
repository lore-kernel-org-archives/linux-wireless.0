Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47757 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0JGHoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 03:44:12 -0400
Received: by iwn9 with SMTP id 9so499445iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 00:44:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010071606.37134.br1@einfach.org>
References: <20101005095510.3083.46174.stgit@tt-desk>
	<201010071003.37599.br1@einfach.org>
	<AANLkTimf=f1DhP68=aHZ7WKVCN9RPBq7sh+46ExnYRVa@mail.gmail.com>
	<201010071606.37134.br1@einfach.org>
Date: Thu, 7 Oct 2010 09:44:06 +0200
Message-ID: <AANLkTin3xh4+aQvMfZH_UF3mnKZp-eYdt3+y++8mEJHb@mail.gmail.com>
Subject: Re: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	adrian@freebsd.org, vasanth@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Guerin <jonathan@guerin.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 7, 2010 at 9:06 AM, Bruno Randolf <br1@einfach.org> wrote:
> which units do you have for the busy time? what about other drivers?
> in ath[59]k we have it as cycles (which is about 1/44000 of a second,
> depending on the mode). so it counts up rather fast.

We've got the busy time in [us] since the last read (the register is
cleared on read).

> some absolute cumulative value would be better, so several userspace processes
> can poll and do their own averaging or percentage calculations.
>
> but which units to use? what would be a good way of solving that?
> any ideas???

That's what 802.11-2007 tells us in regard to the BSS Load element:

<citation>
((channel busy time/(dot11ChannelUtilizationBeaconIntervals *
dot11BeaconPeriod * 1024)) * 255),

where channel busy time is defined to be the number of microseconds
during which the CS mechanism, as
defined in 9.2.1, has indicated a channel busy indication, and the MIB
attribute dot11ChannelUtilization-
BeaconIntervals represents the number of consecutive beacon intervals
during which the channel busy time
is measured. The default value of
dot11ChannelUtilizationBeaconIntervals is defined in Annex D.
</citation>

So, I guess it makes sense to just return the calculated channel
utilization value (u8)
and keep it up to date within the driver.

mac80211 could pass dot11ChannelUtilizationBeaconIntervals (using the default of
16 for now) to the drivers and the drivers would report the calculated value.

Helmut
