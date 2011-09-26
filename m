Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44884 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1IZKzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 06:55:01 -0400
Received: by eya28 with SMTP id 28so3462643eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 03:55:00 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 0/5] TDLS support for nl80211/mac80211 drivers
Date: Mon, 26 Sep 2011 13:54:48 +0300
Message-Id: <1317034493-5300-1-git-send-email-arik@wizery.com> (sfid-20110926_125506_704623_086A369D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds basic kernel-mode TDLS support for nl80211 based drivers.
It is based in part on patches by Kalyan C. Gaddam, cc-ed here.

Support is added for peer discovery and data path setup/teardown.
Currently not implemented: QoS/HT, peer PSM, peer U-APSD and channel
switching.

The main change from the RFC series is the addition of a Tx block
during link setup. In the new scheme of things, a STA entry is added
just before setting up a link. This allows us to throw out frames
sent to a peer while the link is being set up. This is required by
the specification, to avoid reordering of MSDUs.

User-mode support is added in a companion series.

Tested with wl12xx hardware, with a nl80211/mac80211 based driver.

Arik

Cc: Kalyan C Gaddam <chakkal@iit.edu>

Arik Nemtsov (5):
  nl80211: support sending TDLS commands/frames
  mac80211: standardize adding supported rates IEs
  mac80211: handle TDLS high-level commands and frames
  nl80211/mac80211: allow adding TDLS peers as stations
  mac80211: data path modification for TDLS peers

 include/linux/ieee80211.h |   85 ++++++++++++
 include/linux/if_ether.h  |    1 +
 include/linux/nl80211.h   |   48 +++++++
 include/net/cfg80211.h    |   17 +++
 include/net/mac80211.h    |    5 +
 net/mac80211/Kconfig      |   12 ++
 net/mac80211/cfg.c        |  335 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/main.c       |    4 +
 net/mac80211/mesh.c       |   58 --------
 net/mac80211/mesh.h       |    4 -
 net/mac80211/mesh_plink.c |    4 +-
 net/mac80211/mlme.c       |    7 +-
 net/mac80211/sta_info.h   |    5 +
 net/mac80211/tx.c         |   46 ++++++-
 net/mac80211/util.c       |   59 ++++++++
 net/wireless/nl80211.c    |   97 ++++++++++++-
 net/wireless/util.c       |    5 +-
 17 files changed, 711 insertions(+), 81 deletions(-)

-- 
1.7.4.1

