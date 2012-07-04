Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56839 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2GDP64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 11:58:56 -0400
Received: by wgbds11 with SMTP id ds11so4936550wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 08:58:55 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [RFC 0/4] allow setting HT capabilities per vif
Date: Wed,  4 Jul 2012 18:58:46 +0300
Message-Id: <1341417530-9062-1-git-send-email-arik@wizery.com> (sfid-20120704_175900_227186_1AFCE6E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TI has a card that supports different HT caps according to operating
mode. Allow overriding the per-band HT capabilities in struct wiphy
with HT-caps in the vif, to be set by the driver on the mac80211 callback
add_interface.

The GET_WIPHY command is modified to consider the interface when
advertising HW capabilities to usermode. Luckily, today wpa_s sends
the interface as well so no modifications are required there.

Currently "iw phy" will list a card using this as a 11g card. This
will be addressed at a later date (probably by a new command).

Arik Nemtsov (4):
  nl80211: accept optional netdev in send_wiphy
  cfg80211: support unused HT-cap-per-band configuration
  cfg80211: allow driver to implement HT capabilities per netdev
  mac80211: allow setting HT capabilities per vif

 include/net/cfg80211.h     |   21 ++++++++++-
 include/net/mac80211.h     |    4 ++
 net/mac80211/cfg.c         |   11 ++++++
 net/mac80211/ht.c          |   19 ++++++----
 net/mac80211/ibss.c        |   11 ++++--
 net/mac80211/ieee80211_i.h |    6 ++-
 net/mac80211/iface.c       |   10 +++--
 net/mac80211/main.c        |    2 +-
 net/mac80211/mesh.c        |    9 +++--
 net/mac80211/mlme.c        |   20 +++++++---
 net/mac80211/scan.c        |    5 ++-
 net/mac80211/util.c        |   31 +++++++++++++---
 net/wireless/chan.c        |   10 +++--
 net/wireless/core.c        |    3 +-
 net/wireless/nl80211.c     |   87 +++++++++++++++++++++++++++++++++++---------
 net/wireless/wext-compat.c |    4 +-
 16 files changed, 194 insertions(+), 59 deletions(-)

-- 
1.7.9.5

