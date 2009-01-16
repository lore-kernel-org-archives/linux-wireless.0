Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11684 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZAPAW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 19:22:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 16:22:59 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: simplify regulatory code
Date: Thu, 15 Jan 2009 16:22:31 -0800
Message-ID: <1232065351-17780-1-git-send-email-lrodriguez@atheros.com> (sfid-20090116_012304_252793_3671A046)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that cfg80211 has its own regulatory infrastructure we can
condense ath9k's regulatory code considerably. We only keep data
we need to provide our own regulatory_hint(), reg_notifier() and
information necessary for calibration.

Atheros hardware supports 12 world regulatory domains, since these
are custom we apply them through the the new wiphy_apply_custom_regulatory().
Although we have 12 we can consolidate these into 5 structures based on
frequency and apply a different set of flags that differentiate them on
a case by case basis through the reg_notifier().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This patch seems to be too big (136665 bytes) for linux-wireless so
here a URL to it if you want to wget it:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-01-16/0001-ath9k-reg-cleanup.patch

This patch should be applied once the 13 patches from the new series
"cfg80211/mac80211: fixes/enhancements for reg_notifier()" have been
merged as it depends on a few new cfg80211 helpers from there.

 drivers/net/wireless/ath9k/ath9k.h       |   41 +-
 drivers/net/wireless/ath9k/calib.c       |   41 +-
 drivers/net/wireless/ath9k/core.h        |    1 -
 drivers/net/wireless/ath9k/hw.c          |   63 +-
 drivers/net/wireless/ath9k/main.c        |  250 ++--
 drivers/net/wireless/ath9k/regd.c        | 1191 +++++-------------
 drivers/net/wireless/ath9k/regd.h        |  181 +---
 drivers/net/wireless/ath9k/regd_common.h | 2058 +++++-------------------------
 8 files changed, 794 insertions(+), 3032 deletions(-)

