Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:37747 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbcHPUui (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 16:50:38 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Michal Kazior <michal.kazior@tieto.com>,
	Dave Taht <dave.taht@gmail.com>
Subject: On the ath9k performance regression with FQ and crypto
Date: Tue, 16 Aug 2016 22:41:28 +0200
Message-ID: <87pop85tvr.fsf@toke.dk> (sfid-20160816_225058_637673_0A7B846A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So Dave and I have been spending the last couple of days trying to
narrow down why there's a performance regression in some cases on ath9k
with the softq-FQ patches. Felix first noticed this regression, and LEDE
currently carries a patch [1] to disable the FQ portion of the softq
patches to avoid it.

While we have been able to narrow it down a little bit, no solution has
been forthcoming, so this is an attempt to describe the bug in the hope
that someone else will have an idea about what could be causing it.

What we're seeing is the following (when the access point is running
ath9k with the softq patches):

When running two or more flows to a station, their combined throughput
will be roughly 20-30% lower than the throughput of a single flow to the
same station. This happens:

- for both TCP and UDP traffic.
- independent of the base rate (i.e. signal quality).
- but only with crypto enabled (WPA2 CCMP in this case).

However, the regression completely disappears if either of the
following is true:

- no crypto is enabled.
- the FQ part of mac80211 is disabled (as in [1]).

We have been able to reproduce this behaviour on two different ath9k
hardware chips and two different architectures.

The cause of the regression seems to be that the aggregates are smaller
when there are two flows than when there is only one. Adding debug
statements to the aggregate forming code indicates that this is because
no more packets are available when the aggregates are built (i.e.
ieee80211_tx_dequeue() returns NULL).

We have not been able to determine why the queues run empty when this
combination of circumstances arise. Since we easily get upwards of 120
Mbps of TCP throughput without crypto but with full FQ, it's clearly not
the hashing overhead in itself that does it (and the hashing also
happens with just one flow, so the overhead is still there). And the
crypto itself should be offloaded to hardware (shouldn't it? we do see a
marked drop in overall throughput from just enabling crypto), so how
would the queueing (say, mixing of packets from different flows)
influence that?

Does anyone have any ideas? We are stumped...

-Toke

[1] https://git.lede-project.org/?p=lede/nbd/staging.git;a=blob;f=package/kernel/mac80211/patches/220-fq_disable_hack.patch;h=7f420beea56335d5043de6fd71b5febae3e9bd79;hb=HEAD
