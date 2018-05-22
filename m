Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:44449 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752713AbeEVVZO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 17:25:14 -0400
Received: by mail-ot0-f169.google.com with SMTP id g7-v6so22727234otj.11
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 14:25:14 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tim Kourt <tim.a.kourt@linux.intel.com>,
        linux-wireless@vger.kernel.org
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
 <1526631206.3805.1.camel@sipsolutions.net>
 <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
 <1527019967.6787.45.camel@sipsolutions.net>
 <114ca20b-7b20-7a3e-75bd-8c336d26b9c0@gmail.com>
 <1527021608.6787.47.camel@sipsolutions.net>
 <2036335b-ca8f-d63f-8142-11d81cfb9a22@gmail.com>
 <1527022332.6787.51.camel@sipsolutions.net>
 <D2E91785-58E3-46FA-94B9-879E621D5049@gmail.com>
 <1527023478.6787.60.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <c0b00a4c-f98e-6261-976b-d9c7ae708eee@gmail.com> (sfid-20180522_232518_657796_1C403783)
Date: Tue, 22 May 2018 16:25:11 -0500
MIME-Version: 1.0
In-Reply-To: <1527023478.6787.60.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> But in theory, I think you could've received the beacon with hidden SSID
> *before* the scan, yet it might be present in the scan results if the
> new scan caused the probe response to be associated with that scan.

Right, your explanation was helpful, thanks.  It still seems completely 
weird and redundant that we get two separate entries though.  The second 
entry with the probe response data still carries the beacon info (as you 
point out).  Should the pure-beacon one be filtered?

> 
>> I’m just curious what other potential uses this flag might have.
> 
> Well, basically, ensure that your scan data is up-to-date?
> 
> I think mostly it's because there are scenarios where the AP is expected
> to vary the probe response data, so you need to know if you
>   * have a new probe response, or
>   * didn't receive a new probe response, or
>   * the AP erroneously didn't change the new probe response.

Right, so thinking out loud here.  Would it be useful to tell GET SCAN 
to only return entries with actual probe response data?  Combined with 
the flush flag it seems like a much better fit for the cases you point out.

Regards,
-Denis
