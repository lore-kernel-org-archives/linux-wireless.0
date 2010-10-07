Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:47080 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751024Ab0JGHGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 03:06:37 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0882765193
	for <linux-wireless@vger.kernel.org>; Thu,  7 Oct 2010 16:06:35 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
Date: Thu, 7 Oct 2010 16:06:36 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	adrian@freebsd.org, vasanth@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Guerin <jonathan@guerin.id.au>
References: <20101005095510.3083.46174.stgit@tt-desk> <201010071003.37599.br1@einfach.org> <AANLkTimf=f1DhP68=aHZ7WKVCN9RPBq7sh+46ExnYRVa@mail.gmail.com>
In-Reply-To: <AANLkTimf=f1DhP68=aHZ7WKVCN9RPBq7sh+46ExnYRVa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010071606.37134.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu October 7 2010 15:51:49 Helmut Schaa wrote:
> On Thu, Oct 7, 2010 at 3:03 AM, Bruno Randolf <br1@einfach.org> wrote:
> > On Wed October 6 2010 18:54:37 Helmut Schaa wrote:
> >> On Tue, Oct 5, 2010 at 11:55 AM, Bruno Randolf <br1@einfach.org> wrote:
> >> > This adds three new values to the survey results:
> >> > 
> >> >  * BUSY - percentage of time the channel was busy
> >> >  * BUSY_TX - percentage of time spent transmitting frames
> >> >  * BUSY_RX - percentage of time spent receiving frames
> >> 
> >> Does BUSY include BUSY_RX and BUSY_TX already? At least on
> >> rt2800 devices we only have access to BUSY which already includes
> >> BUSY_RX and TX.
> > 
> > yes, BUSY includes TX and RX.
> > 
> >> And what about BUSY on the secondary channel in case of 40Mhz?
> > 
> > i have no information about that. luis?
> 
> At least we've got a register for that in rt2800 ;)
> That's why I'm asking.

which units do you have for the busy time? what about other drivers?

in ath[59]k we have it as cycles (which is about 1/44000 of a second, 
depending on the mode). so it counts up rather fast.

i have been thinking more about it and i think my current approach is flawed. 
the idea was that we probably need to use a percentage as the least common 
denominator between all drivers, and i wanted to leave the time period up to 
userspace. so if userspace wants to have the percentage in the last second, it 
would poll every second, if it wants it every 100ms it would poll every 100ms.
that would work, if there is only one userspace process querying this in 
regular intervals.

but what if there is a second process who does the same, or a user issues "iw 
wlan0 survey dump", that would reduce the timespan for the other process... so 
that is obviously flawed...

some absolute cumulative value would be better, so several userspace processes 
can poll and do their own averaging or percentage calculations. 

but which units to use? what would be a good way of solving that?
any ideas???

bruno
