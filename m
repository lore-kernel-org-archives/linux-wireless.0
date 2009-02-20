Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZBTGE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 01:04:56 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	marcel@holtmann.org, kalle.valo@nokia.com, kyle@mcmartin.ca
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] cfg80211: enhance world roaming
Date: Fri, 20 Feb 2009 01:04:29 -0500
Message-Id: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com> (sfid-20090220_070502_710293_909BAE1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series enhances world roaming through a few set of
enhancements. We world roam when OLD_REG is disabled and
CRDA _is_ installed and when we have had no regulatory
hint from anything yet (country IE, userspace, or driver).
If you lack CRDA and you also have OLD_REG you also world roam. 

We finish this work by defaulting OLD_REG to no due to these
new changes. At this point I'd even be inclined to simply remove
OLD_REG, your comments are greatly welcomed on this.

This patch series *should not* be applied yet as it breaks Intel's
iwlwifi drivers as noted in my recent e-mail about this [1]. Once that
is fixed this should be ready.

This series depends on the last one I just posted. If you'd like to
test you can get all the patches in one file in my home dir, it will
contain my 15 patches from my previous series and the patches from
this new series [2].

[1] http://marc.info/?l=linux-wireless&m=123510494021757&w=2
[2] http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/cfg80211/2009-02-20/all-reg.patch

Luis R. Rodriguez (5):
  cfg80211: enable active-scan / beaconing on Ch 1-11 for world regdom
  cfg80211: enable 5 GHz world roaming channels
  cfg80211: Add AP beacon regulatory hints
  ath9k: follow beacon hints on reg_notifier when world roaming
  cfg80211: default OLD_REG to n

 Documentation/feature-removal-schedule.txt |    5 +-
 drivers/net/wireless/ath9k/regd.c          |   93 +++++++----
 include/net/wireless.h                     |   21 +++
 net/wireless/Kconfig                       |    2 +-
 net/wireless/core.c                        |    5 +-
 net/wireless/reg.c                         |  240 +++++++++++++++++++++++++++-
 net/wireless/scan.c                        |    3 +
 7 files changed, 329 insertions(+), 40 deletions(-)

