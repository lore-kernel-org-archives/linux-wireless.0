Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46291 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3JBICv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 04:02:51 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so537620pbb.20
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 01:02:51 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v2 0/5] Add Mesh Channel Switch Support
Date: Wed,  2 Oct 2013 01:02:39 -0700
Message-Id: <1380700964-844-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131002_100256_361794_9DAD3478)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are the patches required to support Mesh Basic Service Set (MBSS)
channel switch.

The design is more or less same with the IBSS. Additional procedures
or elements that are required for mesh operation are as follow:
 * Add additional information element (IE) known as Mesh Channel Switch
   Parameters (MCSP) required in CSA action, beacon and probe response 
   frames.
 * Forwarding of CSA frame if the conditions defined in the standard 
   are met.

Limitations:
 * Channel switch is only allow for the same band and also same channel
   width from the previous setting.

These patches are reviewed and commented by Bob Copeland, Thomas Pedersen
and Johannes Berg. Any further comments are welcomed.

Chun-Yeow Yeoh (5):
  mac80211: process the CSA frame for mesh accordingly
  {nl,cfg,mac}80211: enable the triggering of CSA frame in mesh
  mac80211: add the CSA and MCSP elements in mesh beaconing
  {nl,cfg,mac}80211: finalizing mesh channel switching
  mac80211: process mesh channel switching using beacon

 include/linux/ieee80211.h  |   20 +++
 include/net/cfg80211.h     |    4 +
 net/mac80211/Kconfig       |   11 ++
 net/mac80211/cfg.c         |   24 ++++
 net/mac80211/debug.h       |   10 ++
 net/mac80211/ibss.c        |   60 +--------
 net/mac80211/ieee80211_i.h |   21 +++-
 net/mac80211/mesh.c        |  289 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mlme.c        |   30 +++--
 net/mac80211/rx.c          |    5 +-
 net/mac80211/spectmgmt.c   |   33 +++--
 net/mac80211/tx.c          |   16 +++
 net/mac80211/util.c        |   96 +++++++++++++++
 net/wireless/nl80211.c     |    4 +-
 14 files changed, 526 insertions(+), 97 deletions(-)

-- 
1.7.9.5

