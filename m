Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60825 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbeICRzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 13:55:25 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Grant Grundler <grundler@google.com>, wgong@qti.qualcomm.com
Cc: wgong@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <1535975240.3437.61.camel@sipsolutions.net>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk> <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com> <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com> <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com> <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk> <1535975240.3437.61.camel@sipsolutions.net>
Date: Mon, 03 Sep 2018 15:35:11 +0200
Message-ID: <878t4i1z74.fsf@toke.dk> (sfid-20180903_153519_172012_BA3B8E6B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2018-09-03 at 13:11 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> > 6 vs. 8, I think? But I didn't follow the full discussion.
>
> Err, I just realized that I was completely wrong - the default, of
> course, is 10. So smaller values mean more buffering.
>
> Most of my argumentation was thus utter garbage :-)

Well, I got the gist, even if the sign bit was wrong ;)

>> > I also think that we shouldn't necessarily restrict this to "for the
>> > ath10k". Is there any reason to think that this would be different for
>> > different chips?
>>=20
>> No, I also think it should be possible to select a value that will work
>> for all drivers. There's a strong diminishing returns effect here after
>> a certain point, and I believe we should strongly push back against just
>> adding more buffering to chase (single-flow) throughput numbers; and I'm
>> not convinced that having different values for different drivers is
>> worth the complexity.
>
> I think I can see some point in it if the driver requires some
> buffering for some specific reason? But you'd have to be able to state
> that reason, I guess, I could imagine having a firmware limitation to
> need to build two aggregates, or something around MU-MIMO, etc.

Right, I'm not ruling out that there can be legitimate reasons to add
extra buffering; but a lot of times it's just used to paper over other
issues, so a good explanation is definitely needed...

>> As far as the actual value, I *think* it may be that the default shift
>> should be 7 (8 ms) rather than 8 (4 ms) as it currently is. Going back
>> and looking at my data from when I submitted the original patch, it
>> looks like the point of diminishing returns is somewhere between those
>> two with ath9k (where I did most of my testing), and it seems reasonable
>> that it could be slightly higher (i.e., more buffering) for ath10k.
>
> Grant's data shows a significant difference between 6 and 7 for both
> latency and throughput:
>
>  * median tpt
>    - ~241 vs ~201 (both 1 and 5 streams)
>  * median latency
>    - 7.5 vs 6 (1 stream)
>    - 17.3 vs. 16.6 (5 streams)
>
> A 20% throughput improvement at <=3D 1.5ms latency cost seems like a
> pretty reasonable trade-off?

Yeah, on it's face. What I'm bothered about is that it is the exact
opposite results that I got from my ath10k tests (there, throughput
*dropped* and latency doubled when going to from 4 to 16 ms of
buffering). And, well, Grant's data is from a single test in a noisy
environment where the timeseries graph shows that throughput is all over
the place for the duration of the test; so it's hard to draw solid
conclusions from (for instance, for the 5-stream test, the average
throughput for 6 is 331 and 379 Mbps for the two repetitions, and for 7
it's 326 and 371 Mbps) . Unfortunately I don't have the same hardware
used in this test, so I can't go verify it myself; so the only thing I
can do is grumble about it here... :)

-Toke
