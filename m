Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46201 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaJAUUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 16:20:15 -0400
Message-ID: <542C61FE.3060109@candelatech.com> (sfid-20141001_222020_195912_1EAB582C)
Date: Wed, 01 Oct 2014 13:20:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless:  support configuring vdev mac addr on create.
References: <1412186247-20303-1-git-send-email-greearb@candelatech.com> <542C5C69.9090608@broadcom.com>
In-Reply-To: <542C5C69.9090608@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2014 12:56 PM, Arend van Spriel wrote:

>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 8a010bd..cf79707 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -2605,7 +2605,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>>  	    !(rdev->wiphy.interface_modes & (1 << type)))
>>  		return -EOPNOTSUPP;
>>  
>> -	if (type == NL80211_IFTYPE_P2P_DEVICE && info->attrs[NL80211_ATTR_MAC]) {
>> +	if (info->attrs[NL80211_ATTR_MAC]) {
>>  		nla_memcpy(params.macaddr, info->attrs[NL80211_ATTR_MAC],
>>  			   ETH_ALEN);
>>  		if (!is_valid_ether_addr(params.macaddr))
> 
> Hi Ben,
> 
> Just noticed this last line and realized that my comment on the previous
> patch is invalid. nl80211.c already validates the mac address received
> from iw. The zero address check in ieee80211_if_add() is to determine
> whether iw provided a mac address or not.

Well, I guess either way is fine with me.  Might be nice to apply v2
just in case that code is ever called by something that is not validating
the address.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

