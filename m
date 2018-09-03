Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:32912 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbeICQHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 12:07:20 -0400
Message-ID: <1535975240.3437.61.camel@sipsolutions.net> (sfid-20180903_134735_886484_95FC4B57)
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi
 chips
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Grant Grundler <grundler@google.com>, wgong@qti.qualcomm.com
Cc: wgong@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Date: Mon, 03 Sep 2018 13:47:20 +0200
In-Reply-To: <87in3m25uu.fsf@toke.dk>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
         <1533724802-30944-3-git-send-email-wgong@codeaurora.org>
         <87sh3pdtpg.fsf@toke.dk>
         <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
         <87mutue4y8.fsf@toke.dk>
         <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com>
         <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com>
         <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-03 at 13:11 +0200, Toke Høiland-Jørgensen wrote:

> > 6 vs. 8, I think? But I didn't follow the full discussion.

Err, I just realized that I was completely wrong - the default, of
course, is 10. So smaller values mean more buffering.

Most of my argumentation was thus utter garbage :-)

> > I also think that we shouldn't necessarily restrict this to "for the
> > ath10k". Is there any reason to think that this would be different for
> > different chips?
> 
> No, I also think it should be possible to select a value that will work
> for all drivers. There's a strong diminishing returns effect here after
> a certain point, and I believe we should strongly push back against just
> adding more buffering to chase (single-flow) throughput numbers; and I'm
> not convinced that having different values for different drivers is
> worth the complexity.

I think I can see some point in it if the driver requires some buffering
for some specific reason? But you'd have to be able to state that
reason, I guess, I could imagine having a firmware limitation to need to
build two aggregates, or something around MU-MIMO, etc.

> As far as I'm concerned, just showing an increase in maximum throughput
> under ideal conditions (as this initial patch submission did) is not
> sufficient argument for adding more buffering. At a minimum, the
> evaluation should also include:
> 
> - Impact on latency and throughput for competing flows in the same test.
> - Impact on latency for the TCP flow itself.
> - A full evaluation at low rates and in scenarios with more than one
>   client.

That seems reasonable.

> As far as the actual value, I *think* it may be that the default shift
> should be 7 (8 ms) rather than 8 (4 ms) as it currently is. Going back
> and looking at my data from when I submitted the original patch, it
> looks like the point of diminishing returns is somewhere between those
> two with ath9k (where I did most of my testing), and it seems reasonable
> that it could be slightly higher (i.e., more buffering) for ath10k.

Grant's data shows a significant difference between 6 and 7 for both
latency and throughput:

 * median tpt
   - ~241 vs ~201 (both 1 and 5 streams)
 * median latency
   - 7.5 vs 6 (1 stream)
   - 17.3 vs. 16.6 (5 streams)

A 20% throughput improvement at <= 1.5ms latency cost seems like a
pretty reasonable trade-off?

johannes
