Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f43.google.com ([209.85.167.43]:43494 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbeIVGpJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 02:45:09 -0400
Received: by mail-lf1-f43.google.com with SMTP id x24-v6so12456835lfe.10
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2018 17:53:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ece4e4dcd2776413c8b297731df3c02c@codeaurora.org>
References: <1537470331-6270-1-git-send-email-rmanohar@codeaurora.org>
 <8d8e3775-4504-7b37-19b0-4a7fae054d12@nbd.name> <ece4e4dcd2776413c8b297731df3c02c@codeaurora.org>
From: Kan Yan <kyan@google.com>
Date: Fri, 21 Sep 2018 17:53:42 -0700
Message-ID: <CA+iem5t7eHgX5EtePvvXFpHSfDNcUwmKefvDoYb-KO050OXJKQ@mail.gmail.com> (sfid-20180922_025558_298135_E9ABEC8D)
Subject: Re: [RFC v2] mac80211: budget outstanding airtime for transmission
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        linux-wireless-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rajkumar,

It is great to see your patches and thank you for helping bring this
to upstream.

> Why signed? This should never become negative unless something is wrong
> with the accounting somewhere?

It is signed because the "budget" is allowed to go negative.  In the
original version,  as long as the budget is > 0, at least one packet
is released even the budget is less than the airtime required for the
packet.  One major issue I had when doing airtime based queue limit is
how to prevent txq with very low data rate (e.g., 6 mbps) from getting
stalled for too long. My solution is to allow budget to go negative
for one packet, then reset budget to 0 when all frames from that txq
has been completed and the inflight packets count reaches to 0.

For the ieee80211_calc_airtime_budget(), although it is sufficient for
the purpose of enforcing queue limit, the airtime overhead estimation
in the original patch really crude and could use some improvement.
Instead of using the last reported tx PHY rate and a guesstimate of
overhead to calculate airtime,  one possible improvement is to
calculate the estimated "real" tx rate from a windowed moving average
of past tx_bytes/tx_airtime, if the firmware is capable of reporting
tx airtime for each completed PPDU.
