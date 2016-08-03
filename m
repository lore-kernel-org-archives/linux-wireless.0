Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46700 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbcHCGwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 02:52:40 -0400
Message-ID: <1470207156.2638.9.camel@sipsolutions.net> (sfid-20160803_085244_312889_FFF1CA7A)
Subject: Re: [PATCH v2] nl80211: Receive correct value for
 NL80211_MESHCONF_HT_OPMODE command
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com
Date: Wed, 03 Aug 2016 08:52:36 +0200
In-Reply-To: <9967cc0f-777e-31f6-0c4a-a788e92b9049@gmail.com> (sfid-20160803_030740_199957_D258CC14)
References: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com>
 <1470138089-6864-1-git-send-email-masashi.honma@gmail.com>
	 <9967cc0f-777e-31f6-0c4a-a788e92b9049@gmail.com>
	 (sfid-20160803_030740_199957_D258CC14)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch could over write cfg->ht_opmode even though EINVAL.
> I will modify this.
> 

Don't think that actually matters since then it shouldn't be used, but
the v3 patch looks good.

I'm not sure we should bother to do cross-setting validation? Like, I
mean, validating that non-GF and non-HT aren't set together, etc. Those
are somewhat nonsense configurations, but we can't prevent them all.

I'm actually half thinking that we could just remove all restrictions
on this and allow any u16 value of this field, and rely on
wpa_supplicant to do the right thing... Then we don't have to update
this if we ever want to do something new either.

What do you think? What does the validation actually help us with?

johannes
