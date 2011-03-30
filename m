Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55395 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab1C3DGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 23:06:45 -0400
Received: by gxk21 with SMTP id 21so357019gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 20:06:45 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v5 00/10] {mac|nl}80211: Support for SAE mesh authentication in userspace 
Date: Tue, 29 Mar 2011 19:05:57 -0700
Message-Id: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for mesh authentication in userspace.

changes in v5:
- don't schedule new peer notifications (Johannes)
- add mesh capabilities attribute for forward compatibility. 
- refactoring

Javier Cardona (9):
  nl80211: rename NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE
  nl80211: Add userspace authentication  flag to mesh setup
  mac80211: ignore peers if security is enabled for this mesh
  nl80211: let userspace authenticate stations
  mac80211: Let user space receive and send mesh auth/deauth frames
  mac80211: ignore peer link requests from unauthenticated stations.
  mac80211: Perform PLINK_ACTION on new station
  nl80211: New notification to discover mesh peer candidates.
  mac80211: send notification on new peer candidate for our secure mesh

Thomas Pedersen (1):
  nl80211: return mesh capabilities

 include/linux/nl80211.h    |   53 ++++++++++++++++++++++++++--
 include/net/cfg80211.h     |   39 +++++++++++++++++++--
 net/mac80211/cfg.c         |   22 +++++++----
 net/mac80211/ieee80211_i.h |    5 ++-
 net/mac80211/main.c        |    4 ++-
 net/mac80211/mesh.c        |   14 ++++---
 net/mac80211/mesh.h        |    3 +-
 net/mac80211/mesh_plink.c  |   35 +++++++++++++++----
 net/mac80211/rx.c          |    3 +-
 net/mac80211/tx.c          |    2 +-
 net/wireless/core.h        |    5 +++
 net/wireless/mesh.c        |   19 +++++++++-
 net/wireless/nl80211.c     |   81 ++++++++++++++++++++++++++++++++++++++-----
 net/wireless/nl80211.h     |    4 ++
 14 files changed, 242 insertions(+), 47 deletions(-)

-- 
1.7.4.1

