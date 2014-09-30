Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56010 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaI3Ial (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:30:41 -0400
Message-ID: <542A6A2A.4070506@openwrt.org> (sfid-20140930_103047_323195_C3EC02D5)
Date: Tue, 30 Sep 2014 10:30:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/3] Revert "ath9k_hw: reduce ANI firstep range for older
 chips"
References: <1412016342-21227-1-git-send-email-nbd@openwrt.org> <21546.1381.6346.449656@gargle.gargle.HOWL>
In-Reply-To: <21546.1381.6346.449656@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-09-30 03:20, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> This reverts commit 09efc56345be4146ab9fc87a55c837ed5d6ea1ab
>> 
>> I've received reports that this change is decreasing throughput in some
>> rare conditions on an AR9280 based device
> 
> Wasn't the original patch for improving stability ? Won't reverting it
> reintroduce the earlier situation ?
The issues that were slightly improved by this patch were fixed in a
different way later. This change has been tested in OpenWrt for 3 weeks now.

> If ANI issues/regressions for pre-AR9003 chips are still arising,
> I wonder what we have gained by the switch and if the new algorithm
> is a good fit for the older chips.
After switching to the new algorithm, a large number of users reported a
very significant increase in stability. Back then, overall stability of
ath9k was a lot worse than it is now, and a much larger number of users
were having trouble with it.

Additionally, the new algorithm is much easier to understand and tune -
the old code (especially the one with both algorithms combined) was an
incomprehensible mess of spaghetti code. I still believe the new
algorithm is better for pre-AR9003 than the old one, just the callback
that applies the settings needs a bit more fine tuning.

The ANI issues that I'm finding these days affect a *much* smaller
number of users, and are less severe than what we've been dealing with
during the time of the switch.

> At least for SoC chips, people will report it to OpenWrt. For PC-OEM
> cards, users will just say that the card sucks and move on...
For pre-AR9003, most devices used with OpenWrt actually use exactly the
same chips as PC-OEM cards.

- Felix
