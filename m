Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59238 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbeICN6C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:58:02 -0400
Message-ID: <1535967508.3437.31.camel@sipsolutions.net> (sfid-20180903_113858_909891_E1AC3D15)
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi
 chips
From: Johannes Berg <johannes@sipsolutions.net>
To: Grant Grundler <grundler@google.com>, wgong@qti.qualcomm.com,
        toke@toke.dk
Cc: wgong@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Date: Mon, 03 Sep 2018 11:38:28 +0200
In-Reply-To: <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com> (sfid-20180831_013254_112272_6E3FAD3E)
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
         <1533724802-30944-3-git-send-email-wgong@codeaurora.org>
         <87sh3pdtpg.fsf@toke.dk>
         <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
         <87mutue4y8.fsf@toke.dk>
         <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com>
         <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com>
         (sfid-20180831_013254_112272_6E3FAD3E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-08-30 at 16:32 -0700, Grant Grundler wrote:
> On Sun, Aug 12, 2018 at 10:37 PM Wen Gong <wgong@qti.qualcomm.com> wrote:
> ...
> > I have tested with your method for shift 6/8/10/7 all twice time in open air environment.
> 
> I've attached the graphed data which Wen provided me and I made one
> "cleanup": the median and average "ICMP" are computed only using
> values where flent has an "antagonist" load running.  The first 28 and
> last 26 seconds of the test are "idle" - it makes no sense to include
> the latency of those. This drops about 1/7th of the data points.
> 
> My observations:
> o the delta between average and median is evidence this is not
> particularly reliable data (but expected result for "open air" wifi
> testing in a corp environment).
> o sk_pacing_shift=8 and/or =7 appears to have suffered from
> significant open air interference - I've attached a graph of the raw
> data.
> o I'm comfortable asserting throughput is higher and latency is lower
> for sk_pacing_shift=6 (vs 7) at the cost of additional CPU
> utilization.
> 
> My questions:
> 1) Is the current conversation just quibbling about 6 vs 7 for the
> ath10k default?

6 vs. 8, I think? But I didn't follow the full discussion.

I also think that we shouldn't necessarily restrict this to "for the
ath10k". Is there any reason to think that this would be different for
different chips?

I could see a reason for a driver to set the default *higher* than the
mac80211 default (needing more buffers for whatever internal reason),
but I can't really see a reason it should be *lower*. Also, the
networking-stack wide default is 0, after all, so it seems that each new
layer might have some knowledge about why to *increase* it (like
mac80211 knows that A-MPDUs/A-MSDUs need to be built), but it seems not
so reasonable that it should be reduced again. Unless you have some
specific knowledge that ath10k would have a smaller A-MSDU/A-MPDU size
limit or something?

> 2) If yes, can both patches be accepted and then later add code to
> select a default based on CPU available?

I've applied the first patch now (with some comment cleanups, you may
want to pick those up for your internal usage) because I can see an
argument for increasing it.

However, I think that the "quibbling" over the default should most
likely result in a changed default value for mac80211, rather than
ath10k using the driver setting as a way out of that discussion.

johannes
