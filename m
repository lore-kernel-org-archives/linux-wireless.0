Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59217 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab0LAUBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 15:01:24 -0500
Message-ID: <4CF6A8FD.6020508@candelatech.com>
Date: Wed, 01 Dec 2010 11:58:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Senthil Balasubramanian <senthilkumar@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Stable <stable@kernel.org>,
	Kyungwan Nam <Kyungwan.Nam@atheros.com>
Subject: Re: [PATCH v2 2/2] ath9k: Fix STA disconnect issue due to received
 MIC failed bcast frames
References: <1291201205-1541-1-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1291201205-1541-1-git-send-email-senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2010 03:00 AM, Senthil Balasubramanian wrote:
> AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
> this status for MIC failed frames is buggy.
>
> Due to this, MIC failure events for broadcast frames are not sent to
> supplicant resulted in AP disconnecting the STA.
>
> Able to pass Wifi Test case 5.2.18 with this fix.

Please do not apply this yet.  As far as I can tell, either
of these patches breaks multiple VIF scenarios.  I'm not
sure exactly why, but I had to revert this to get any
of my interfaces to associate.

I'm using software encryption in case that matters.

Senthil:  Any chance you could test with a few VIFS to
see if you see the same problem?

Here is a dmesg snippet from wireless-testing with the v1 reverted
and v2 applied:

sta9: authenticate with 00:14:d1:c6:d2:54 (try 1)
sta9: authenticated
sta9: associate with 00:14:d1:c6:d2:54 (try 1)
sta9: RX AssocResp from 00:14:d1:c6:d2:54 (capab=0x431 status=1 aid=0)
sta9: 00:14:d1:c6:d2:54 denied association (code=1)
sta9: deauthenticating from 00:14:d1:c6:d2:54 by local choice (reason=3)
ieee80211 wiphy0: device now idle
ieee80211 wiphy0: device no longer idle - scanning
ieee80211 wiphy0: device now idle
ieee80211 wiphy0: device no longer idle - working
sta10: authenticate with 00:14:d1:c6:d2:54 (try 1)
sta10: authenticated
sta10: associate with 00:14:d1:c6:d2:54 (try 1)
sta10: RX AssocResp from 00:14:d1:c6:d2:54 (capab=0x431 status=1 aid=0)
sta10: 00:14:d1:c6:d2:54 denied association (code=1)
sta10: deauthenticating from 00:14:d1:c6:d2:54 by local choice (reason=3)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

