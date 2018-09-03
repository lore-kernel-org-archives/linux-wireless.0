Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:34641 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbeICTSc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 15:18:32 -0400
Received: by mail-qt0-f174.google.com with SMTP id m13-v6so881317qth.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2018 07:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
 <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk>
 <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
 <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com>
 <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com>
 <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk>
 <1535975240.3437.61.camel@sipsolutions.net> <878t4i1z74.fsf@toke.dk>
In-Reply-To: <878t4i1z74.fsf@toke.dk>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 3 Sep 2018 07:57:45 -0700
Message-ID: <CAA93jw6MQD70XatAmjG-OwVa_Rn5Ey-5Ni22iTCPARaH+KjnJA@mail.gmail.com> (sfid-20180903_165821_988620_4CC9F653)
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Johannes Berg <johannes@sipsolutions.net>, grundler@google.com,
        wgong@qti.qualcomm.com, wgong@codeaurora.org,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have not been on this thread (I have had to shut down my wifi lab
and am not planning on doing any more wifi work in the future). But
for what it's worth:

* tcp_pacing_shift affects the performance of the tcp stack only. I
think 16ms is an outrageous amount, and I'm thinking we actually have
a problem on the other side of the link in getting acks out as I
write. That said,
I don't care all that much compared to the bad old days (
http://blog.cerowrt.org/tags/wifi ) and 16ms
is far better than the seconds it used to be.

That said, I'd rather appreciate a test on HT20 with the same chipset
at a lower rate. The hope was that
we'd achieve flat latency at every rate (see
http://blog.cerowrt.org/post/real_results/ for some lovely pics)

Flent can sample minstrel stats but I think we're SOL on the ath10k.

* The irtt test can measure one way delays pretty accurately so you
can see if the other side is actually the source of this issue.

* Not clear to me if the AP is also running the fq_codel for wifi
code? That, um, er, helps an AP enormously....

* Having an aircap and regular capture of what's going on during these
tests would be useful. Flent is a great test driver, but a tcpdump
taken during a flent test tells the truth via tcptrace and xplot.org.
We can inspect cwnd, rwnd, and look at drops. (actually I usually turn
ECN on so I can see when the codel algorithm is kicking in). Being
able to zoom in on the early ramp would be helpful. Etc.

I'll take a look at them if you'll supply them.

* At some point the ath10k driver also gained NAPI support. (?) I
don't think NAPI is a good fit for wifi. Delays in TCP RX processing
lead to less throughput.

* The firmware is perpetually trying to do more stuff with less
interrupts. Me, I dreamed of a register you could poll for "when will
the air be clear", and a "tx has one ms left to go, give me some more
data" interrupt. The fact we still have a minimum of ~12ms of
uncontrolled buffering bugs me. If we could just hold off submittal
until just before it was needed, we could cut it in half (and further,
by 10s of ms, when the media is contended).

* My general recomendation for contended APs was that they advertise a
reduced TXOP as the number of active stations go up. (this also
applies to the VI/VO queues). Never got around to algorizing it... I
gave up on my links and, disable VO/VI/BK entirely and just tell
hostapd to advertise 2ms. Yep, kills conventional measures of
throughput. Cuts inter-station service time by 2/3s though, and *that*
you can notice and measure with PLT benchmarks and overall feel.

This implies increasing the pacing shift to suit the advertised size
of the txop, not decreasing it - and I have no idea how to get that
from one place to another. Same goes for stuff destined for the VI/VO
queues.

* (also it would be good to see in the capture what the beacon says)

* Powersave has always been a problem...

* Cubic is a terrible tcp for wifi. BBR, however, is possibly worse...
or better. It would be educational to try running BBR on this link at
either shift setting. (seriously!) TCP is not TCP is not TCP....

Lastly... tcp_pacing_shift does not affect the number of other packets
that can get into a given txop given the other buffering - it's one in
the hardware, one ready to go, one being formed, try setting
pacing_shift to to 4 to see what happens....
