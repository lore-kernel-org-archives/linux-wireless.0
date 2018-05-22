Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:46499 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752764AbeEVUti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 16:49:38 -0400
Received: by mail-ot0-f195.google.com with SMTP id t1-v6so22585185ott.13
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 13:49:38 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
To: Johannes Berg <johannes@sipsolutions.net>,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
 <1526631206.3805.1.camel@sipsolutions.net>
 <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
 <1527019967.6787.45.camel@sipsolutions.net>
 <114ca20b-7b20-7a3e-75bd-8c336d26b9c0@gmail.com>
 <1527021608.6787.47.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <2036335b-ca8f-d63f-8142-11d81cfb9a22@gmail.com> (sfid-20180522_224942_527955_394100FA)
Date: Tue, 22 May 2018 15:49:35 -0500
MIME-Version: 1.0
In-Reply-To: <1527021608.6787.47.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 05/22/2018 03:40 PM, Johannes Berg wrote:
> Hi,
> 
>> So I need to absorb all of this some more, but I'm still wondering why
>> we are seeing two separate scan entries (with hidden & plain ssid) when
>> we requested a flush?  Is there a way to force the kernel to only show
>> us the probe responses.
> 
> Oh. I didn't even think about this part, but that's just a consequence
> of having a hidden SSID. We need one entry to track the beacon, and then
> we add another entry for each hidden SSID it may have. Some APs
> implement multiple SSIDs that way (old Cisco equipment, IIRC, though
> then with zero-length SSID instead of zero-bytes), so you can't lump
> them together into a single BSS entry.
> 
>> It would seem that even with the flush flag set, there could still be
>> spurious beacons getting in causing these results to appear in the scan
>> result set, right?
> 
> In general anything can, there's no filtering. So you might do a flush
> scan for a specific SSID and still get 20 (different) results, if 20
> beacons happened to be received while you were scanning.
> 

Okay, so we need to use NL80211_BSS_PRESP_DATA if we want to filter out 
scan results that are coming from beacons, right?

So what's the practical use of the flush flag?  Or is that something 
that was meant to be 'for-testing-only'?

Regards,
-Denis
