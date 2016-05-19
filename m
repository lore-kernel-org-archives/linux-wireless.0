Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35106 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbcESIgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 04:36:01 -0400
Received: by mail-lf0-f49.google.com with SMTP id e126so6210909lfg.2
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2016 01:36:00 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, apenwarr@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv5 0/5] mac80211: implement fq_codel
Date: Thu, 19 May 2016 10:37:47 +0200
Message-Id: <1463647072-16201-1-git-send-email-michal.kazior@tieto.com> (sfid-20160519_103608_105360_6D5B5CC9)
In-Reply-To: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
References: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset disables qdiscs for drivers
using software queuing and performs fq_codel-like
dequeuing on txqs.

This is based on net-next/master
(0b7962a6c4a37ef3cbb25d976af7b9ec4ce8ad01).

Background:

  https://www.spinics.net/lists/linux-wireless/msg149776.html
  https://www.spinics.net/lists/linux-wireless/msg148714.html
  https://www.spinics.net/lists/linux-wireless/msg149039.html
  http://blog.cerowrt.org/post/dql_on_wifi_2/
  http://blog.cerowrt.org/post/dql_on_wifi/
  http://blog.cerowrt.org/post/fq_codel_on_ath10k/

v5:
 * some fixes (crash, powersave) [me, Tim]
 * reworked debugfs knob (single file now) [Dave]

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

 include/net/mac80211.h     |  18 ++-
 net/mac80211/agg-tx.c      |   8 +-
 net/mac80211/debugfs.c     | 202 ++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  31 ++++-
 net/mac80211/iface.c       |  26 ++--
 net/mac80211/main.c        |  10 +-
 net/mac80211/rx.c          |   2 +-
 net/mac80211/sta_info.c    |  14 +--
 net/mac80211/tx.c          | 298 +++++++++++++++++++++++++++++++++++++++------
 net/mac80211/util.c        |  34 ++----
 10 files changed, 545 insertions(+), 98 deletions(-)

-- 
2.1.4

