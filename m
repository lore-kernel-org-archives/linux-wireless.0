Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59323 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab1CRUWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 16:22:54 -0400
Received: by iwn34 with SMTP id 34so4370073iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 13:22:53 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/5 v4] {mac|nl}80211: Support for SAE mesh authentication in userspace
Date: Fri, 18 Mar 2011 13:22:07 -0700
Message-Id: <1300479732-25920-1-git-send-email-javier@cozybit.com>
In-Reply-To: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for SAE authentication of mesh peers in userspace.  A
fork of wpa_supplicant that can authenticate mesh peers is available here:
https://github.com/cozybit/hostap-sae  .  Our intent is to work with hostap
maintainers to merge that functionality upstream soon.

A simpler daemon is also available here:  https://github.com/cozybit/authsae.

They both require the changes proposed in this series to operate.  Also, both
are based on the SAE reference implementation from Dan Harkins available here:
http://sourceforge.net/projects/authsae/

v2: (all suggested by Johannes)
 - Userspace actually creates the stations instead of setting the AUTH flag.
 - Fix hole that would allow peer links between secured and open peers.
 - Pass multiple IEs through generic IE nl80211 attribute
 - Remove SAE constant

v3: (again Johannes)
 - Fix API backward compatibilty of NL80211_MESH_SETUP_IE
 - Remove check for presence of RSN IE

v4: (also hinted by Johannes)
 - New peer event to avoid having to scan for mesh peer candidates
 - NEW_STATION command can also accept a PLINK_ACTION argument to
   trigger or block peer link establishment immediately after an authenticated
   station is created.

Javier Cardona (5):
  mac80211: Enable mesh security from userspace
  mac80211: Let user space receive and send mesh auth/deauth frames
  mac80211: Accept mesh auth frames before a peer link has been
    established
  mac80211: Let userspace create stations when mesh security is enabled
  mac80211: New notification to discover mesh peer candidates.

 include/linux/nl80211.h    |   27 +++++++++++++++++---
 include/net/cfg80211.h     |   39 +++++++++++++++++++++++++---
 net/mac80211/cfg.c         |   22 ++++++++++------
 net/mac80211/ieee80211_i.h |    5 ++-
 net/mac80211/main.c        |    4 ++-
 net/mac80211/mesh.c        |   14 ++++++----
 net/mac80211/mesh.h        |    3 +-
 net/mac80211/mesh_plink.c  |   35 ++++++++++++++++++++-----
 net/mac80211/rx.c          |    3 +-
 net/mac80211/tx.c          |    2 +-
 net/wireless/core.h        |    6 ++++
 net/wireless/mesh.c        |   46 ++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.c     |   60 +++++++++++++++++++++++++++++++++++++++----
 net/wireless/nl80211.h     |    4 +++
 net/wireless/util.c        |    5 +++
 15 files changed, 232 insertions(+), 43 deletions(-)

