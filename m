Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56745 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1IOKZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 06:25:43 -0400
Received: by eya28 with SMTP id 28so242197eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 03:25:42 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [RFC 0/5] TDLS support for nl80211/mac80211 drivers
Date: Thu, 15 Sep 2011 13:25:29 +0300
Message-Id: <1316082334-7664-1-git-send-email-arik@wizery.com> (sfid-20110915_122546_760971_6A6DA1DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds basic kernel-mode TDLS support for nl80211 based drivers.
It is based in part on patches by Kalyan C. Gaddam, cc-ed here.

Support is added for peer discovery and data path setup/teardown. More
advanced features are not implemented. These include QoS/HT, peer PSM,
peer U-APSD and channel switching.

Notably, this patch-set does not include locking in the data path,
to switch between AP-based and direct Tx during link setup/tear-down.
This will be added by a later patch-set, if/when this series is
accepted. In practice it seems to work quite well without additional
locking.

User-mode support is added in a companion series.

Tested with wl12xx hardware, with a nl80211/mac80211 based driver.

Comments/reviews are welcome.

Arik

Cc: Kalyan C Gaddam <chakkal@iit.edu>

Arik Nemtsov (5):
  nl80211: support sending TDLS commands/frames
  mac80211: handle TDLS high-level commands and frames
  nl80211/mac80211: allow adding TDLS peers as stations
  mac80211: add a HW flag for TDLS support
  mac80211: send data directly to TDLS peers

 include/linux/ieee80211.h |   75 +++++++++
 include/linux/if_ether.h  |    1 +
 include/linux/nl80211.h   |   40 +++++
 include/net/cfg80211.h    |    9 +
 include/net/mac80211.h    |    4 +
 net/mac80211/Kconfig      |   12 ++
 net/mac80211/cfg.c        |  383 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h   |    4 +
 net/mac80211/tx.c         |   24 +++-
 net/wireless/nl80211.c    |   73 +++++++++-
 net/wireless/util.c       |    5 +-
 11 files changed, 623 insertions(+), 7 deletions(-)

-- 
1.7.4.1

