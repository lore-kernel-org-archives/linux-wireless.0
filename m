Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36190 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbeIEEKl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 00:10:41 -0400
Received: by mail-it0-f68.google.com with SMTP id u13-v6so7170027iti.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2018 16:43:17 -0700 (PDT)
MIME-Version: 1.0
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
 <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk>
 <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
 <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com>
 <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com>
 <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk>
 <1535975240.3437.61.camel@sipsolutions.net> <878t4i1z74.fsf@toke.dk>
In-Reply-To: <878t4i1z74.fsf@toke.dk>
From: Grant Grundler <grundler@google.com>
Date: Tue, 4 Sep 2018 16:43:04 -0700
Message-ID: <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com> (sfid-20180905_014320_692319_25EF0CB1)
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
To: toke@toke.dk
Cc: Johannes Berg <johannes@sipsolutions.net>, wgong@qti.qualcomm.com,
        wgong@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 3, 2018 at 6:35 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.=
dk> wrote:
>
> Johannes Berg <johannes@sipsolutions.net> writes:
....
> > Grant's data shows a significant difference between 6 and 7 for both
> > latency and throughput:

Minor nit: this is wgong's data more thoughtfully processed.

> >
> >  * median tpt
> >    - ~241 vs ~201 (both 1 and 5 streams)
> >  * median latency
> >    - 7.5 vs 6 (1 stream)
> >    - 17.3 vs. 16.6 (5 streams)
> >
> > A 20% throughput improvement at <=3D 1.5ms latency cost seems like a
> > pretty reasonable trade-off?
>
> Yeah, on it's face. What I'm bothered about is that it is the exact
> opposite results that I got from my ath10k tests (there, throughput
> *dropped* and latency doubled when going to from 4 to 16 ms of
> buffering).

Hrm, yeah...that would bother me too. I think even if we don't
understand why/how that happened, at some level we need to allow
subsystems or drivers to adjust sk_pacing_shift value. Changing
sk_pacing_shift clearly has an effect that can be optimized.

If smaller values of sk_pacing_shift is increasing the interval (and
allows more buffering), I'm wondering why CPU utilization gets higher.
More buffering is usually more efficient. :/

wgong: can you confirm (a) I've entered the data correctly in the
spreadsheet and (b) you've labeled the data sets correctly when you
generated the data?
If either of us made a mistake, it would be good to know. :)

I'm going to speculate that "other processing" (e.g. device level
interrupt mitigation or possibly CPU scheduling behaviors which
handles TX/RX completion) could cause a "bathtub" effect similar to
the performance graphs that originally got NAPI accepted into the
kernel ~15 years ago.  So the "optimal" value could be different for
different architectures and different IO devices (which have different
max link rates and different host bus interconnects). But honestly, I
don't understand all the details of sk_pacing_shift value nearly as
well as just about anyone else reading this thread.

> And, well, Grant's data is from a single test in a noisy
> environment where the time series graph shows that throughput is all over
> the place for the duration of the test; so it's hard to draw solid
> conclusions from (for instance, for the 5-stream test, the average
> throughput for 6 is 331 and 379 Mbps for the two repetitions, and for 7
> it's 326 and 371 Mbps) . Unfortunately I don't have the same hardware
> used in this test, so I can't go verify it myself; so the only thing I
> can do is grumble about it here... :)

It's a fair complaint and I agree with it.  My counter argument is the
opposite is true too: most ideal benchmarks don't measure what most
users see. While the data wgong provided are way more noisy than I
like, my overall "confidence" in the "conclusion" I offered is still
positive.

cheers,
grant
