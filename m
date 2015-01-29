Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35111 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbbA2LtC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 06:49:02 -0500
Received: by mail-wi0-f171.google.com with SMTP id l15so24943499wiw.4
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2015 03:49:00 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 29 Jan 2015 12:48:59 +0100
Message-ID: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com> (sfid-20150129_124912_068536_D1E0D59C)
Subject: Throughput regression with `tcp: refine TSO autosizing`
From: Michal Kazior <michal.kazior@tieto.com>
To: eric.dumazet@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not subscribed to netdev list and I can't find the message-id so I
can't reply directly to the original thread `BW regression after "tcp:
refine TSO autosizing"`.

I've noticed a big TCP performance drop with ath10k
(drivers/net/wireless/ath/ath10k) on 3.19-rc5. Instead of 500mbps I
get 250mbps in my testbed.

After bisecting I ended up at `tcp: refine TSO autosizing`. Reverting
`tcp: refine TSO autosizing` and `tcp: Do not apply TSO segment limit
to non-TSO packets` (for conflict free reverts) fixes the problem.

My testing setup is as follows:

 a) ath10k AP, github.com/kvalo/ath/tree/master 3.19-rc5, w/ reverts
 b) ath10k STA connected to (a), github.com/kvalo/ath/tree/master
3.19-rc5, w/ reverts
 c) (b) w/o reverts

Devices are 3x3 (AP) and 2x2 (Client) and are RF cabled. 11ac@80MHz
2x2 has 866mbps modulation rate. In practice this should deliver
~700mbps of real UDP traffic.

Here are some numbers:

UDP: (b) -> (a): 672mbps
UDP: (a) -> (b): 687mbps
TCP: (b) -> (a): 526mbps
TCP: (a) -> (b): 500mbps

UDP: (c) -> (a): 669mbps*
UDP: (a) -> (c): 689mbps*
TCP: (c) -> (a): 240mbps**
TCP: (a) -> (c): 490mbps*

* no changes/within error margin
** the performance drop

I'm using iperf:
  UDP: iperf -i1 -s -u vs iperf -i1 -c XX -u -B 200M -P5 -t 20
  TCP: iperf -i1 -s vs iperf -i1 -c XX -P5 -t 20

Result values were obtained at the receiver side.

Iperf reports a few frames lost and out-of-order at each UDP test
start (during first second) but later has no packet loss and no
out-of-order. This shouldn't have any effect on a TCP session, right?

The device delivers batched up tx/rx completions (no way to change
that). I suppose this could be an issue for timing sensitive
algorithms. Also keep in mind 802.11n and 802.11ac devices have frame
aggregation windows so there's an inherent extra (and non-uniform)
latency when compared to, e.g. ethernet devices.

The driver doesn't have GRO. I have an internal patch which implements
it. It improves overall TCP traffic (more stable, up to 600mbps TCP
which is ~100mbps more than without GRO) but the TCP: (c) -> (a)
performance drop remains unaffected regardless.

I've tried applying stretch ACK patchset (v2) on both machines and
re-run the above tests. I got no measurable difference in performance.

I've also run these tests with iwlwifi 7260 (also a 2x2) as (b) and
(c). It didn't seem to be affected by the TSO patch at all (it runs at
~360mbps of TCP regardless of the TSO patch).

Any hints/ideas?


Michał
