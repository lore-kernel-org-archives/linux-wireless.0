Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:46229 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729190AbeGZNCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 09:02:16 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Wen Gong <wgong@codeaurora.org>, ath10k@lists.infradead.org,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <1532589677-16428-3-git-send-email-wgong@codeaurora.org>
References: <1532589677-16428-1-git-send-email-wgong@codeaurora.org> <1532589677-16428-3-git-send-email-wgong@codeaurora.org>
Date: Thu, 26 Jul 2018 13:45:43 +0200
Message-ID: <87zhye1aqg.fsf@toke.dk> (sfid-20180726_134553_755240_4785EB50)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wen Gong <wgong@codeaurora.org> writes:

> Upstream kernel has an interface to help adjust sk_pacing_shift to help
> improve TCP UL throughput.
> The sk_pacing_shift is 8 in mac80211, this is based on test with 11N
> WiFi chips with ath9k. For QCA6174/QCA9377 PCI 11AC chips, the 11AC
> VHT80 TCP UL throughput testing result shows 6 is the optimal.
> Overwrite the sk_pacing_shift to 6 in ath10k driver.

When I tested this, a pacing shift of 8 was quite close to optimal as
well for ath10k. Why are you getting different results?

> Tested with QCA6174 PCI with firmware
> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
> It's not a regression with new firmware releases.
>
> There have 2 test result of different settings:
>
> ARM CPU based device with QCA6174A PCI with different
> sk_pacing_shift:
>
>  sk_pacing_shift  throughput(Mbps)             CPU utilization
>          6            500(-P5)      ~75% idle, Focus on CPU1: ~14%idle
>          7            454(-P5)      ~80% idle, Focus on CPU1: ~4%idle
>          8               288        ~90% idle, Focus on CPU1: ~35%idle
>          9              ~200        ~92% idle, Focus on CPU1: ~50%idle

Your tests do not include latency values; please try running a test that
also measures latency. The tcp_nup test in Flent (https://flent.org)
will do that, for instance. Also, is this a single TCP flow?

-Toke
