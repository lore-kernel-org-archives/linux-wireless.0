Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4901 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3AUJye (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 04:54:34 -0500
Message-ID: <50FD104F.2090006@broadcom.com> (sfid-20130121_105438_269012_467591E1)
Date: Mon, 21 Jan 2013 10:54:23 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>, "Greg Goldman" <ggoldman@broadcom.com>,
	"Jithu Jance" <jithu@broadcom.com>
Subject: Re: [PATCH] nl80211: allow user-space to determine address for
 P2P_DEVICE
References: <1357636648-4012-1-git-send-email-arend@broadcom.com>
 <1358374672.15012.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1358374672.15012.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/16/2013 11:17 PM, Johannes Berg wrote:
> On Tue, 2013-01-08 at 10:17 +0100, Arend van Spriel wrote:
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -2079,6 +2079,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>>  	    !(rdev->wiphy.interface_modes & (1 << type)))
>>  		return -EOPNOTSUPP;
>>  
>> +	if (type == NL80211_IFTYPE_P2P_DEVICE && info->attrs[NL80211_ATTR_MAC])
>> +		nla_memcpy(&params.macaddr[0], info->attrs[NL80211_ATTR_MAC],
>> +			   ETH_ALEN);
> 
> It seems like this might need a capability parameter or something, so
> wpa_s knows this will take effect. OTOH, wpa_s can query the MAC address
> afterwards, so it's not really needed, so I applied it.

Not sure if I can follow. I did submit wpa_s patch for flagging the P2P
device capability. Are you suggesting an additional flag here to
indicate whether the MAC address can be configured by wpa_s?

> (I changed the subject to say "configure", "determine" seems a bit vague
> to me, the way I read it it could possibly also mean "allow to get" it)

Potaitoe, Patatoe, fine by me ;-)

> I would also like to see a mac80211 change though to make it take effect
> there.

See what I can do. I guess it does involve mac80211 device drivers as
well, right?

Gr. AvS

> johannes
> 
> 


