Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3KFLbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 06:31:52 -0500
Message-ID: <1383737505.14307.37.camel@jlt4.sipsolutions.net> (sfid-20131106_123155_095813_77312458)
Subject: Re: [RFC v2 2/2] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
From: Johannes Berg <johannes@sipsolutions.net>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>
Date: Wed, 06 Nov 2013 12:31:45 +0100
In-Reply-To: <1383737255.4256.34.camel@porter.coelho.fi>
References: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com>
	 <1383684854-21663-2-git-send-email-luciano.coelho@intel.com>
	 <1383735101.14307.25.camel@jlt4.sipsolutions.net>
	 <1383737255.4256.34.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 11:28 +0000, Coelho, Luciano wrote:

> In terms of the order of calls, the difference is that in the past we
> had this:
> 
> 1. Set CSA beacon;
> 2. When count reaches 1, the driver calls ieee80211_csa_finish();
> 3. We call drv_change_chanctx();
> 4. Set new channel beacon.
> 
> (This continues to be the case with my patch when count > 1)
> 
> With my patch, if count <= 1, we do this instead:
> 
> 1. Call drv_change_chanctx();
> 2. Set new channel beacon.
> 
> The main problem without my patch is that the driver shouldn't beacon
> with the CSA element when the count starts <= 1, so it won't have a
> chance to check if the count reached 1 to call ieee80211_csa_finish().

I think the other difference is that one calls
drv_channel_switch_beacon()? The driver might do some channel
preparations there, though I guess you can audit all the drivers (well,
one ...) :)

But that'd need some more documentation, otherwise I'd guess people
would start to rely on drv_channel_switch_beacon() and it would mostly
work - hence my question of whether it makes sense to refuse it at all
in the case of <=1.

johannes

