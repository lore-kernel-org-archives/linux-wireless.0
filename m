Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:37168 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbcFCQwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 12:52:41 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [RFC/RFT 0/5] Adding an airtime fairness scheduler to ath9k
Date: Fri,  3 Jun 2016 18:51:39 +0200
Message-Id: <20160603165144.17356-1-toke@toke.dk> (sfid-20160603_185250_640037_81D3B9DC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set is my first pass at attempting to add an airtime fairness
enforcing scheduler to ath9k (for use in access point mode). For some
background on this approach and its possible benefits see this paper:
https://www.usenix.org/event/usenix04/tech/general/full_papers/tan/tan.pdf

This is still very preliminary work, but I thought I'd post it for
comment anyway. Tentatively, it's looking like it gives some
improvement, but is by no means perfect in what it is achieving. See
https://blog.tohojo.dk/2016/06/a-first-stab-at-an-airtime-fairness-scheduler-for-ath9k.html
for some graphs of the patch set. I'm seeing roughly a 15% improvement
in aggregate throughput in the presence of a slow station.

To work, the scheduler needs per-station queueing, so this patch series
also includes Michal's patch to not have qdiscs on the interface when
wake_tx_queue is present, and Tim's patch to add wake_tx_queue to ath9k.
The latter I reworked to not require the global variable renaming, since
I found that change to be too confusing after having spent time getting
used to the ath9k names for things (I put my own name on this commit and
added a second Signed-off-by; apologies if this is not the right way to
do things for this kind of rework).

The scheduler patch set itself is in three parts: The first patch simply
adds airtime accounting and exports it to a per-station debugfs file
(which the latest git version of Flent knows how to read). The second
patch adds the airtime scheduler using only the TX airtime information.
Finally the third patch adds in RX airtime to the deficit used by the
scheduler. This last part is not always a win (see the blog post linked
above), but I haven't tested it extensively. So feel free to test with
or without the last patch.

There is some code duplication between the debugfs code and the
scheduler which I haven't removed yet to be able to easily switch
between having the scheduler use the airtime values and simply
accounting them for debugging purposes.

Comments and test results very welcome! :)

-Toke



Michal Kazior (1):
  mac80211: skip netdev queue control with software queuing

Toke Høiland-Jørgensen (4):
  ath9k: use mac80211 intermediate software queues
  ath9k: Add airstame stats to per-station debugfs
  ath9k: Add a per-station airtime deficit scheduler
  ath9k: Count RX airtime in airtime deficit.

 drivers/net/wireless/ath/ath9k/ath9k.h     |  27 +++-
 drivers/net/wireless/ath/ath9k/channel.c   |  12 +-
 drivers/net/wireless/ath/ath9k/debug.h     |  29 ++++
 drivers/net/wireless/ath/ath9k/debug_sta.c | 144 ++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/init.c      |   1 +
 drivers/net/wireless/ath/ath9k/main.c      |   7 +-
 drivers/net/wireless/ath/ath9k/recv.c      |  50 +++++++
 drivers/net/wireless/ath/ath9k/xmit.c      | 222 ++++++++++++++++++++++++-----
 include/net/mac80211.h                     |   4 -
 net/mac80211/ieee80211_i.h                 |   2 +-
 net/mac80211/iface.c                       |  18 ++-
 net/mac80211/main.c                        |   3 -
 net/mac80211/sta_info.c                    |   2 +-
 net/mac80211/tx.c                          |  82 ++++++-----
 net/mac80211/util.c                        |  11 +-
 15 files changed, 511 insertions(+), 103 deletions(-)

-- 
2.7.4
