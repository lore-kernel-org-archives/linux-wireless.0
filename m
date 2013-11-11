Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42598 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3KKVPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 16:15:35 -0500
Received: by mail-wi0-f174.google.com with SMTP id cb5so2780948wib.7
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 13:15:34 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/3] cfg80211: add reguatory flags
Date: Mon, 11 Nov 2013 22:15:28 +0100
Message-Id: <1384204531-10025-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131111_221555_588765_414651EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is based on Mihir's unfinished work, it addresses
Johannes' comments. John, Johannes, you guys pick who this
goes through, I've based it on Johannes' mac80211-next as
it touches on regulatory and I had tons of changes already
merged. I've provided SmPL grammar in case of merge
conclicts.

Luis R. Rodriguez (3):
  cfg80211: move regulatory flags to their own variable
  cfg80211: add flags to define country IE processing rules
  cfg80211: add an option to disable processing country IEs

 drivers/net/wireless/ath/regd.c                    |  5 ++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  2 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |  4 +-
 drivers/net/wireless/iwlegacy/3945-mac.c           |  6 +--
 drivers/net/wireless/iwlegacy/4965-mac.c           |  6 +--
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  6 +--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  6 +--
 drivers/net/wireless/mac80211_hwsim.c              | 18 ++++----
 drivers/net/wireless/mwifiex/cfg80211.c            |  5 ++-
 drivers/net/wireless/rtlwifi/regd.c                |  6 +--
 include/net/cfg80211.h                             | 33 +++-----------
 include/net/regulatory.h                           | 50 ++++++++++++++++++++++
 net/wireless/core.c                                |  2 +-
 net/wireless/reg.c                                 | 37 ++++++++--------
 14 files changed, 109 insertions(+), 77 deletions(-)

-- 
1.8.4.rc3

