Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45172 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0A1Jvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 04:51:38 -0500
Date: Thu, 28 Jan 2010 10:51:36 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"kalle.valo@iki.fi" <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>
Subject: Re: [PATCH] mac80211: wait for beacon before enabling powersave
Message-ID: <20100128095136.GP25367@mail.wantstofly.org>
References: <1264511993.25642.9.camel@johannes.local> <43e72e891001271001r2cc39da4ka00a3eef06f6e139@mail.gmail.com> <1264615477.8619.20.camel@wwguy-ubuntu> <43e72e891001271014j667221bqa11d56f3a68f6099@mail.gmail.com> <1264616062.8619.22.camel@wwguy-ubuntu> <43e72e891001271025s27bbe25cs3c999a885551a4e7@mail.gmail.com> <1264618781.8619.31.camel@wwguy-ubuntu> <43e72e891001271113k6dad9004v5a17c705ae51aa2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891001271113k6dad9004v5a17c705ae51aa2f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2010 at 11:13:11AM -0800, Luis R. Rodriguez wrote:

> >> >> >> > Because DTIM information is required for powersave
> >> >> >> > but is only conveyed in beacons, wait for a beacon
> >> >> >> > before enabling powersave, and change the way the
> >> >> >> > information is conveyed to the driver accordingly.
> >> >> >> >
> >> >> >> > mwl8k doesn't currently seem to implement PS but
> >> >> >> > requires the DTIM period in a different way; after
> >> >> >> > talking to Lennert we agreed to just have mwl8k do
> >> >> >> > the parsing itself in the finalize_join work.
> >> >> >>
> >> >> >> Not sure if this is merged yet. If not it might be good to add to the
> >> >> >> commit log a brief about the impact of the fix for distribution
> >> >> >> purposes looking to cherry pick some fixes that may cure some issues.
> >> >> >>
> >> >> >> The impact of this fix is that the DTIM settings of > 1 would now be
> >> >> >> respected in the odd situation a beacon would not be received prior to
> >> >> >> association. Ensuring we use a higher DTIM would mean saving more
> >> >> >> power as it would mean we can sleep longer.
> >> >> >>
> >> >> >> This is not propagated to stable but if it turns out this can enhance
> >> >> >> power save since DTIM might usually be > 1 and the race may be more
> >> >> >> common than we expected we may need a respective stable solution.
> >> >> >>
> >> >> >
> >> >> > It will be nice to see a respective solution for stable since this
> >> >> > impact power save which is very important for certain platform.
> >> >>
> >> >> Well how about your patch for stable then?
> >> >>
> >> > if ok with you and Johannes, I will like to see it happen, the only
> >> > issue is, my patch only address iwlwifi but not mwl8k.
> >>
> >> Oh, what was the issue with your patch and mwl8k?
> >>
> > the patch will call drv_config() and ieee80211_recal_ps()
> > mwl8k driver did not implement PS function, but do require dtim for
> > another reason
> 
> Lennert, why does it need it if it does not implement the PS function?
> Firmware API? What would happen if its not passed?

As long as client PS isn't implemented, it should be fine to just pass
1 into the FINALIZE_JOIN command.
