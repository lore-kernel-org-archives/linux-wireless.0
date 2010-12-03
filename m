Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:45078 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab0LCIo6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 03:44:58 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 00:44:44 -0800
Date: Fri, 3 Dec 2010 14:14:57 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stable <stable@kernel.org>,
	Kyungwan Nam <Kyungwan.Nam@Atheros.com>
Subject: Re: [PATCH v2 2/2] ath9k: Fix STA disconnect issue due to received
 MIC failed bcast frames
Message-ID: <20101203084457.GB4605@senthil-lnx.users.atheros.com>
References: <1291201205-1541-1-git-send-email-senthilkumar@atheros.com>
 <4CF6A8FD.6020508@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CF6A8FD.6020508@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 02, 2010 at 01:28:53AM +0530, Ben Greear wrote:
> On 12/01/2010 03:00 AM, Senthil Balasubramanian wrote:
> > AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
> > this status for MIC failed frames is buggy.
> >
> > Due to this, MIC failure events for broadcast frames are not sent to
> > supplicant resulted in AP disconnecting the STA.
> >
> > Able to pass Wifi Test case 5.2.18 with this fix.
> 
> Please do not apply this yet.  As far as I can tell, either
> of these patches breaks multiple VIF scenarios.  I'm not
> sure exactly why, but I had to revert this to get any
> of my interfaces to associate.
> 
> I'm using software encryption in case that matters.

Are you saying that you have issues with this patch (either v1 or v2)
and only when software encryption is used ??? Please confirm.

This patch fixes a regression which was introduced in 2.6.36 kernel. so
essentially what this patch does is nothing but what was happening in
2.6.35 kernel and below. It should not create any new issues from what
I can see. Anyway let us enable s/w encryption also and verify.

> 
> Senthil:  Any chance you could test with a few VIFS to
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
> Candela Technologies Inc  http://www.candelatech.com
> 
