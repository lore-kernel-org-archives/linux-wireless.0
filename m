Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759486AbZFIIaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 04:30:12 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] ath9k: rate fix for invalid frames
Date: Tue,  9 Jun 2009 04:30:08 -0400
Message-Id: <1244536211-22535-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've tried a few things to find the real root cause to
the ath9k rate control assert. This is it, turns out we
make some assumptions about scanning and nullfunc frames.
We fix those assumptions here.

I'll send the ath9k rate control cleanup stuff later
though, all of that is still valid.

I think the iwlwifi rate control work arounds could be removed
now though but not sure, I saw in the bug report the get_rate
warn on was found during disassoc or something like that which
I cannot see being triggerable by the conditions found in these
patches unless iwlwifi is getting frames through some other
uknown mean.

Luis R. Rodriguez (3):
  mac80211: fix - drop frames for sta with no valid rate
  mac80211: add debugfs counter for not valid birate frames
  ath9k: downgrade assert in rc.c for invalid rate

 drivers/net/wireless/ath/ath9k/rc.c |   16 ++++++++++---
 include/net/mac80211.h              |   11 +++++++++
 net/mac80211/debugfs.c              |    4 +++
 net/mac80211/ieee80211_i.h          |    2 +
 net/mac80211/tx.c                   |   39 +++++++++++++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 4 deletions(-)

