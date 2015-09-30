Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55813 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbbI3PHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 11:07:42 -0400
Message-ID: <560BFABC.8090504@candelatech.com> (sfid-20150930_170745_452777_A4F1D69B)
Date: Wed, 30 Sep 2015 08:07:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: Can we ignore frames with invalid BSSID in IBSS mode?
References: <5605D228.7050609@candelatech.com> (sfid-20150926_010105_789618_F93D668E) <1443595615.1859.2.camel@sipsolutions.net>
In-Reply-To: <1443595615.1859.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/29/2015 11:46 PM, Johannes Berg wrote:
> On Fri, 2015-09-25 at 16:00 -0700, Ben Greear wrote:
>> It seems that ath10k ar988X hardware has a bug where the BSSID
>> for IBSS AMSDU frames is all zeros.  The 'main' 636 ath10k firmware
>> does not seem to use AMSDUs for IBSS, and when I enable it in my CT
>> firmware, then I see the breakage.  So, I suspect it is not
>> just a simple software/firmware bug.
>>
>> If I simply ignore the bssid_match check in ieee80211_accept_frame,
>> then it seems everything runs fine.
>>
>> So, I'm curious if anyone knows what sorts of bad things could happen
>> if the bssid_match check is ignored?  Maybe bcast/mcast frames could
>> be accepted when they shouldn't be in certain cases?
>>
>
> You could end up accepting multicast frames from a different,
> overlapping, BSS? Seems like a bad idea.

It's definitely not a great idea.

In my testing, I always see the first frame of the AMPDU have
a proper IBSS BSSID.  Any idea if it would be OK (and even possible)
for the driver or stack to detect this and save the BSSID aside
for the subsequent frames?

Its not clear to me whether the rest of the AMPDU frames could
somehow be interleaved with frames from a different BSSID?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
