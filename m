Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34236 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbcDNMQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 08:16:28 -0400
Received: by mail-lf0-f52.google.com with SMTP id j11so106084126lfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2016 05:16:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	apenwarr@gmail.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv3 0/5] mac80211: implement fq_codel
Date: Thu, 14 Apr 2016 14:18:17 +0200
Message-Id: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com> (sfid-20160414_141633_161008_24EADD93)
In-Reply-To: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset disables qdiscs for drivers
using software queuing and performs fq_codel-like
dequeuing on txqs.

I've reworked it as per Avery's suggestion (and
more).

I've (re)tested it against ath10k with and without
DQL (my ath10k RFC which is limited but sufficient
for some proofing scenarios) and got quite nice
looking results:

  http://imgur.com/a/8ruhK
  http://kazikcz.github.io/dl/2016-04-12-flent-fqmac-ath10k-dql.tar.gz

All DQL cases show incremental improvement and are
within expectations. The "dql-fq" case loses TCP
fairness/convergence (compared to "dql-taildrop")
because it removes per-txq 64 packet limit and
"dql-fqcodel" gets it back.


v3:
 * split taildrop, fq and codel functionalities
   into separate patches [Avery]

v2:
 * fix invalid ptr deref
 * fix compilation for backports


Michal Kazior (5):
  mac80211: skip netdev queue control with software queuing
  mac80211: implement fair queueing per txq
  mac80211: add debug knobs for fair queuing
  mac80211: implement codel on fair queuing flows
  mac80211: add debug knobs for codel

 include/net/mac80211.h        |  17 ++-
 net/mac80211/agg-tx.c         |   8 +-
 net/mac80211/codel.h          | 265 ++++++++++++++++++++++++++++++++++++++++
 net/mac80211/codel_i.h        | 100 +++++++++++++++
 net/mac80211/debugfs.c        |  91 ++++++++++++++
 net/mac80211/debugfs_netdev.c |  28 ++++-
 net/mac80211/debugfs_sta.c    |  45 +++++++
 net/mac80211/fq.h             | 276 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/fq_i.h           |  82 +++++++++++++
 net/mac80211/ieee80211_i.h    |  32 ++++-
 net/mac80211/iface.c          |  26 ++--
 net/mac80211/main.c           |  10 +-
 net/mac80211/rx.c             |   2 +-
 net/mac80211/sta_info.c       |  14 +--
 net/mac80211/tx.c             | 274 ++++++++++++++++++++++++++++++++++-------
 net/mac80211/util.c           |  34 ++----
 16 files changed, 1204 insertions(+), 100 deletions(-)
 create mode 100644 net/mac80211/codel.h
 create mode 100644 net/mac80211/codel_i.h
 create mode 100644 net/mac80211/fq.h
 create mode 100644 net/mac80211/fq_i.h

-- 
2.1.4

