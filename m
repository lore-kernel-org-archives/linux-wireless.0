Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55516 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab0LCORL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 09:17:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Dec 2010 06:16:57 -0800
Date: Fri, 3 Dec 2010 19:47:10 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath9k: Fix STA disconnect issue due to received
 MIC failed bcast frames
Message-ID: <20101203141710.GA3833@senthil-lnx.users.atheros.com>
References: <1291201205-1541-1-git-send-email-senthilkumar@atheros.com>
 <4CF6A8FD.6020508@candelatech.com>
 <AANLkTik7L-Ybcq6N=3daQefbycV3h9+=YtFV8_c3JW24@mail.gmail.com>
 <4CF73249.3040203@candelatech.com>
 <AANLkTinrQYN3_GpbfR=4xcJQ-moa32+QJtVorqq6xgR4@mail.gmail.com>
 <4CF8A49C.2000401@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CF8A49C.2000401@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 03, 2010 at 01:34:44PM +0530, Ben Greear wrote:
> On 12/01/2010 11:16 PM, Mohammed Shafi wrote:
> > On Thu, Dec 2, 2010 at 11:14 AM, Ben Greear<greearb@candelatech.com>  wrote:
> >> On 12/01/2010 09:09 PM, Mohammed Shafi wrote:
> >>>
> >>> On Thu, Dec 2, 2010 at 1:28 AM, Ben Greear<greearb@candelatech.com>
> >>>   wrote:
> >>>>
> >>>> On 12/01/2010 03:00 AM, Senthil Balasubramanian wrote:
> >>>>>
> >>>>> AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
> >>>>> this status for MIC failed frames is buggy.
> >>>>>
> >>>>> Due to this, MIC failure events for broadcast frames are not sent to
> >>>>> supplicant resulted in AP disconnecting the STA.
> >>>>>
> >>>>> Able to pass Wifi Test case 5.2.18 with this fix.
> >>>>
> >>>> Please do not apply this yet.  As far as I can tell, either
> >>>> of these patches breaks multiple VIF scenarios.  I'm not
> >>>> sure exactly why, but I had to revert this to get any
> >>>> of my interfaces to associate.
> >>>
> >>> Ben can you please give some more information(or just point out some
> >>> link) regarding your test case,I can try it out.
> >>> thanks,
> >>> shafi
> >>
> >> Try this script, or something like it:
> >>
> >> http://www.spinics.net/lists/linux-wireless/msg60126.html
> >>
> >> Edit 'max' to create a small number of STA interfaces or you will probably
> >> have
> >> worse issues than them just not associating!
> >>
> >> You have to enable the nohwcrypt module option.
> >>
> >> Let me know if that doesn't work and I can probably put together something
> >> more specific.
> >
> > thanks Ben.
> 
> Were you able to reproduce the problem?

I can reproduce this issue with single vif itself and with s/w crypt enabled.

Can you please apply the v2 patch and try the following change on top of it in 

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6c0c796..4871849 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1069,7 +1069,7 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,

        keyix = rx_stats->rs_keyix;

-       if ((is_mc || !(keyix == ATH9K_RXKEYIX_INVALID)) && !decrypt_error &&
+       if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error &&
            ieee80211_has_protected(fc)) {
                rxs->flag |= RX_FLAG_DECRYPTED;
        } else if (ieee80211_has_protected(fc)

I haven't tested s/w crypto and this check causes mac80211 not to decrypt frames so it
would have caused issues.. Can you please check this out? It wouldn't cause issues with
h/w crypt. Please let me know whether it solves your issue.. It works for me.

> 
> Thanks,
> Ben
> 
> >
> >>
> >> Thanks,
> >> Ben
> >>
> >> --
> >> Ben Greear<greearb@candelatech.com>
> >> Candela Technologies Inc  http://www.candelatech.com
> >>
> 
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
