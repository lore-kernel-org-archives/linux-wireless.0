Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40587 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1KRRJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 12:09:49 -0500
Message-ID: <4EC69155.4060306@candelatech.com> (sfid-20111118_180953_087266_93FE2633)
Date: Fri, 18 Nov 2011 09:09:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mac80211:  Support ht-cap over-rides.
References: <1321566884-31757-1-git-send-email-greearb@candelatech.com>  <1321566884-31757-2-git-send-email-greearb@candelatech.com>  (sfid-20111117_225512_858995_688665F5) <1321611355.10266.30.camel@jlt3.sipsolutions.net>
In-Reply-To: <1321611355.10266.30.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2011 02:15 AM, Johannes Berg wrote:
> On Thu, 2011-11-17 at 13:54 -0800, greearb@candelatech.com wrote:
>
>> -void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
>> +bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
>> +{
>> +	const u16 flg = IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>> +	if ((sdata->u.mgd.ht_capa_mask.cap_info&  flg)&&
>> +	    !(sdata->u.mgd.ht_capa.cap_info&  flg))
>> +		return true;
>
> This looks like it has endian bugs. Note that sband->ht_cap is
> ieee80211_sta_ht_cap, whereas sdata->u.mgd.ht_capa[_mask] is
> ieee80211_ht_cap -- the latter is in IEEE format (LE) while the former
> is in a complete different format that's easier to digest for the
> CPU :-)

So, the ht-caps & mask data coming from user-space via netlink
should be in network-byte order?

Or do you want me to flip the bytes around when copying
it into the u.mgd.ht_cap structs?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

