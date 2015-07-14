Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36648 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbbGNMcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 08:32:15 -0400
Received: by igbij6 with SMTP id ij6so44850471igb.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2015 05:32:14 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 0/5] mesh AID fixes
Date: Tue, 14 Jul 2015 08:31:54 -0400
Message-Id: <1436877119-17577-1-git-send-email-me@bobcopeland.com> (sfid-20150714_143222_468227_17AB0939)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset removes usage of peer link ID as a stand-in for
AID, in order to follow the standard in this regard.

This revision gained two patches: one was an existing bugfix that
was buried in a reorg patch, and the other is a fix for a missing
length check found while reviewing the code.

Bob Copeland (5):
  mac80211: correct aid location in peering frames
  mac80211: add missing length check for confirm frames
  mac80211: reorder mesh_plink to remove forward decl
  mac80211: mesh: separate plid and aid concepts
  mac80211: select an AID when creating new mesh STAs

 net/mac80211/mesh_plink.c | 172 ++++++++++++++++++++++++++++------------------
 net/mac80211/mesh_ps.c    |   2 +-
 net/mac80211/sta_info.c   |   5 +-
 net/mac80211/sta_info.h   |   2 +
 4 files changed, 108 insertions(+), 73 deletions(-)

-- 
2.1.4

