Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4946 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2LaFT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2012 00:19:28 -0500
Message-ID: <50E12058.8070106@qca.qualcomm.com> (sfid-20121231_061933_197156_AF323B49)
Date: Mon, 31 Dec 2012 10:49:20 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V4 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
References: <1356690070-26612-1-git-send-email-vthiagar@qca.qualcomm.com>  <1356690070-26612-2-git-send-email-vthiagar@qca.qualcomm.com> <1356700150.9922.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1356700150.9922.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Friday 28 December 2012 06:39 PM, Johannes Berg wrote:
> On Fri, 2012-12-28 at 15:51 +0530, Vasanthakumar Thiagarajan wrote:
>
>> + * @acl_type: ACL policy that driver supports,
>> + *	see&enum nl80211_acl_policy_attr.
>
> That doesn't make a lot of sense, in particular not the way you use it.
> What if a driver supports a blacklist but not a whitelist? It seems that
> it should be a bitfield. Also setting a default that isn't "unsupported"
> is a bad idea.
>
>> +	NL80211_ATTR_ACL_POLICY,
>> +
>> +	NL80211_ATTR_MAC_ADDRS,
>> +
>> +	NL80211_ATTR_MAC_ACL_MAX,
>> +
>> +	NL80211_ATTR_ACL_TYPE,
>
>> +	if (WARN_ON((wiphy->acl_type<= NL80211_ACL_POLICY_MAX)&&
>
> So basically you could remove the acl_type field completely.
>
>
> I think maybe if you want to continue supporting the white-&  blacklist
> you should change it back to nested attributes, but treat the blacklist
> there as an optimisation and ignore it for feature advertising.

Ok, so we dont need any mechanism to advertise supporting acl types at 
all because any ACL supporting driver is supposed to support white
list?.

Vasanth
