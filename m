Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53137 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1BMR5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 12:57:15 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so4086972iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 09:57:14 -0800 (PST)
From: "Nathaniel J. Smith" <njs@pobox.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, "Nathaniel J. Smith" <njs@pobox.com>
Subject: [PATCH 0/5] iwlwifi: Auto-tune tx queue size to maintain latency under load
Date: Sun, 13 Feb 2011 09:56:37 -0800
Message-Id: <1297619803-2832-1-git-send-email-njs@pobox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an iwl3945 in my laptop, and find that whenever I saturate the
outgoing connection -- which happens daily when my rsync backup kicks
in -- then latency becomes astronomical (what Jim Gettys calls
"bufferbloat"). I've measured 12-13 second ping times to my router. As
you can imagine, this makes web browsing or interactive SSH somewhat
uncomfortable.

The problem is the very large TX queue in the iwlwifi driver, which is
non-adjustable and willing to buffer several hundred packets at a
time. My pings, HTTP connections, and so on get stuck at the end of
this line, and have to wait for multiple seconds while all the packets
ahead of them get sent.

(A secondary problem is the txqueue in the network layer, but this can
be fixed via 'ip link set wlan0 txqueuelen $LEN', or by traffic
shaping. But so long as the driver queue is so huge, neither really
makes any difference.)

This patch series teaches the driver to measure the average rate of
packet transmission for each tx queue, and adjusts the queue size
dynamically in an attempt to achieve ~2 ms of added latency.

Patches are against wireless-testing (0fd54899). All patches tested on
iwl3945 hardware. I've been running the full patch (against an earlier
wireless-testing) full time for more than a month, and it's been just
as reliable as the standard driver.

Hard numbers
------------
I made a test file:
  dd if=/dev/urandom of=/tmp/50-megs bs=1M count=50
Then ran a test load and a latency measurement, started at the same time:
  scp /tmp/50-megs 192.168.16.1:/dev/zero
  sleep 20 && ping -n 192.168.16.1 -c 20 -q
Measurements are on my home network, which is not the cleanest
environment, and bandwidth fluctuates enough that it isn't worth
reporting (scp reports between ~100KB/s and 200KB/s). But at least
it's realistic... Each test performed twice, in intermixed order.

(numbers are RTT min/avg/max/mdev in ms, as reported by ping)

Baseline: current wireless-testing, with txqueuelen 1000
  1550.601  5404.818  8672.305  2423.160 ms
  1484.907  4554.160  6632.850  1326.948 ms

Best currently achievable: current wireless-testing, with txqueuelen 2
  2196.802  4121.507  6009.160   910.079 ms
  1092.415  2170.247  3860.628   674.256 ms

New best: patched wireless-testing, with txqueuelen 2
     3.812    44.419    95.883    26.462 ms
     1.793    34.926   137.325    33.161 ms

As you can see, this patch achieves something like a 2 order of
magnitude reduction in RTT, and if there's any effect on throughput
then it's too subtle to notice in my environment. (The single highest
observed throughput was actually in the second test of the patched
kernel.)

Nathaniel J. Smith (5):
  iwlwifi: Simplify tx queue management
  iwlwifi: Convert the tx queue high_mark to an atomic_t
  iwlwifi: Invert the sense of the queue high_mark
  iwlwifi: auto-tune tx queue size to minimize latency
  iwlwifi: make current tx queue sizes visible in debugfs

 drivers/net/wireless/iwlwifi/iwl-3945.c     |    6 ++-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   11 +++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    6 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   20 ++++++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   62 ++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 ++-
 9 files changed, 87 insertions(+), 34 deletions(-)

