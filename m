Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43238 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbZAVXRY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:17:24 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:17:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: simplify regulatory code
Date: Thu, 22 Jan 2009 15:16:48 -0800
Message-ID: <1232666208-26925-1-git-send-email-lrodriguez@atheros.com> (sfid-20090123_001729_771049_09786969)
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

If CRDA is not found our own custom world regulatory domain is applied,
this is identical to cfg80211's except we enable passive scan on most
frequencies.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This patch seems to be too big (137783 bytes) for linux-wireless so
here a URL to it if you want to wget it:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-01-22/ath9k-simplify-regulatory-code.patch

This patch should be applied once the 12 patches from the new series
"cfg80211/mac80211: few fixes/enhancements for regulatory" have been
merged as it depends on a few new cfg80211 helpers from there.

 drivers/net/wireless/ath9k/ath9k.h       |   44 +-
 drivers/net/wireless/ath9k/calib.c       |   41 +-
 drivers/net/wireless/ath9k/core.h        |    1 -
 drivers/net/wireless/ath9k/hw.c          |   63 +-
 drivers/net/wireless/ath9k/main.c        |  263 ++--
 drivers/net/wireless/ath9k/regd.c        | 1188 +++++-------------
 drivers/net/wireless/ath9k/regd.h        |  181 +---
 drivers/net/wireless/ath9k/regd_common.h | 2058 +++++-------------------------
 8 files changed, 809 insertions(+), 3030 deletions(-)

