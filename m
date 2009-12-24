Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZLXBDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 20:03:30 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] Few mac80211 and ath9k suspend fixes
Date: Wed, 23 Dec 2009 20:03:24 -0500
Message-Id: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, here are a few fixes for suspend for both mac80211
and ath9k. I'd like to wait for Johanne's ack on both
mac80211 fixes, the ath9k patches don't depend on those
two fixes so they can be merged separately.

The all-in-one patch for wireless-testing is available at:

http://bombadil.infradead.org/~mcgrof/patches/wireless-testing/2009/12/pm-fixes-2009-12-23.patch

Individual backported patches to test against upstream 2.6.32 are available at:

http://kernel.org/pub/linux/kernel/people/mcgrof/patches/var/2009/12/pm-fixes-32-pending/

The upstream commit are pending on the commit logs there.

For those still on 2.6.32, I still recommend to apply:

mac80211: fix WMM AP settings application
mac80211: fix resume

You can get these here:

http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0001-mac80211-fix-resume.patch
http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0002-mac80211-fix-WMM-AP-settings-application.patch

These two likely have their respective upstream sha1sum already, not sure.

Luis R. Rodriguez (4):
  mac80211: fix race with suspend and dynamic_ps_disable_work
  mac80211: fix propagation of failed hardware reconfigurations
  ath9k: wake hardware for interface IBSS/AP/Mesh removal
  ath9k: wake hardware during AMPDU TX actions

Sujith (1):
  ath9k: fix suspend by waking device prior to stop

 drivers/net/wireless/ath/ath9k/main.c |   14 ++++++++++++++
 net/mac80211/tx.c                     |    4 ++++
 net/mac80211/util.c                   |   12 ++++++++++++
 3 files changed, 30 insertions(+), 0 deletions(-)

