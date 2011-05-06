Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60912 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab1EFQyd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 12:54:33 -0400
Message-ID: <4DC427C6.2080407@candelatech.com> (sfid-20110506_185444_680726_5662579A)
Date: Fri, 06 May 2011 09:54:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bisected:  ath9k: fix powersave frame filtering/buffering in
 AP mode broke STA association.
References: <4DC30C42.6070402@candelatech.com> <4DC3109F.6080601@openwrt.org> <4DC3135C.4040601@candelatech.com> <4DC31A0B.4040409@candelatech.com> <4DC31C91.1030303@openwrt.org> <4DC33DE2.1070508@candelatech.com> <4DC34465.6090108@openwrt.org> <4DC421D8.3050403@candelatech.com> <4DC42707.2080503@openwrt.org>
In-Reply-To: <4DC42707.2080503@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2011 09:51 AM, Felix Fietkau wrote:
> On 2011-05-06 6:29 PM, Ben Greear wrote:
>> On 05/05/2011 05:44 PM, Felix Fietkau wrote:
>>
>>>   This should fix the second issue:
>>>
>>>   --- a/drivers/net/wireless/ath/ath9k/main.c
>>>   +++ b/drivers/net/wireless/ath/ath9k/main.c
>>>   @@ -1722,6 +1722,10 @@ static int ath9k_sta_add(struct ieee8021
>>>     	struct ath_node *an = (struct ath_node *) sta->drv_priv;
>>>     	struct ieee80211_key_conf ps_key = { };
>>>
>>>   +	if (vif->opmode != NL80211_IFTYPE_AP&&
>>>   +	    vif->opmode != NL80211_IFTYPE_AP_VLAN)
>>>   +		return 0;
>>>   +
>>>     	ath_node_attach(sc, sta);
>>>     	an->ps_key = ath_key_config(common, vif, sta,&ps_key);
>>
>> This doesn't compile..appears there is no vif->opmode member?
>>
>> Also, if you are trying to compare the hardware opmode, I'm not
>> sure that would be correct since you can be in AP mode and still
>> have stations.  Maybe I'm just confused though...
> I sent the wrong version of the patch, forgot to refresh it.
> Here's the correct one:
>
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1722,6 +1722,10 @@ static int ath9k_sta_add(struct ieee8021
>   	struct ath_node *an = (struct ath_node *) sta->drv_priv;
>   	struct ieee80211_key_conf ps_key = { };
>
> +	if (vif->type != NL80211_IFTYPE_AP&&
> +	    vif->type != NL80211_IFTYPE_AP_VLAN)
> +		return 0;
> +
>   	ath_node_attach(sc, sta);
>   	an->ps_key = ath_key_config(common, vif, sta,&ps_key);
>

I think maybe you want that logic inserted below the ath_node_attach?

I tried it as you have it above, guessing that is what you meant, and
it crashed with null pointer exception....

Compiling with the logic below node_attach now...

Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

