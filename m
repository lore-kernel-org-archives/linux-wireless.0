Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:6929 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2LLLIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 06:08:07 -0500
Message-ID: <50C8657F.60606@qca.qualcomm.com> (sfid-20121212_120812_094437_9AEEB844)
Date: Wed, 12 Dec 2012 16:37:43 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Antonio Quartulli <ordex@autistici.org>
CC: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
References: <1354880763-12309-1-git-send-email-vthiagar@qca.qualcomm.com> <1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com> <20121212101415.GH3458@ritirata.org>
In-Reply-To: <20121212101415.GH3458@ritirata.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wednesday 12 December 2012 03:44 PM, Antonio Quartulli wrote:
> Hello Vasanthakumar,
>
> On Fri, Dec 07, 2012 at 05:16:03PM +0530, Vasanthakumar Thiagarajan wrote:
>> This patch enables drivers to implement mac address based
>> access control in AP/P2P GO mode. There is a new flag in
>> nl80211_ap_sme_features (NL80211_AP_SME_FEATURE_MAC_ACL)
>> for drivers to advertise this capability. There are two acl
>> policies, white and black list under which an acl list can
>> be configured in the driver. Driver has to advertise the
>> maximum number of mac address entries in acl list through
>> max_acl_mac_addrs of wiphy.
>>
>> Driver can enable its ACL either with the initial list passed
>> through NL80211_CMD_START_AP or a list passed through
>> NL80211_CMD_SET_MAC_ACL. ACL information passed in these
>> commands is an array of acl configuration containing acl
>> policy and list of mac address. With the acl policy as
>> NL80211_ACL_POLICY_ACCEPT, driver will accept Auth request
>> from any client matching any one of the mac addresses in the acl list.
>> When acl policy is NL80211_ACL_POLICY_DENY, driver will reject any
>> Auth request from the clients having their mac address listed in the
>> acl list. Driver must make sure to clear it's acl list when doing
>> stop ap.
>>
>
> I'm curious about this feature: at the moment mac ACL is implemented and working
> in hostapd. What would the advantage of implementing this in the driver?
> I don't think this can be offloaded on the device, so the advantage is that this
> would move the ACL mechanism from the user to the kernel-space? Or am I missing
> something else?

This is mainly for the devices which have the AP SME in fw like ath6kl.
So that the auth request will be dropped after checking the acl instead
instead of doing it in hostapd where it could be done only after
the connection with the station goes through successfully.

Vasanth
