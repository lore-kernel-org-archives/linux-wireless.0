Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:52194 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab1HIXqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 19:46:23 -0400
Received: by iye16 with SMTP id 16so23646iye.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 16:46:22 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 0/8] mac80211: add mesh gate forwarding
Date: Tue,  9 Aug 2011 16:45:03 -0700
Message-Id: <1312933511-9486-1-git-send-email-thomas@cozybit.com> (sfid-20110810_014627_179580_420ABEA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier Cardona (8):
  mac80211: improve mpath debugging
  mac80211: fix mpath timer NULL function
  mac80211: mesh locking fixes
  mac80211: fix mesh path flushing
  mac80211: mesh gate implementation
  {nl,mac}80211: add missing root mode meshconf entries
  {nl,cfg,mac}80211: let userspace set RANN interval
  {nl,cfg,mac}80211: let userspace make meshif mesh gate

 include/linux/ieee80211.h     |    4 +
 include/linux/nl80211.h       |    9 ++
 include/net/cfg80211.h        |    6 +
 net/mac80211/Kconfig          |   13 ++
 net/mac80211/cfg.c            |    8 +
 net/mac80211/debugfs_netdev.c |    8 +-
 net/mac80211/ieee80211_i.h    |    1 +
 net/mac80211/mesh.c           |    6 +-
 net/mac80211/mesh.h           |   12 ++-
 net/mac80211/mesh_hwmp.c      |   77 +++++++----
 net/mac80211/mesh_pathtbl.c   |  303 ++++++++++++++++++++++++++++++++++++++++-
 net/wireless/mesh.c           |    3 +
 net/wireless/nl80211.c        |   15 ++
 13 files changed, 431 insertions(+), 34 deletions(-)

-- 
1.7.6

