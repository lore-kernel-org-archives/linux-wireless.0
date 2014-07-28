Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55886 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaG1OCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 10:02:33 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so4454544wib.16
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2014 07:02:29 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCHv4 0/2] configure dynack through mac80211/cfg80211 stack
Date: Mon, 28 Jul 2014 16:02:26 +0200
Message-Id: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140728_160239_380936_F97F5CFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend set_coverage_class API in order to enable ACK timeout estimation
algorithm (dynack) passing coverage_class equals to -1 to lower drivers.
Currently dynack is supported just by ath9k.
Fix set_coverage_class signature for p54, ath9k, ath9k_htc and ath5k drivers.

Changes since v3:
- squash driver patches and mac80211 one

Changes since v2:
- add set_coverage_class signature fix to patchset
- define NL80211_FEATURE_ACKTO_ESTIMATION to report driver dynack capability
- reject configuration if both NL80211_ATTR_WIPHY_COVERAGE_CLASS and
  NL80211_ATTR_WIPHY_DYN_ACK are given

Changes since v1:
- extend set_coverage_class signature insted of define enable_dynack API

Lorenzo Bianconi (2):
  cfg80211: enable dynack through nl80211
  mac80211: extend set_coverage_class signature

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

