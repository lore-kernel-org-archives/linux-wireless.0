Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50187 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2LMEwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 23:52:51 -0500
Message-ID: <50C95F06.9090702@qca.qualcomm.com> (sfid-20121213_055255_730022_18230678)
Date: Thu, 13 Dec 2012 10:22:22 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
References: <1354880763-12309-1-git-send-email-vthiagar@qca.qualcomm.com>   <1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com>  <1355255841.9819.18.camel@jlt4.sipsolutions.net>  <50C81331.9080304@qca.qualcomm.com> <1355311595.9708.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355311595.9708.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wednesday 12 December 2012 04:56 PM, Johannes Berg wrote:
> On Wed, 2012-12-12 at 10:46 +0530, Vasanthakumar Thiagarajan wrote:
>>
>> On Wednesday 12 December 2012 01:27 AM, Johannes Berg wrote:
>>> On Fri, 2012-12-07 at 17:16 +0530, Vasanthakumar Thiagarajan wrote:
>>>> This patch enables drivers to implement mac address based
>>>> access control in AP/P2P GO mode. There is a new flag in
>>>> nl80211_ap_sme_features (NL80211_AP_SME_FEATURE_MAC_ACL)
>>>> for drivers to advertise this capability. There are two acl
>>>> policies, white and black list under which an acl list can
>>>> be configured in the driver. Driver has to advertise the
>>>> maximum number of mac address entries in acl list through
>>>> max_acl_mac_addrs of wiphy.
>>>>
>>>> Driver can enable its ACL either with the initial list passed
>>>> through NL80211_CMD_START_AP or a list passed through
>>>> NL80211_CMD_SET_MAC_ACL. ACL information passed in these
>>>> commands is an array of acl configuration containing acl
>>>> policy and list of mac address. With the acl policy as
>>>> NL80211_ACL_POLICY_ACCEPT, driver will accept Auth request
>>>> from any client matching any one of the mac addresses in the acl list.
>>>> When acl policy is NL80211_ACL_POLICY_DENY, driver will reject any
>>>> Auth request from the clients having their mac address listed in the
>>>> acl list. Driver must make sure to clear it's acl list when doing
>>>> stop ap.
>>>
>>> It seems easy to imagine a device that supports only a blacklist or
>>> whitelist, not both combined? What's the point of that anyway?
>>
>> No, the assumption is driver can support both the lists, but a
>> particular mac address can not be part of both the lists.
>> List of mac address for both the lists can be sent in
>> NL80211_CMD_START_AP and NL80211_CMD_SET_MAC_ACL.
>
> Yeah but I don't think that's a valid general assumption, and with the
> feature advertising API that you came up with, the driver can't
> advertise that it supports both at the same time etc.

Sure, seems like needs to be supported acl policy flags for the
driver to advertise.

>
> Also, in fact, I think there needs to be more justification for why you
> need two lists to start with  -- it seems to me that a white- and
> blacklist doesn't make sense at all, unless it's not really a white- and
> blacklist but one of
>   1) a blacklist
>   2) a whitelist + a "do not notify" list

Here the white and black list are real white and black list.
The mac address listed under white list are allowed to connect
while the ones available on black are blocked unconditionally
from connection. If a station's mac is part of neither of the lists,
that needs to be notified which is missing now. It is not very clear
to me about how the notification needs to be done, is it through
NL80211_ATTR_CONN_FAILED_REASON in NL80211_CMD_CONN_FAILED or
there needs to be new command/attr?.

>
> So there may be your feature advertising paradigm. Think of other
> devices, don't restrict yourself to ath6kl.

You mean there needs to be mechanism for drivers to advertise the
support these various acl policy as mentioned above?.

Vasanth
