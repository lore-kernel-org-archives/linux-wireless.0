Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41239 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab1ANSQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 13:16:45 -0500
Message-ID: <4D309307.6040806@candelatech.com>
Date: Fri, 14 Jan 2011 10:16:39 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [ath9k-devel] [RFC 1/2] ath9k: Fix up hardware mode and beacons
 with multiple vifs.
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com> <4D309086.7070703@openwrt.org>
In-Reply-To: <4D309086.7070703@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2011 10:05 AM, Felix Fietkau wrote:
> On 2011-01-14 6:27 PM, greearb@candelatech.com wrote:

>> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h
>> b/drivers/net/wireless/ath/ath9k/ath9k.h
>> index 3108699..a2da259 100644
>> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>> @@ -607,10 +607,15 @@ struct ath_softc {
>> u32 sc_flags; /* SC_OP_* */
>> u16 ps_flags; /* PS_* */
>> u16 curtxpow;
>> - u8 nbcnvifs;
>> - u16 nvifs;
>> bool ps_enabled;
>> bool ps_idle;
>> + short nbcnvifs;
>> + short nvifs;
>> + short naps; /* number of APs */
>> + short nmeshes;
>> + short nstations;
>> + short nwds;
>> + short nadhocs;
>> unsigned long ps_usecount;
>>
>> struct ath_config config;
> Do we really need all those counters? Wouldn't it be better to iterate
> over active interfaces instead?

Well, I like the counters.  If they ever do not match
expected results, it will be a clue that we have bugs
in our setup/teardown/change logic.

Seems we use counters like this for ath5k with good
results, btw.

>> if (!ieee80211_is_beacon(fc) ||
>> - compare_ether_addr(hdr->addr3, common->curbssid))
>> + compare_ether_addr(hdr->addr3, common->curbssid)) {
>> + /* TODO: This doesn't work well if you have stations
>> + * associated to two different APs because curbssid
>> + * is just the last AP that any of the stations associated
>> + * with.
>> + */
>> return;
>> + }
>>
>> if (rx_stats->rs_rssi != ATH9K_RSSI_BAD&& !rx_stats->rs_moreaggr)
>> ATH_RSSI_LPF(aphy->last_rssi, rx_stats->rs_rssi);
> Checking for the STA opmode is correct, this code should not be used for
> STA+AP. For the multi-STA case, it may make sense to process the RSSI
> average per vif and using the minimum for ANI.

Ok.  I'll leave that alone for now.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

