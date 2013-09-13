Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56458 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3IMXgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 19:36:24 -0400
Received: by mail-pd0-f175.google.com with SMTP id q10so1847854pdj.6
        for <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2013 16:36:24 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH 0/5] Add Mesh Channel Switch Support
Date: Fri, 13 Sep 2013 16:36:07 -0700
Message-Id: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130914_013628_869968_DA230C8D)
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

These patches are reviewed and commented by Bob Copeland and Thomas 
Pedersen. Any further comments are welcomed.

Chun-Yeow Yeoh (5):
  mac80211: process the CSA frame for mesh accordingly
  {nl,cfg,mac}80211: enable the triggering of CSA frame in mesh
  mac80211: adding the CSA and MCSP elements in mesh beaconing
  {nl,cfg,mac}80211: finalizing mesh channel switching
  mac80211: process mesh channel switching using beacon

 include/linux/ieee80211.h  |   20 ++++
 net/mac80211/Kconfig       |   11 ++
 net/mac80211/cfg.c         |   24 ++++
 net/mac80211/debug.h       |   10 ++
 net/mac80211/ibss.c        |   58 +--------
 net/mac80211/ieee80211_i.h |   14 +++
 net/mac80211/mesh.c        |  284 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mlme.c        |    4 +-
 net/mac80211/rx.c          |    5 +-
 net/mac80211/spectmgmt.c   |    8 +-
 net/mac80211/tx.c          |   16 +++
 net/mac80211/util.c        |   97 +++++++++++++++
 net/wireless/nl80211.c     |    4 +-
 13 files changed, 491 insertions(+), 64 deletions(-)

-- 
1.7.9.5

