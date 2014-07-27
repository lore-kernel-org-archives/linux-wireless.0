Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:48121 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaG0Vgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2014 17:36:54 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so6496252wev.13
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2014 14:36:52 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCHv3 0/6] configure dynack through mac80211/cfg80211 stack
Date: Sun, 27 Jul 2014 23:36:46 +0200
Message-Id: <1406497008-25383-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140727_233658_005044_F3E9B173)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend set_coverage_class API in order to enable ACK timeout estimation
algorithm (dynack) passing coverage_class equals to -1 to lower drivers.
Currently dynack is supported just by ath9k.
Fix set_coverage_class signature for p54, ath9k, ath9k_htc and ath5k drivers.

Changes since v2:
- add set_coverage_class signature fix to patchset
- define NL80211_FEATURE_ACKTO_ESTIMATION to report driver dynack capability
- reject configuration if both NL80211_ATTR_WIPHY_COVERAGE_CLASS and
  NL80211_ATTR_WIPHY_DYN_ACK are given

Changes since v1:
- extend set_coverage_class signature insted of define enable_dynack API

Lorenzo Bianconi (6):
  cfg80211: enable dynack through nl80211
  mac80211: extend set_coverage_class signature
  p54: extend p54_set_coverage_class signature
  ath5k: extend ath5k_set_coverage_class signature
  ath9k_htc: extend ath9k_htc_set_coverage_class signature
  ath9k: extend ath9k_set_coverage_class signature

 drivers/net/wireless/ath/ath5k/mac80211-ops.c |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  2 +-
 drivers/net/wireless/ath/ath9k/main.c         |  3 ++-
 drivers/net/wireless/p54/main.c               |  3 ++-
 include/net/cfg80211.h                        |  2 ++
 include/net/mac80211.h                        |  5 +++--
 include/uapi/linux/nl80211.h                  |  8 ++++++++
 net/mac80211/cfg.c                            |  9 +++++++--
 net/mac80211/driver-ops.h                     |  2 +-
 net/mac80211/trace.h                          |  4 ++--
 net/wireless/nl80211.c                        | 11 +++++++++++
 11 files changed, 40 insertions(+), 11 deletions(-)

-- 
1.9.1

