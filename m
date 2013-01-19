Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8183 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3ASFJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2013 00:09:33 -0500
Message-ID: <50FA2A87.6000106@qca.qualcomm.com> (sfid-20130119_060942_021916_0B63A656)
Date: Sat, 19 Jan 2013 10:39:27 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V9 2/2] cfg80211/nl80211: Enable drivers to implement
 MAC address based ACL
References: <1358488125-6154-1-git-send-email-vthiagar@qca.qualcomm.com>  <1358488125-6154-2-git-send-email-vthiagar@qca.qualcomm.com> <1358544641.7922.28.camel@jlt4.sipsolutions.net>
In-Reply-To: <1358544641.7922.28.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Saturday 19 January 2013 03:00 AM, Johannes Berg wrote:
> On Fri, 2013-01-18 at 11:18 +0530, Vasanthakumar Thiagarajan wrote:
>
>> + * @NL80211_ATTR_ACL_POLICY: ACL policy, see&enum nl80211_acl_policy_attr.
>> + *
>> + * @NL80211_ATTR_MAC_ADDRS: Array of nested MAC addresses, used for
>> + *	MAC ACL.
>
> Ok so one last (not a promise ;-) ) thing ...
>
> You basically completely back-pedalled from wanting to support white&
> blacklist at the same time to no longer even allowing that in the API.
> Should I really merge this? Who says you're not going to return in a
> couple of weeks and want that then, making the API very strange?

The decision to have ACL only with a single list has been taken only
after a detailed (private) discussion with Jouni. I'm pretty much
convinced that this API is enough for ACL, everything else can be
handled in user space(wpa_s) like different types of notification to
application for stats purpose or user feedback.

>
>
> Anyway, if you think that the dual list approach is dead indefinitely, I
> guess I can apply it. I'm just not sure I believe that ;-)

As said above, I think this API + wpa_s changes are enough to do the
job of black & white list.

Vasanth
