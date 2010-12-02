Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65221 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab0LBFJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 00:09:22 -0500
Received: by wyb28 with SMTP id 28so7780605wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 21:09:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF6A8FD.6020508@candelatech.com>
References: <1291201205-1541-1-git-send-email-senthilkumar@atheros.com>
	<4CF6A8FD.6020508@candelatech.com>
Date: Thu, 2 Dec 2010 10:39:19 +0530
Message-ID: <AANLkTik7L-Ybcq6N=3daQefbycV3h9+=YtFV8_c3JW24@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ath9k: Fix STA disconnect issue due to received
 MIC failed bcast frames
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 1:28 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 12/01/2010 03:00 AM, Senthil Balasubramanian wrote:
>>
>> AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
>> this status for MIC failed frames is buggy.
>>
>> Due to this, MIC failure events for broadcast frames are not sent to
>> supplicant resulted in AP disconnecting the STA.
>>
>> Able to pass Wifi Test case 5.2.18 with this fix.
>
> Please do not apply this yet.  As far as I can tell, either
> of these patches breaks multiple VIF scenarios.  I'm not
> sure exactly why, but I had to revert this to get any
> of my interfaces to associate.

Ben can you please give some more information(or just point out some
link) regarding your test case,I can try it out.
thanks,
shafi
>
> I'm using software encryption in case that matters.
>
> Senthil:  Any chance you could test with a few VIFS to
> see if you see the same problem?
>
> Here is a dmesg snippet from wireless-testing with the v1 reverted
> and v2 applied:
>
> sta9: authenticate with 00:14:d1:c6:d2:54 (try 1)
> sta9: authenticated
> sta9: associate with 00:14:d1:c6:d2:54 (try 1)
> sta9: RX AssocResp from 00:14:d1:c6:d2:54 (capab=0x431 status=1 aid=0)
> sta9: 00:14:d1:c6:d2:54 denied association (code=1)
> sta9: deauthenticating from 00:14:d1:c6:d2:54 by local choice (reason=3)
> ieee80211 wiphy0: device now idle
> ieee80211 wiphy0: device no longer idle - scanning
> ieee80211 wiphy0: device now idle
> ieee80211 wiphy0: device no longer idle - working
> sta10: authenticate with 00:14:d1:c6:d2:54 (try 1)
> sta10: authenticated
> sta10: associate with 00:14:d1:c6:d2:54 (try 1)
> sta10: RX AssocResp from 00:14:d1:c6:d2:54 (capab=0x431 status=1 aid=0)
> sta10: 00:14:d1:c6:d2:54 denied association (code=1)
> sta10: deauthenticating from 00:14:d1:c6:d2:54 by local choice (reason=3)
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
