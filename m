Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47676 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3JOAmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 20:42:17 -0400
Received: by mail-pb0-f53.google.com with SMTP id up15so8039978pbc.12
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 17:42:16 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/6] ath / ath9k updates
Date: Mon, 14 Oct 2013 17:42:05 -0700
Message-Id: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131015_024220_672477_9EF8DDED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, Johannes,

here are a few ath / ath9k updates. The dynamic regulatory domain setting
feature requires the cfg80211 reg_initiator_name() patch applied so not
sure how you want to deal with this dependency. Should John just merged
that change?

Luis R. Rodriguez (6):
  cfg80211: export reg_initiator_name()
  ath: move common dynamic regulatory domain setting to a helper
  ath: split user and driver reguluatory hint parsing
  ath: add support for proper dynamic regulatory hints
  ath9k: check for NULL rate when using ieee80211_get_rts_cts_rate()
  ath9k: add TX99 support

 drivers/net/wireless/ath/Kconfig            |  17 +++
 drivers/net/wireless/ath/ath9k/Kconfig      |  20 ++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |  22 ++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  95 +++++++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h      |  10 ++
 drivers/net/wireless/ath/ath9k/debug.c      | 118 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw-ops.h     |  16 +++
 drivers/net/wireless/ath/ath9k/hw.h         |   4 +
 drivers/net/wireless/ath/ath9k/init.c       |  26 ++---
 drivers/net/wireless/ath/ath9k/link.c       |  12 ++-
 drivers/net/wireless/ath/ath9k/main.c       | 160 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/recv.c       |   3 +
 drivers/net/wireless/ath/ath9k/xmit.c       |  56 +++++++++-
 drivers/net/wireless/ath/regd.c             | 140 ++++++++++++++++++++----
 include/net/cfg80211.h                      |   9 ++
 net/wireless/reg.c                          |  27 +++--
 16 files changed, 690 insertions(+), 45 deletions(-)

-- 
1.8.4.rc3

