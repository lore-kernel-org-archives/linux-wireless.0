Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0INFaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 01:30:39 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/10] ath9k / mac80211: power save fixes
Date: Tue, 14 Sep 2010 01:30:27 -0400
Message-Id: <1284442237-24425-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a bundle of joy of fixes for power save. Some of
these are regressions, which sucks ass to find out about them
so late. We *really* need a regression testbed for mac80211 and
ath9k. Some stable fixes trickle down to 2.6.32 even.

I'll soon send links for the respective ports of these patches to each
kernels. For now I'd just like them merged upstream and ensure we get
this out for 2.6.36-rc stuff.

The offchannel needs more work to be really useful, for example
we should just be sending nullunc frames prior to actualloy probing
the AP. We can work on this later for 37.

Luis R. Rodriguez (9):
  ath9k: fix power save race conditions
  ath9k: fix regression on beacon loss after bgscan
  mac80211: add helper for reseting the connection monitor
  mac80211: reset probe send counter upon connection timer reset
  mac80211: reset connection idle when going offchannel
  mac80211: make the beacon monitor available externally
  mac80211: disable beacon monitor while going offchannel
  mac80211: send last 3/5 probe requests as unicast
  ath9k: fix regression which disabled ps on ath9k

Senthil Balasubramanian (1):
  ath9k: fix regression which prevents chip sleep after CAB data

 drivers/net/wireless/ath/ath9k/init.c |    3 +-
 drivers/net/wireless/ath/ath9k/main.c |   11 ++++++--
 drivers/net/wireless/ath/ath9k/recv.c |    5 +++-
 net/mac80211/ieee80211_i.h            |    2 +
 net/mac80211/mlme.c                   |   40 +++++++++++++++++++++++---------
 net/mac80211/offchannel.c             |    7 +++++
 6 files changed, 52 insertions(+), 16 deletions(-)

