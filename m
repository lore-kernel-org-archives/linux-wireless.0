Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33040 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbGBN2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 09:28:55 -0400
Received: by igcur8 with SMTP id ur8so118565107igc.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 06:28:54 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/3] Mesh AID fixes
Date: Thu,  2 Jul 2015 09:28:07 -0400
Message-Id: <1435843690-2856-1-git-send-email-me@bobcopeland.com> (sfid-20150702_152900_551051_973DC858)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset corrects the use of peer link id as a stand-in for the
association ID, which is at odds with the standard.  Using an incremental
AID generated on the local sta whenever a peer is added enables smaller
TIM elements, and removes one possible source of ambiguity when plids
collide.

Using a proper aid also will make it easier to implement mesh on ath10k.

Because mac80211 currently only implements the buffering side of mesh
power save, we don't need to change any code that reads the AID from
confirm frames.  Which is good because it was previously always wrong.

Bob Copeland (3):
  mac80211: reorder mesh_plink to remove forward decl
  mac80211: mesh: separate plid and aid concepts
  mac80211: select an AID when creating new mesh STAs

 net/mac80211/cfg.c         |   3 +
 net/mac80211/ieee80211_i.h |   1 +
 net/mac80211/mesh.c        |   7 +++
 net/mac80211/mesh_plink.c  | 147 +++++++++++++++++++++++++--------------------
 net/mac80211/sta_info.c    |   5 +-
 5 files changed, 94 insertions(+), 69 deletions(-)

-- 
2.1.4

