Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33445 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbcBPV2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 16:28:23 -0500
From: "Avery Pennarun" <apenwarr@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name
Cc: Avery Pennarun <apenwarr@gmail.com>
Subject: Re: ath9k(?): AP stops sending traffic to iPhone 4S until another 802.11n-capable STA joins
Date: Tue, 16 Feb 2016 16:28:10 -0500
Message-Id: <1455658091-28262-1-git-send-email-apenwarr@gmail.com> (sfid-20160216_222827_992468_8FAD477B)
In-Reply-To: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay, I've made much more progress on this old thread.  I haven't actually
fixed the bug, which I suspect is a race condition only on multicore
machines, but I at least have better reproduction steps and a workaround.

The bug seems to trigger when three things happen at once:
1) Background interference causes retries
2) AP wants to send data to the STA, which has been idle for a while
3) We want to negotiate a new BA session from AP to STA.

Sometimes, the background interference will cause the time between ADDBA
Request (from AP) and ADDBA Response (from STA) to be longer than usual.  In
my tests, it's usually <1ms, but in high-interference situations I've seen
it be >3ms.  Sometimes, when the delay is longer, I see the symptom that the
agg_status file for the station in question starts showing TID#0's "pending"
column increasing slowly, until it eventually reaches 64.  A wifi capture on
a separate sniffer indicates that no data is being transmitted to that
station, although traffic to other stations (and broadcast/multicast)
continues unabated.  I guess this means the device's queues are themselves
not stopped, but the station's per-TID aggregation queue is stuck.

Twiddling the agg_status of a different queue (in this case TID#1) unblocks
TID#0:
echo "tx start 1" >/sys/kernel/debug/ieee80211/phy0/.../agg_status

So does having another aggregation-capable device join the network.  Having
an 802.11g-only device join the network does *not* unblock the queue.

However, trying to stop TID#0 doesn't help (and it also doesn't successfully
stop the aggregation):
echo "tx stop 0" >/sys/kernel/debug/ieee80211/phy0/.../agg_status

The following patch makes the problem easier to reproduce by letting you
turn the aggregation timeout way down.  For myself, I used a
default_agg_timeout of 500ms and just pinged repeatedly once per second from
the AP to STA.  This causes the aggregation sessions to be repeatedly
brought up and torn down, which triggers the problem for me within a few
minutes (when run on a channel with fairly high noise).

Changing default_agg_timeout to zero (as it is on most non-ath9k drivers)
makes the problem pretty much go away.  However, I think it's because I'm
just dodging the code path that triggers a race condition.

Notes:

- I'm using exactly the same ath9k driver (currently 20150525, but we've
  tried newer ones with no difference) on two totally different platforms: a
  dual-core mindspeed c2k host CPU (ARMv7) with separate ath9k, and a
  single-core QCA9531 (MIPS) with on-chip ath9k.

- I've been unable to trigger the problem on the QCA9531, but I have on
  MIPS.

The aggregation code is... a little hairy.  Does anyone have any guesses
where I might look for the race condition?  Or better still, a patch I can
try?


Avery Pennarun (1):
  mac80211: add a debugfs var for the default aggregation timeout.

 net/mac80211/debugfs_netdev.c      | 4 ++++
 net/mac80211/rc80211_minstrel_ht.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.7.0.rc3.207.g0ac5344

