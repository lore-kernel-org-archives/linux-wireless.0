Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15046 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbZGOPWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 11:22:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 08:22:52 -0700
Date: Wed, 15 Jul 2009 08:22:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 4/5] mac80211: add WoW support
Message-ID: <20090715152250.GD5682@mosca>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
 <1247617320-20163-5-git-send-email-lrodriguez@atheros.com>
 <1247659055.2477.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1247659055.2477.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 04:57:35AM -0700, Johannes Berg wrote:
> On Tue, 2009-07-14 at 20:21 -0400, Luis R. Rodriguez wrote:
> > If we're associated and have not already gone into PS mode
> > we ensure send a nullfunc frame before going to suspend. Upon
> > resume we ensure we restore PS mode if it was enabled and inform
> > the driver accordingly, also notify the AP we're awake.
> > 
> > WoW requires the radio to be left on during suspend, to do this
> > we inform drivers of the requested wow triggers on the mac80211
> > stop callback.
> 
> I don't think this patch would work if ath9k unprogrammed the hardware
> correctly in ->remove_interface(), since you don't seem to skip that
> call.

We just stop ANI in remove interface and reclaim beacon resources.
As per documentation it seems we are not correctly removing the MAC
address in ath9k for the removed interface to stop sending ACKs back.
I'd rather see that as a separate patch fix, but you do have a point.
As is right now though this doesn't affect WoW.

  Luis
