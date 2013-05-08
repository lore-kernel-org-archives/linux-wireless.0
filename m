Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33830 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3EHSpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 14:45:40 -0400
Message-ID: <518A9D4C.10502@candelatech.com> (sfid-20130508_204543_694409_DC86DFF8)
Date: Wed, 08 May 2013 11:45:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 warning in 3.9.0+ when unloading ath9k driver.
References: <518A8DB1.7080904@candelatech.com>  (sfid-20130508_193902_610347_FF7CDB2D) <1368036259.8279.26.camel@jlt4.sipsolutions.net>
In-Reply-To: <1368036259.8279.26.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2013 11:04 AM, Johannes Berg wrote:
> On Wed, 2013-05-08 at 10:38 -0700, Ben Greear wrote:
>> I saw the WARN_ON_ONCE hit below on 3.9.0+ (+ hacks)
>> on a system with ath9k and ath9k_htc driver.
>
> Were you using VLANs?

No.

>
>> I'll be happy to add more debugging if someone has suggestions.
>
>> 		compat = cfg80211_chandef_compatible(
>> 				&sdata->vif.bss_conf.chandef, compat);
>> 		if (!compat)
>> 			break;
>> 	}
>> 	rcu_read_unlock();
>>
>> 	if (WARN_ON_ONCE(!compat))
>> 		return;
>
> Might be helpful to know whether chandef_compatible() returned NULL, or
> if the loop simply never found an interface with a matching pointer.

Ok, I'll add this.

Probably un-related, but the system usually crashes shortly after.  With
memory debugging enabled, it appears to be relayfs and/or ath9k accessing
freed memory.

I'm digging into that one first on an un-hacked kernel..then will
get back to this warning...

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

