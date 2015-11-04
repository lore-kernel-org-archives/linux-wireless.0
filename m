Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34022 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbbKDFUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 00:20:32 -0500
Received: by obbza9 with SMTP id za9so31243486obb.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2015 21:20:31 -0800 (PST)
MIME-Version: 1.0
From: Avery Pennarun <apenwarr@gmail.com>
Date: Wed, 4 Nov 2015 00:20:12 -0500
Message-ID: <CAHqTa-1jwvOSjEwo8c_3-80rBXf91LMVTQkgqed1FPmOR7rXNQ@mail.gmail.com> (sfid-20151104_062035_211578_1CFB4A31)
Subject: ath9k(?): AP stops sending traffic to iPhone 4S until another
 802.11n-capable STA joins
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Cc: Tim Shepard <shep@alum.mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[fixed ath9k list address.  sorry for the spam]

Hi all,

I have a pretty weird problem I've been chasing for a few weeks and
have narrowed it down, but not quite solved it.  It may be caused by
bugs in aggregation-related code.

Steps:
- Set up an ath9k-based Linux AP on an ARM processor (currently using
this version of backports, though I've tried older and newer versions
with no change: "backported from Linux (next-20150525-0-gc201847)
using backports backports-20150525-0-g49969bd")
- Join my iPhone 4S (running iOS 7.1.2) to the network
- Use it for a while
- Eventually it will stay connected, but Internet access doesn't work
- Wireless packet captures show that packets are received *from* the
iPhone, and ACKs are returned for those packets from the ath9k, and
those packets are correctly forwarded to the AP's br0 interface.  But
outgoing packets show up on br0 and wlan0 with tcpdump, but never make
it onto the air.
- Putting the iPhone 4S into airplane mode and then letting it
reconnecting will fix it for a few more seconds/minutes before it
stops again.

More details:
- It only seems to happen to my iPhone 4S client (never seen it with a
different client).
- It only seems to happen with my ath9k AP.
- It only seems to happen on my home network (another instance of the
same AP hardware on another network doesn't trigger the problem).
- It only seems to happen when no other 802.11n-capable devices are
connected to the same AP.
- The moment I join an 802.11n-capable device to the AP, traffic
instantly unblocks (see packet capture below).
- Joining an 802.11g-only device (no aggregation) does *not* unblock traffic.
- Disabling encryption and turning wmm_enable on and off have no effect.
- Disabling 802.11n support on the AP (so that everyone has to use
802.11g) makes the problem go away.
- 'ip -s link show dev wlan0' shows tx packet counters continuing to
increase during the outage, even though packets aren't flowing.
- I applied a patch from Tim Shepard to track the most recent tx
attempt, acked tx, and rx packet times inside mac80211.  According to
this data, mac80211 thinks rx happened at most a couple of seconds ago
(as expected).  The most recent tx was acked, but it was back around
the time the outage started.  Note that this disagrees with 'ip -s
link' and tcpdump, which think they transmitted much more recently
than that.  (The patch is here:
https://gfiber-review.googlesource.com/#/c/1250/ )

I captured a pcap of a new 802.11n-capable device joining the network
and unblocking the transmit.  The action starts around frame 325:
   http://apenwarr.ca/tmp/iPod4-fixing-iPhone4-trimmed.pcap.gz

In this pcap, the main players are:
   ath9k AP: 88:dc:96:08:60:50
   iPhone 4S with the problem: e4:25:e7:73:e6:31
   New client fixing the problem (iPod 4): 18:e7:f4:7e:c1:42

Observations from the pcap:
- Upstream packets (iPhone->ath9k) are received and acked (see eg. frame 154)
- Beacons from the ath9k show an empty TIM bitmap until the iPod
joins, then it's nonempty and things unblock.

Does anyone have any thoughts about what to look for here?

Have fun,

Avery
