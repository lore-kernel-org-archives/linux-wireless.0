Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2GBPML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 11:12:11 -0400
Message-ID: <1341241929.19642.17.camel@jlt3.sipsolutions.net> (sfid-20120702_171216_610875_D1E03C0A)
Subject: Re: [PATCH 60g v2 1/5] wireless: add 802.11ad (60gHz band)
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <anamtsov@gmail.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 02 Jul 2012 17:12:09 +0200
In-Reply-To: <CA+XVXfduVieZEVF4eav+K+YHv=B+VoTjZmquMtOrg6XPKVVkOA@mail.gmail.com> (sfid-20120702_162228_232132_CBDCF6A4)
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1341210756-11054-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <CA+XVXfduVieZEVF4eav+K+YHv=B+VoTjZmquMtOrg6XPKVVkOA@mail.gmail.com>
	 (sfid-20120702_162228_232132_CBDCF6A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-02 at 17:22 +0300, Arik Nemtsov wrote:

> enum ieee80211_band {
> 	IEEE80211_BAND_2GHZ = NL80211_BAND_2GHZ,
> 	IEEE80211_BAND_5GHZ = NL80211_BAND_5GHZ,
> 
> 	/* keep last */
> 	IEEE80211_NUM_BANDS
> };
> 
> If the 60Ghz band goes here as well, IEEE80211_NUM_BANDS will be
> incremented. 

Yes, this happened.

> I'm guessing this can be problematic for a lot of drivers
> that use this value more or less blindly (and pass indices to FW etc).
> At least the wlcore driver will be impacted.
> 
> So this probably should be added, but maybe keep IEEE80211_NUM_BANDS
> the same for legacy reasons?

Can't do that, it's used for array sizing etc.

It looks like your driver may crash as it accesses bands[x] for all
possible values of x ... might want to fix that soon as I've applied
these patches :)

johannes

