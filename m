Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1671 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2FEJyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 05:54:45 -0400
Message-ID: <4FCDD74B.9070203@qca.qualcomm.com> (sfid-20120605_115448_251279_DC642B88)
Date: Tue, 5 Jun 2012 15:24:19 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] cfg80211: Fix incompatible interfaces combination
References: <1338824836-2283-1-git-send-email-mohammed@qca.qualcomm.com>			 <1338825141.4512.14.camel@jlt3.sipsolutions.net>			 <4FCCDB63.3040806@qca.qualcomm.com>			 <1338826398.4512.23.camel@jlt3.sipsolutions.net>			 <4FCCDF78.4040606@qca.qualcomm.com>			 <1338826731.4512.24.camel@jlt3.sipsolutions.net>			 (sfid-20120604_181856_034243_5406D052) <1338826773.4512.25.camel@jlt3.sipsolutions.net>		 <4FCDA8DB.9000000@qca.qualcomm.com>	 <1338878939.4514.11.camel@jlt3.sipsolutions.net>	 <4FCDC838.9010209@qca.qualcomm.com> <1338888804.4514.25.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338888804.4514.25.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 June 2012 03:03 PM, Johannes Berg wrote:
> Hi Mohammed,
>
>>>> static const struct ieee80211_iface_limit a[] = {
>>>>            { .max = 2,     .types = BIT(NL80211_IFTYPE_STATION) },
>>>> };
>>>>
>>>> static const struct ieee80211_iface_limit b[] = {
>>>>            { .max = 2,     .types = BIT(NL80211_IFTYPE_MESH_POINT) },
>>>> };
>>>>
>>>> static const struct ieee80211_iface_combination if_comb[] = {
>>>>            {.limits = a,
>>>>            .n_limits = ARRAY_SIZE(a),
>>>>            .max_interfaces = 2,
>>>>            .num_different_channels = 1,
>>>>            },
>>>>            {.limits = b,
>>>>            .n_limits = ARRAY_SIZE(b),
>>>>            .max_interfaces = 2,
>>>>            .num_different_channels = 1,
>>>>            },
>>>>
>>>> };
>>>>
>>>> i could not add mesh interface if a managed interface is already there
>>>> and vice versa. if this is the expected behavior, then fine.
>>>
>>> No, that's not expected! Another bug!
>
> Actually, I'm sorry -- clearly I wasn't paying attention before -- it is
> expected. The above means you can add two managed or two mesh interface,
> but no combinations of them. Basically, the things in if_comb are XOR,
> and the things inside each limit are AND.
>

thanks, then the updated http://p.sipsolutions.net/fedf39a8d08b28b7.txt
seems to solve the issue.

-- 
thanks,
shafi
