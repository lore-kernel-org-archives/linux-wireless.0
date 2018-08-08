Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40109 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbeHHNCq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 09:02:46 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Wen Gong <wgong@codeaurora.org>, ath10k@lists.infradead.org,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <1533724802-30944-3-git-send-email-wgong@codeaurora.org>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org>
Date: Wed, 08 Aug 2018 12:43:39 +0200
Message-ID: <87sh3pdtpg.fsf@toke.dk> (sfid-20180808_124342_300875_FCE17968)
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
> Overwrite the sk_pacing_shift to 6 in ath10k driver for QCA6174/9377 PCI.
>
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
>
> 5G TCP UL VTH80 on X86 platform with QCA6174A PCI with sk_packing_shift
> set to 6:
>
>   tcp_limit_output_bytes            throughput(Mbps)
>  default(262144)+1 Stream                 336
>  default(262144)+2 Streams                558
>  default(262144)+3 Streams                584
>  default(262144)+4 Streams                602
>  default(262144)+5 Streams                598
>  changed(2621440)+1 Stream                598
>  changed(2621440)+2 Streams               601

You still haven't provided any latency numbers for these tests, which
makes it impossible to verify that setting sk_pacing_shift to 6 is the
right tradeoff.

As I said before, from your numbers I suspect the right setting is
actually 7, which would be 10-20ms less latency under load; way more
important than ~50 Mbps...

-Toke
