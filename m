Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33018 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1KYBPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 20:15:33 -0500
Received: by iage36 with SMTP id e36so3749758iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 17:15:32 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 0/7] mesh fixes and improvements
Date: Thu, 24 Nov 2011 17:15:19 -0800
Message-Id: <1322183726-12436-1-git-send-email-thomas@cozybit.com> (sfid-20111125_021536_389466_D7239EE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains several (relatively minor) fixes and improvements for the
mesh stack. Chun-Yeow has also submitted a patch which adds the capability of
specifying a legacy rate for multicast frames in mesh, similar to what is
currently possible in IBSS. A follow-up patch for iw will be submitted
separately.

A couple of these will fail checpatch due to overstepping the 80 column limit,
but this is fixed in the final patch.

v2: mostly just style issues.

Chun-Yeow Yeoh (1):
  {nl,cfg,mac}80211: Allow Setting Multicast Rate in Mesh

Thomas Pedersen (6):
  mac80211: failed forwarded mesh frame addressing
  mac80211: fix switched HWMP frame addresses
  mac80211: fix forwarded mesh frame queue mapping
  {nl,cfg,mac}80211: implement dot11MeshHWMPperrMinInterval
  mac80211: don't initiate path discovery when forwarding frame with
    unknown DA
  mac80211: clean up rx_h_mesh_fwding

 include/linux/nl80211.h       |    5 ++
 include/net/cfg80211.h        |    3 +
 net/mac80211/cfg.c            |    9 +++
 net/mac80211/debugfs_netdev.c |    3 +
 net/mac80211/ieee80211_i.h    |    4 +-
 net/mac80211/iface.c          |   15 +----
 net/mac80211/mesh.c           |    1 +
 net/mac80211/mesh.h           |    2 +
 net/mac80211/mesh_hwmp.c      |  146 ++++++++++++++++++++++++-----------------
 net/mac80211/mesh_pathtbl.c   |   29 +--------
 net/mac80211/rx.c             |  105 +++++++++++++-----------------
 net/mac80211/tx.c             |    3 +-
 net/mac80211/wme.c            |   23 +++++++
 net/mac80211/wme.h            |    3 +
 net/wireless/mesh.c           |    2 +
 net/wireless/nl80211.c        |   11 +++
 16 files changed, 201 insertions(+), 163 deletions(-)

-- 
1.7.5.4

