Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35756 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbcEEK6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2016 06:58:49 -0400
Received: by mail-lf0-f45.google.com with SMTP id j8so91359726lfd.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2016 03:58:49 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	apenwarr@gmail.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv4 0/5] mac80211: implement fq_codel
Date: Thu,  5 May 2016 13:00:34 +0200
Message-Id: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com> (sfid-20160505_125853_662061_4F117AD7)
In-Reply-To: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset disables qdiscs for drivers
using software queuing and performs fq_codel-like
dequeuing on txqs.

This is based on net-next/master
(035cd6ba53eff060760c4f4d11339fcc916a967c).

For anyone interested I've pushed tree with my
(now oldish) ath10k DQL RFC and a small fix I've
been testing:

  https://github.com/kazikcz/linux/tree/fqmac-v4%2Bdqlrfc%2Bcpuregrfix

Background:

  https://www.spinics.net/lists/linux-wireless/msg149776.html
  https://www.spinics.net/lists/linux-wireless/msg148714.html
  https://www.spinics.net/lists/linux-wireless/msg149039.html
  http://blog.cerowrt.org/post/dql_on_wifi_2/
  http://blog.cerowrt.org/post/dql_on_wifi/
  http://blog.cerowrt.org/post/fq_codel_on_ath10k/


v4:
 * the taildrop stop-gap patch moved to
   per-interface limit (instead of per-radio) [Johannes]
 * pushed fq.h and codel.h changes to include/net/ [Johannes]

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

 include/net/mac80211.h        |  18 ++-
 net/mac80211/agg-tx.c         |   8 +-
 net/mac80211/debugfs.c        | 117 ++++++++++++++++
 net/mac80211/debugfs_netdev.c |  28 +++-
 net/mac80211/debugfs_sta.c    |  45 +++++++
 net/mac80211/ieee80211_i.h    |  31 ++++-
 net/mac80211/iface.c          |  26 ++--
 net/mac80211/main.c           |  10 +-
 net/mac80211/rx.c             |   2 +-
 net/mac80211/sta_info.c       |  14 +-
 net/mac80211/tx.c             | 302 ++++++++++++++++++++++++++++++++++++------
 net/mac80211/util.c           |  34 ++---
 12 files changed, 532 insertions(+), 103 deletions(-)

-- 
2.1.4

