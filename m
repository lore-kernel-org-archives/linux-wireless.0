Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56142 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731Ab1KBQhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 12:37:48 -0400
Message-ID: <4EB171D8.4080506@candelatech.com> (sfid-20111102_173751_364286_3F0FEF85)
Date: Wed, 02 Nov 2011 09:37:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>  <4EAAD734.10501@candelatech.com> (sfid-20111028_182428_876939_0D798225) <1320220577.3950.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320220577.3950.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2011 12:56 AM, Johannes Berg wrote:
> On Fri, 2011-10-28 at 09:24 -0700, Ben Greear wrote:
>
>>>> +++ b/net/mac80211/cfg.c
>>>> @@ -57,6 +57,9 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
>>>>    	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>>>>    	int ret;
>>>>
>>>> +	if (params->disable_11n != -1)
>>>> +		sdata->cfg_disable_11n = params->disable_11n;
>>>
>>> This doesn't seem right -- why change the iface for it? It's a per
>>> connection parameter.
>>
>> I wanted it to be an interface parameter, or at least I think
>> that is what I want.
>
> Why? I'm thinking that it's better as a connection parameter as then
> it's more temporal. I know we have interface parameters like RTS/CTS
> settings etc, but I like connection parameters better as they go away
> with each new connection, so the behaviour is less surprising to most
> users. Imagine your wpa_supplicant crashes, and then the user who was
> restricting it to no-HT starts the regular wpa_supplicant; now his
> interface will be in no-HT until he reboots or figures out the right
> magic to change it. I think that kind of situation is undesirable.

Ok, I will try to figure out how to do this as part of connection.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

