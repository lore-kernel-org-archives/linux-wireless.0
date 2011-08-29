Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54157 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab1H2UXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 16:23:19 -0400
Received: by pzk37 with SMTP id 37so9020873pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 13:23:18 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v3 0/7] mesh_fixes
Date: Mon, 29 Aug 2011 13:23:02 -0700
Message-Id: <1314649389-7115-1-git-send-email-javier@cozybit.com> (sfid-20110829_222322_327078_9E090194)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A series of fixes and cleanups to the mesh stack.

Changes from v2:

Dropped "mac80211: Don't take the mesh path resize lock when deleting an mpath" (Johannes)
Fixed concurrency between node removal and table growth (Johannes)

Changes from v1:

There were two contentious patches in the first version:

1. mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()

 This has been fixed (see version patch description).

2.  mac80211: Limit amount of HWMP frames and forwarded data packets in
  queues on mesh interfaces

This has been removed from the set until we figure out a more elegant way to
solve the problem it tried to fix.

Cheers,

Javier Cardona (7):
  mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()
  mac80211: Remove mesh paths when an interface is removed
  mac80211: Improve mpath state locking
  mac80211: Remove redundant mesh path expiration checks
  mac80211: Don't iterate twice over all mpaths when once in sufficient
  mac80211: Consolidate {mesh,mpp}_path_flush into one function
  mac80211: Consolidate mesh path duplicated functions

 net/mac80211/cfg.c          |    2 +-
 net/mac80211/iface.c        |    6 ++
 net/mac80211/mesh.h         |    6 +-
 net/mac80211/mesh_pathtbl.c |  169 ++++++++++++++++++++++++-------------------
 4 files changed, 104 insertions(+), 79 deletions(-)

-- 
1.7.6

