Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48375 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1HYBlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:41:02 -0400
Received: by ywf7 with SMTP id 7so1335324ywf.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:41:01 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 0/9] mesh fixes
Date: Wed, 24 Aug 2011 18:40:43 -0700
Message-Id: <1314236452-7226-1-git-send-email-thomas@cozybit.com> (sfid-20110825_034106_545982_7EFE17A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A series of fixes and cleanups to the mesh stack.

Javier Cardona (8):
  mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()
  mac80211: Remove mesh paths when an interface is removed
  mac80211: Improve mpath state locking
  mac80211: Remove redundant mesh path expiration checks
  mac80211: Don't iterate twice over all mpaths when once in sufficient
  mac80211: Consolidate {mesh,mpp}_path_flush into one function
  mac80211: Don't take the mesh path resize lock when deleting an mpath
  mac80211: Consolidate mesh path duplicated functions

Pedro Larbig (1):
  mac80211: Limit amount of HWMP frames and forwarded data packets in
    queues on mesh interfaces

 net/mac80211/cfg.c          |    2 +-
 net/mac80211/debugfs.c      |    4 +
 net/mac80211/ieee80211_i.h  |    2 +
 net/mac80211/iface.c        |    6 ++
 net/mac80211/mesh.h         |   11 +++-
 net/mac80211/mesh_hwmp.c    |   21 +++++-
 net/mac80211/mesh_pathtbl.c |  162 +++++++++++++++++++++++--------------------
 net/mac80211/rx.c           |   13 +++-
 8 files changed, 139 insertions(+), 82 deletions(-)

-- 
1.7.4.1

