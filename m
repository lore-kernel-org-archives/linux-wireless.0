Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:51561 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753213AbeBSRCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 12:02:54 -0500
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 0/3] Export TXQ parameters and statistics via nl80211
Date: Mon, 19 Feb 2018 18:02:21 +0100
Message-Id: <20180219170224.14816-1-toke@toke.dk> (sfid-20180219_180302_465294_DE26996D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds TXQ parameters and statistics that were previously only
available through debugfs to the nl80211 userspace interface and the
cfg80211 kernel interface. Patches for iw to print the statistics and
change the settings are included.

Wasn't sure whether to include the updates to nl80211.h in the iw
patchset, so I didn't :)

-Toke


Kernel patch:

Toke Høiland-Jørgensen (1):
  cfg80211: Expose TXQ stats and parameters to userspace

 include/net/cfg80211.h       |  52 +++++++++++++++++++
 include/uapi/linux/nl80211.h |  57 +++++++++++++++++++++
 net/mac80211/cfg.c           |  95 +++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h   |   3 ++
 net/mac80211/main.c          |   3 ++
 net/mac80211/sta_info.c      |  12 +++++
 net/mac80211/tx.c            |  20 ++++++++
 net/wireless/nl80211.c       | 115 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  12 +++++
 net/wireless/trace.h         |  14 ++++++
 10 files changed, 383 insertions(+)


iw patches (updated nl80211.h not included):

Toke Høiland-Jørgensen (2):
  iw: Print TXQ statistics for stations and interfaces
  iw: Add getting and setting of TXQ params for phy

 info.c      |   3 ++
 interface.c |   6 ++++
 iw.h        |   2 ++
 phy.c       | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 station.c   |  91 ++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 217 insertions(+), 1 deletion(-)
