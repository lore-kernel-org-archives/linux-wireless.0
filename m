Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48174 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1DGXJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 19:09:22 -0400
Received: by iyb14 with SMTP id 14so2935734iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 16:09:21 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v8 0/9] {mac|nl}80211: mesh security enhancements
Date: Thu,  7 Apr 2011 15:08:26 -0700
Message-Id: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes, 

Thanks for your comments, your help is much appreciated. Hopefully this will be
the last revision (rhymes with attrition :P). Changes in v8 are pretty much
just reorganizing the patches (Johannes), and fixing a bug in copy_mesh_setup()
(Stanislaw).  

Thomas

Javier Cardona (9):
  nl80211: rename NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE
  cfg80211/nl80211: Add userspace authentication flag to mesh setup
  mac80211: ignore peers if security is enabled for this mesh
  nl80211/mac80211: let userspace authenticate stations
  mac80211: Let user space receive and send mesh auth/deauth frames
  mac80211: ignore peer link requests from unauthenticated stations.
  nl80211/mac80211: Perform PLINK_ACTION on new station
  nl80211: New notification to discover mesh peer candidates.
  mac80211: send notification on new peer candidate for our secure mesh

 include/linux/nl80211.h    |   32 +++++++++++++++++++---
 include/net/cfg80211.h     |   29 +++++++++++++++++---
 net/mac80211/cfg.c         |   22 +++++++++-----
 net/mac80211/ieee80211_i.h |    5 ++-
 net/mac80211/main.c        |    9 +++++-
 net/mac80211/mesh.c        |   14 +++++----
 net/mac80211/mesh.h        |    3 +-
 net/mac80211/mesh_plink.c  |   35 +++++++++++++++++++-----
 net/mac80211/rx.c          |    3 +-
 net/mac80211/tx.c          |    2 +-
 net/wireless/mesh.c        |   23 ++++++++++++++-
 net/wireless/nl80211.c     |   64 +++++++++++++++++++++++++++++++++++++++----
 net/wireless/nl80211.h     |    4 +++
 13 files changed, 202 insertions(+), 43 deletions(-)

-- 
1.7.4.4

