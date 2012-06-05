Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2FEGtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 02:49:07 -0400
Message-ID: <1338878939.4514.11.camel@jlt3.sipsolutions.net> (sfid-20120605_084911_587722_C002A276)
Subject: Re: [RFC] cfg80211: Fix incompatible interfaces combination
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 05 Jun 2012 08:48:59 +0200
In-Reply-To: <4FCDA8DB.9000000@qca.qualcomm.com>
References: <1338824836-2283-1-git-send-email-mohammed@qca.qualcomm.com>
		 <1338825141.4512.14.camel@jlt3.sipsolutions.net>
		 <4FCCDB63.3040806@qca.qualcomm.com>
		 <1338826398.4512.23.camel@jlt3.sipsolutions.net>
		 <4FCCDF78.4040606@qca.qualcomm.com>
		 <1338826731.4512.24.camel@jlt3.sipsolutions.net>
		 (sfid-20120604_181856_034243_5406D052) <1338826773.4512.25.camel@jlt3.sipsolutions.net>
	 <4FCDA8DB.9000000@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

> > No, initialization was incorrect -- this is better:
> > http://p.sipsolutions.net/e5ab0f3e38f90d6d.txt
> >
> 
> thanks a lot for the patch!
> with the above patch ath9k seems be working fine with the single 
> incompatible adhoc interface.

Ok, cool.

> but i was just experimenting with ath9k(similar to iwlwifi having 
> hw->wiphy->n_iface_combinations > 1) with this patch.
> 
> static const struct ieee80211_iface_limit a[] = {
>          { .max = 2,     .types = BIT(NL80211_IFTYPE_STATION) },
> };
> 
> static const struct ieee80211_iface_limit b[] = {
>          { .max = 2,     .types = BIT(NL80211_IFTYPE_MESH_POINT) },
> };
> 
> static const struct ieee80211_iface_combination if_comb[] = {
>          {.limits = a,
>          .n_limits = ARRAY_SIZE(a),
>          .max_interfaces = 2,
>          .num_different_channels = 1,
>          },
>          {.limits = b,
>          .n_limits = ARRAY_SIZE(b),
>          .max_interfaces = 2,
>          .num_different_channels = 1,
>          },
> 
> };
> 
> i could not add mesh interface if a managed interface is already there 
> and vice versa. if this is the expected behavior, then fine.

No, that's not expected! Another bug!

We should write some unit tests for this code I guess :-)

> iteration 1: cfg80211_can_change_interface all_iftypes 4 and used_iftypes 84
> iteration 2: cfg80211_can_change_interface all_iftypes 80 and used_iftypes 84

Curious. Why did it accept it then? Where did you place the printk?

I'm handling Linus's problem right now, so it'll be a bit until I can
look at this in more detail again.

johannes

