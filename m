Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33598 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbbGCTmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 15:42:15 -0400
Received: by igcur8 with SMTP id ur8so150520446igc.0
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jul 2015 12:42:15 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v2 0/3] Mesh AID fixes
Date: Fri,  3 Jul 2015 15:41:09 -0400
Message-Id: <1435952472-22752-1-git-send-email-me@bobcopeland.com> (sfid-20150703_214231_397224_2732155C)
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

v2: dynamically create the bitmap on demand rather than maintain it

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

