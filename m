Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46525 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab2FEJdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 05:33:31 -0400
Message-ID: <1338888804.4514.25.camel@jlt3.sipsolutions.net> (sfid-20120605_113335_169866_3B47EF1E)
Subject: Re: [RFC] cfg80211: Fix incompatible interfaces combination
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 05 Jun 2012 11:33:24 +0200
In-Reply-To: <4FCDC838.9010209@qca.qualcomm.com>
References: <1338824836-2283-1-git-send-email-mohammed@qca.qualcomm.com>
			 <1338825141.4512.14.camel@jlt3.sipsolutions.net>
			 <4FCCDB63.3040806@qca.qualcomm.com>
			 <1338826398.4512.23.camel@jlt3.sipsolutions.net>
			 <4FCCDF78.4040606@qca.qualcomm.com>
			 <1338826731.4512.24.camel@jlt3.sipsolutions.net>
			 (sfid-20120604_181856_034243_5406D052) <1338826773.4512.25.camel@jlt3.sipsolutions.net>
		 <4FCDA8DB.9000000@qca.qualcomm.com>
	 <1338878939.4514.11.camel@jlt3.sipsolutions.net>
	 <4FCDC838.9010209@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

> >> static const struct ieee80211_iface_limit a[] = {
> >>           { .max = 2,     .types = BIT(NL80211_IFTYPE_STATION) },
> >> };
> >>
> >> static const struct ieee80211_iface_limit b[] = {
> >>           { .max = 2,     .types = BIT(NL80211_IFTYPE_MESH_POINT) },
> >> };
> >>
> >> static const struct ieee80211_iface_combination if_comb[] = {
> >>           {.limits = a,
> >>           .n_limits = ARRAY_SIZE(a),
> >>           .max_interfaces = 2,
> >>           .num_different_channels = 1,
> >>           },
> >>           {.limits = b,
> >>           .n_limits = ARRAY_SIZE(b),
> >>           .max_interfaces = 2,
> >>           .num_different_channels = 1,
> >>           },
> >>
> >> };
> >>
> >> i could not add mesh interface if a managed interface is already there
> >> and vice versa. if this is the expected behavior, then fine.
> >
> > No, that's not expected! Another bug!

Actually, I'm sorry -- clearly I wasn't paying attention before -- it is
expected. The above means you can add two managed or two mesh interface,
but no combinations of them. Basically, the things in if_comb are XOR,
and the things inside each limit are AND.

johannes

