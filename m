Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34754 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1H0ASW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 20:18:22 -0400
Received: by gya6 with SMTP id 6so3293985gya.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 17:18:21 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 0/8] mesh fixes
Date: Fri, 26 Aug 2011 17:18:06 -0700
Message-Id: <1314404294-4233-1-git-send-email-javier@cozybit.com> (sfid-20110827_021825_888831_3154C066)
In-Reply-To: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A series of fixes and cleanups to the mesh stack.
There were two contentious patches in the first version:  

1. mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()

  This has been fixed (see version patch description).

2.  mac80211: Limit amount of HWMP frames and forwarded data packets in
   queues on mesh interfaces

This has been removed from the set until we figure out a more elegant way to
solve the problem it tried to fix.

Cheers,

Javier Cardona (8):
  mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()
  mac80211: Remove mesh paths when an interface is removed
  mac80211: Improve mpath state locking
  mac80211: Remove redundant mesh path expiration checks
  mac80211: Don't iterate twice over all mpaths when once in sufficient
  mac80211: Consolidate {mesh,mpp}_path_flush into one function
  mac80211: Don't take the mesh path resize lock when deleting an mpath
  mac80211: Consolidate mesh path duplicated functions

 net/mac80211/cfg.c          |    2 +-
 net/mac80211/iface.c        |    6 ++
 net/mac80211/mesh.h         |    6 +-
 net/mac80211/mesh_pathtbl.c |  167 +++++++++++++++++++++++--------------------
 4 files changed, 101 insertions(+), 80 deletions(-)

-- 
1.7.6

