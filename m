Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49668 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab1KRUna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 15:43:30 -0500
Message-ID: <4EC6C36D.4070900@candelatech.com> (sfid-20111118_214333_674730_65FE944A)
Date: Fri, 18 Nov 2011 12:43:25 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v10 2/2] mac80211:  Support ht-cap over-rides.
References: <1321644720-8245-1-git-send-email-greearb@candelatech.com>  <1321644720-8245-2-git-send-email-greearb@candelatech.com>  (sfid-20111118_203218_329178_9FB3658A) <1321648257.10266.77.camel@jlt3.sipsolutions.net>
In-Reply-To: <1321648257.10266.77.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2011 12:30 PM, Johannes Berg wrote:
> On Fri, 2011-11-18 at 11:32 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This implements ht-cap over-rides for mac80211 drivers.
>> HT may be disabled, making an /a/b/g/n station act like an
>> a/b/g station.  HT40 may be disabled forcing the station to
>> be HT20 even if the AP and local hardware support HT40.
>>
>> MAX-AMSDU may be disabled.
>> AMPDU-Density may be increased.
>> AMPDU-Factor may be decreased.
>>
>> This has been successfully tested with ath9k using patched
>> wpa_supplicant and iw.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>>
>> v10:
>>   *  Add check in ieee80211_apply_htcap_overrides to make
>>      sure we are type NL80211_IFTYPE_STATION.
>>
>>   *  Memset u.mgd.ht_capa and ht_capa_mask to 0 in
>>      ieee80211_set_disassoc to make sure we do not try to
>>      use stale data.
>>
>>   *  Add cpu_to_le16 when dealing with u.mgd.ht_capa*
>>      Appears to make no change on x86, but should help
>>      with certain other platforms.
>>
>>   *  Addressed other issues brought up in review of v9.
>
> Thanks. I haven't tested it, but see no obvious bugs. :-)

Well, feels like progress!

If you actually want to enable/view the new features, you'll want
to patch hostap and iw.  You could use my trees if you want, though
they have some extra stuff and the ht-caps logic needs the cpu_to_le16
changes and probably a bit of other cleanup at the moment.

https://github.com/greearb/hostap-ct
https://github.com/greearb/iw-ct

I'll post some clean iw and hostap patches later today if all goes well.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

