Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55168 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752269AbdEPJXd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 05:23:33 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/7] extend mac80211 mesh DFS and CSA functionality
Date: Tue, 16 May 2017 11:23:09 +0200
Message-Id: <20170516092316.15636-1-sw@simonwunderlich.de> (sfid-20170516_112815_628375_A14C32EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds DFS and CSA functionality:

 * Mesh CSA is handled similary to IBSS, that means CSA will mark
   channels as unusable, and require userspace to handle actual
   radar signals
 * Add VHT processing for CSA in mesh mode, and some small cleanups

We have been working on this feature set for quite some time internally,
and I believe it is time to propose it for inclusion. I'll handle
any change requests to this patchset. :)

Cheers,
     Simon

Benjamin Berg (4):
  mac80211: Mark channel as unusable if a regulatory MESH CSA is
    received
  wireless: Only join DFS channels in mesh mode if userspace flags
    support
  wireless: Require HANDLE_DFS flag to switch channel for non-AP mode
  mac80211: Allow following CSA to DFS channels if userspace handles it

Simon Wunderlich (3):
  mac80211: add wide bandwidth channel switch announcement to CSA action
    frames and mesh beacons
  mac80211: enable VHT for mesh channel processing
  mac80211: mark as action frame when parsing IEs of CSA action frames

 include/net/cfg80211.h     |  4 +++
 net/mac80211/cfg.c         |  1 +
 net/mac80211/ieee80211_i.h |  5 +++
 net/mac80211/mesh.c        | 89 ++++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/spectmgmt.c   |  5 +++
 net/mac80211/util.c        | 40 +++++++++++++++++++++
 net/wireless/mesh.c        |  8 +++++
 net/wireless/nl80211.c     | 17 ++++++++-
 8 files changed, 161 insertions(+), 8 deletions(-)

-- 
2.11.0
