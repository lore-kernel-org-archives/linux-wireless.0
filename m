Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3318 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762307Ab3ECOVS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 10:21:18 -0400
Message-ID: <5183C7D3.80405@broadcom.com> (sfid-20130503_162121_822190_4F188B6B)
Date: Fri, 3 May 2013 16:21:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: m.fitzjohn@samsung.com, linux-wireless@vger.kernel.org
Subject: Re: Does mac80211 support use of WIPHY_FLAG_SUPPORTS_FW_ROAM?
References: <006d01ce47fc$76a61690$63f243b0$%fitzjohn@samsung.com> (
 sfid-20130503_144817_713432_206EE938)
 <1367585797.13104.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1367585797.13104.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2013 02:56 PM, Johannes Berg wrote:
> Hi,
>
> The short answer to your question is: no.
>
>> I know that we need to set the WIPHY_FLAG_SUPPORTS_FW_ROAMING but I'm not
>> sure if anything else needs to be signalled (called) in to mac80211?
>>
>> I've seen calls to cfg80211_roamed_bss which gets the roamed indication out
>> to the user space but do we need to use this as well?
>>
>> Can anyone explain?
>
> The longer answer is that mac80211 doesn't use the connect API, it
> implements the MLME itself. Roaming in firmware isn't just that, it's
> much much more complex. Think of the AP station entry getting updated
> (mac80211 would have to do this!), the new QoS/WMM parameters,
> BSSID, ...
>
> If you have roaming in your firmware, then you must have the MLME in the
> firmware as well. Then, why are you using mac80211? Clearly not for the
> MLME, but then what for instead? Maybe what you really want instead is
> to do some (really really big!) refactoring on the datapath?

More general, a while ago we have been looking at mac80211 offloads to 
see whether the brcmfmac driver could be (effectively) converted to a 
mac80211 driver. The only possible conclusion was that a device with 
MLME in firmware should have a cfg80211 based driver, but maybe some 
daredevil would feel challenged to implement MLME firmware-offloading in 
mac80211, but that is probably a 'really really big' task :-)

Regards,
Arend

