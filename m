Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21102 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZAMUVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 15:21:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 12:21:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: simplify regulatory code
Date: Tue, 13 Jan 2009 12:20:42 -0800
Message-ID: <1231878042-21799-1-git-send-email-lrodriguez@atheros.com> (sfid-20090113_212112_675180_4F7695D3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that cfg80211 has its own regulatory infrastructure we can
condense ath9k's regulatory code considerably. We only keep data
we need to provide our own regulatory_hint(), regulatory_set_custom_rd(),
reg_notifier() and information necessary for calibration.

Atheros hardware supports 12 world regulatory domains, since these
are custom we apply them through the the new regulatory_set_custom_rd().
Although we have 12 we consolidate these into 5 structures based on
frequency and apply a different set of flags that differentiate them
on a case by case basis through the reg_notifier().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This patch seems to be too big (135653 bytes) for linux-wireless so
here a URL to it if you want to wget it:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-01-13/0001-ath9k-simplify-regulatory-code.patch

This patch should be applied once the 12 patches from my series
"cfg80211/mac80211: fixes/enhancements for reg_notifier()" have been
merged as it depends on a few new cfg80211 helpers from there.

 drivers/net/wireless/ath9k/ath9k.h       |   41 +-
 drivers/net/wireless/ath9k/calib.c       |   41 +-
 drivers/net/wireless/ath9k/core.h        |    1 -
 drivers/net/wireless/ath9k/hw.c          |   63 +-
 drivers/net/wireless/ath9k/main.c        |  248 ++--
 drivers/net/wireless/ath9k/regd.c        | 1164 +++++-------------
 drivers/net/wireless/ath9k/regd.h        |  181 +---
 drivers/net/wireless/ath9k/regd_common.h | 2058 +++++-------------------------
 8 files changed, 761 insertions(+), 3036 deletions(-)
