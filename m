Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42939 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3JOCIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 22:08:52 -0400
Received: by mail-pa0-f47.google.com with SMTP id kp14so8274669pab.6
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 19:08:51 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v5 0/5]  Add Mesh Channel Switch Support
Date: Mon, 14 Oct 2013 19:08:26 -0700
Message-Id: <1381802911-3921-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131015_040907_592076_7CA2F911)
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
 * Channel switch is only allowed for the same band and also same channel
   width from the previous setting.

These patches are reviewed and commented by Bob Copeland, Thomas Pedersen
and Johannes Berg. Jean-Pierre has also commented on typos error. Any
further comments are welcomed.

These patches also include refactoring the ieee80211_parse_ch_switch_ie to
reduce the number of function parameters.

Testing:
The patches are tested using ath9k.

Chun-Yeow Yeoh (5):
  mac80211: process the CSA frame for mesh accordingly
  {nl,cfg,mac}80211: enable the triggering of CSA frame in mesh
  mac80211: refactor the parsing of chan switch ie
  {nl,cfg,mac}80211: implement mesh channel switch userspace API
  mac80211: process mesh channel switching using beacon

 include/linux/ieee80211.h  |   20 +++
 net/mac80211/Kconfig       |   11 ++
 net/mac80211/cfg.c         |   24 ++++
 net/mac80211/debug.h       |   10 ++
 net/mac80211/ibss.c        |   67 ++--------
 net/mac80211/ieee80211_i.h |   34 +++++-
 net/mac80211/mesh.c        |  292 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mlme.c        |   32 +++--
 net/mac80211/rx.c          |    5 +-
 net/mac80211/spectmgmt.c   |   33 +++--
 net/mac80211/tx.c          |   16 +++
 net/mac80211/util.c        |   96 +++++++++++++++
 net/wireless/nl80211.c     |    4 +-
 13 files changed, 544 insertions(+), 100 deletions(-)

-- 
1.7.9.5

