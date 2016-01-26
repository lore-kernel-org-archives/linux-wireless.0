Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35913 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005AbcAZMet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 07:34:49 -0500
Subject: Re: [PATCH] cfg80211: basic support for PBSS network type
To: Johannes Berg <johannes@sipsolutions.net>
References: <56961335.4040801@codeaurora.org>
 <1453807346.2759.29.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Dedy Lansky <dlansky@codeaurora.org>,
	Maya Erez <merez@codeaurora.org>,
	Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
From: Lior David <liord@codeaurora.org>
Message-ID: <56A767E4.7090906@codeaurora.org> (sfid-20160126_133452_571001_97FA4A22)
Date: Tue, 26 Jan 2016 14:34:44 +0200
MIME-Version: 1.0
In-Reply-To: <1453807346.2759.29.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2016 1:22 PM, Johannes Berg wrote:
> On Wed, 2016-01-13 at 11:04 +0200, Lior David wrote:
>>  
>> + * @NL80211_ATTR_PBSS: flag attribute. If set it means operate
>> + *	in a PBSS. Specified in %NL80211_CMD_CONNECT to request
>> + *	connecting to a PCP, and in %NL80211_CMD_START_AP to start
>> + *	a PCP instead of AP. Relevant for DMG networks only.
> 
> I'm continually confused by this; is it possible for DMG devices to be
> a "real" AP rather than a PCP?
> 
Yes, DMG devices can function as a full AP in addition to PCP.

>> @@ -3461,6 +3462,8 @@  static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>>  			return PTR_ERR(params.acl);
>>  	}
>>  
>> +	params.pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
>> +
>>  	wdev_lock(wdev);
>>  	err = rdev_start_ap(rdev, dev, &params);
>>  	if (!err) {
> 
> This, and the corresponding code in nl80211_connect, really ought to
> check that the device is a DMG device and able to do this.
> 
> Perhaps this even needs a capability check, or do we assume that all
> devices/drivers will be able to do this (or should reject it?)
> 
Certified 11ad devices must support PBSS, but in theory you can have
11ad drivers that do not support it. 11ac devices cannot support
it and currently will just ignore this flag, so I think I will add a
feature flag (something like NL80211_EXT_FEATURE_PBSS) and return an
error if the driver does not support this feature.

> If you want to rely on drivers though you need to have (in this patch!)
> a small change to the existing driver to reject the operations if
> pbss==true since obviously it cannot be doing the right thing right now
> without further changes. That reject would then of course be removed
> again with the driver update.
I have a patch for the wil6210 driver that uses this feature. Do you prefer
that I add the wil6210 driver changes to this patch?

Thanks,
Lior
