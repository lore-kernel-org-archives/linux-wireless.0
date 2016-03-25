Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36518 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbcCYJ0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 05:26:22 -0400
Received: by mail-lf0-f46.google.com with SMTP id d82so51903761lfe.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2016 02:26:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] mac80211: implement fq_codel
Date: Fri, 25 Mar 2016 10:27:30 +0100
Message-Id: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com> (sfid-20160325_102625_921840_FD1CD753)
In-Reply-To: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've cleaned up and removed the
txop-queue-limiting and scheduling from the patch
(compared to my last RFC). It's still to early for
the scheduling thing to go prime time.

The fair queuing on the other hand does seem to
work. In good RF conditions it seems to improve
things (e.g. multiple TCP streams converge into a
steady average). In bad RF conditions things look
same grim as before (but not worse).

I've done a few more experiments with naive DQL in
ath10k and some flent tests prove the fair queuing
in mac80211 works better than fq_codel qdisc as
far as wake_tx_queue drivers are concerned. I'll
be posting a separate thread after this.

This is based on mac80211-next/master
(0a87cadbb54e1595a5f64542adb4c63be914d290).


Michal Kazior (2):
  mac80211: implement fair queuing per txq
  mac80211: expose some txq/fq internals and knobs via debugfs

 include/net/mac80211.h        |  21 ++-
 net/mac80211/agg-tx.c         |   8 +-
 net/mac80211/codel.h          | 264 +++++++++++++++++++++++++++++
 net/mac80211/codel_i.h        |  89 ++++++++++
 net/mac80211/debugfs.c        |  86 ++++++++++
 net/mac80211/debugfs_netdev.c |  29 +++-
 net/mac80211/debugfs_sta.c    |  46 +++++
 net/mac80211/ieee80211_i.h    |  45 ++++-
 net/mac80211/iface.c          |  24 ++-
 net/mac80211/main.c           |   9 +-
 net/mac80211/rx.c             |   2 +-
 net/mac80211/sta_info.c       |  10 +-
 net/mac80211/sta_info.h       |  27 +++
 net/mac80211/tx.c             | 384 +++++++++++++++++++++++++++++++++++++-----
 net/mac80211/util.c           |  20 ++-
 15 files changed, 983 insertions(+), 81 deletions(-)
 create mode 100644 net/mac80211/codel.h
 create mode 100644 net/mac80211/codel_i.h

-- 
2.1.4

