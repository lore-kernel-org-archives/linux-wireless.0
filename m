Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54652 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0IWN42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 09:56:28 -0400
Message-ID: <4C9B5C83.4000407@candelatech.com>
Date: Thu, 23 Sep 2010 06:56:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Felix Fietkau <nbd@openwrt.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org>	 <4C98A022.7020106@candelatech.com> <4C98A2C4.8060108@openwrt.org>	 <4C98EAA1.7050908@candelatech.com>  <4C98F2D8.8020602@openwrt.org>	 <1285097307.12764.11.camel@jlt3.sipsolutions.net>	 <4C990859.70709@openwrt.org> <4C99135A.3090103@candelatech.com>	 <4C99348F.2090504@openwrt.org> <4C99870C.20006@candelatech.com>	 <4C99BEFC.2060209@openwrt.org>  <4C9ADE7E.5070406@candelatech.com> <1285230831.3691.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285230831.3691.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2010 01:33 AM, Johannes Berg wrote:
> On Wed, 2010-09-22 at 21:58 -0700, Ben Greear wrote:
>
>
>> + * @addr2: local address (vif->sdata->dev->dev_addr).  Can be NULL for 'any'.
>>     *
>>     * This function must be called under RCU lock and the
>>     * resulting pointer is only valid under RCU lock as well.
>> @@ -2434,7 +2435,8 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
>>     * DO NOT USE THIS FUNCTION.
>>     */
>>    struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
>> -                                              const u8 *addr);
>> +                                              const u8 *addr,
>> +                                              const u8 *localaddr);
>
> That's not going to generate proper documentation. Also, it now probably
> shouldn't be called "by_hw" any more.

I can't think of a better name, and it still does take the hw struct,
but if you have a suggestion you like better, I will use it.

I re-posted with the rest of the changes you suggested.  Seems to
be working fine.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
