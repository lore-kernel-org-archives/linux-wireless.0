Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab0CKV5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:57:05 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: stable@kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] mac80211: stable fixes for UDP packet loss when enabling power save
Date: Thu, 11 Mar 2010 16:57:01 -0500
Message-Id: <1268344623-22076-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a few stable fixes for mac80211/ath9k which have already
been merged upstream. We forgot to add the stable tag on them
so sending these out manually. The patches address an issue of packet
loss when going into power save mode.

The patches in this series apply to the latest 2.6.33.y but for
your convenience I have also backported the patches to the latest
2.6.32.y kernel.

The 2.6.33.y patches can be found here:

http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010-03/33-fixes/02-mac80211-udp-ps-issue/

The 2.6.32.y patches can be found here:

http://kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010-03/32-fixes/02-mac80211-udp-ps-issue/

Vivek Natarajan (2):
  mac80211: Retry null data frame for power save
  ath9k: Enable IEEE80211_HW_REPORTS_TX_ACK_STATUS flag for ath9k

 drivers/net/wireless/ath/ath9k/main.c |    1 +
 include/net/mac80211.h                |    4 ++++
 net/mac80211/ieee80211_i.h            |    1 +
 net/mac80211/mlme.c                   |   20 +++++++++++++++-----
 net/mac80211/status.c                 |   17 +++++++++++++++--
 5 files changed, 36 insertions(+), 7 deletions(-)

