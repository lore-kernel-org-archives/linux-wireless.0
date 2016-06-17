Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:58197 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbcFQJJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 05:09:42 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 0/2] ath9k: Add airtime fairness scheduler
Date: Fri, 17 Jun 2016 11:09:27 +0200
Message-Id: <20160617090929.31606-1-toke@toke.dk> (sfid-20160617_110955_269636_FF32CD7C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the second version of my airtime fairness patch. This version
has a somewhat reworked scheduler (now closer to the structure of
fq_codel) and a different way to measure RX airtime; and there's a
debugfs entry to control which airtime measurements to include in the
scheduling decisions. For a simple one-way UDP test, the scheduler
achieves pretty much perfect airtime share (by its own measure). There's
not much throughput difference in the UDP case, but TCP tests see a
moderate improvement. I'll write up something more detailed on the
performance measures over the weekend and post it in a separate mail.

This patch set is rebased to mac80211-next - which means it no longer
includes Michal's patch to disable qdiscs. I have retained my version of
Tim's patch to make ath9k use wake_tx_queue in this patch set. That
probably needs some work still, but I believe he is working on that. I
have not tested extensively with the mac80211 FQ-CoDel patches enabled,
but I expect them to be complementary to this.

Changes since the RFC version:

- The scheduler will now enforce fairness harder. The previous version
  would refill the deficit of slow stations too fast in some cases.

- Change the way RX airtime is measured. For aggregates, the airtime is
  now calculated as the difference between the rs->rs_tstamp of the
  first and last frame in the aggregate. For non-aggregates, the
  previous calculation from the packet size is retained.

- There is now an 'airtime_flags' debugfs entry which can be used to
  control which airtime measures are accounted to the deficit. If bit 0
  is set, TX airtime will be accounted, and if bit 1 is set, RX airtime
  will. If no bits are set, the scheduler will revert to simple
  round-robin scheduling. The default is enabling both TX and RX.

- Squashed the whole thing into one patch and rebased to mac80211-next.

Toke Høiland-Jørgensen (2):
  ath9k: use mac80211 intermediate software queues
  ath9k: Add a per-station airtime deficit scheduler

 drivers/net/wireless/ath/ath9k/ath9k.h     |  34 +++-
 drivers/net/wireless/ath/ath9k/channel.c   |  12 +-
 drivers/net/wireless/ath/ath9k/debug.c     |   3 +
 drivers/net/wireless/ath/ath9k/debug.h     |  29 ++++
 drivers/net/wireless/ath/ath9k/debug_sta.c |  53 +++++-
 drivers/net/wireless/ath/ath9k/init.c      |   2 +
 drivers/net/wireless/ath/ath9k/main.c      |   7 +-
 drivers/net/wireless/ath/ath9k/recv.c      |  60 +++++++
 drivers/net/wireless/ath/ath9k/xmit.c      | 255 ++++++++++++++++++++++-------
 9 files changed, 386 insertions(+), 69 deletions(-)

-- 
2.8.3
