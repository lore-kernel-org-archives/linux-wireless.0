Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:36034 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1CEBZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 20:25:16 -0500
Received: by pxi15 with SMTP id 15so417937pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 17:25:15 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/4 v2] {mac|nl}80211: Support for SAE mesh authentication in userspace
Date: Fri,  4 Mar 2011 17:24:08 -0800
Message-Id: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

This series adds the capability to authenticate and manage stations from userspace.

Changes from v1: (all suggested by Johannes)
 - Userspace actually creates the stations instead of setting the AUTH flag.
 - Fix hole that would allow peer links between secured and open peers.
 - Pass multiple IEs through generic IE nl80211 attribute
 - Remove SAE constant

Javier Cardona (4):
  mac80211: Enable mesh security from userspace
  mac80211: Let user space receive and send mesh auth/deauth frames
  mac80211: Accept mesh auth frames before a peer link has been
    established
  mac80211: Let userspace create stations when mesh security is enabled

 include/linux/nl80211.h    |   13 +++++++++----
 include/net/cfg80211.h     |   10 ++++++----
 net/mac80211/cfg.c         |   16 ++++++++--------
 net/mac80211/ieee80211_i.h |    5 +++--
 net/mac80211/main.c        |    4 +++-
 net/mac80211/mesh.c        |   10 +++++++---
 net/mac80211/mesh_plink.c  |   13 +++++++++----
 net/mac80211/rx.c          |    3 ++-
 net/mac80211/tx.c          |    2 +-
 net/wireless/mesh.c        |    5 +++--
 net/wireless/nl80211.c     |   40 +++++++++++++++++++++++++++++++++++-----
 11 files changed, 86 insertions(+), 35 deletions(-)

