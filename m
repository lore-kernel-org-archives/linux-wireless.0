Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34386 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbaIDV5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 17:57:45 -0400
Received: by mail-wg0-f51.google.com with SMTP id l18so10824181wgh.22
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 14:57:44 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCHv5 0/2] configure dynack through mac80211/cfg80211 stack
Date: Thu,  4 Sep 2014 23:57:39 +0200
Message-Id: <1409867861-3911-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140904_235751_802222_CEDD8DF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable ACK timeout estimation algorithm (dynack) using mac80211
set_coverage_class API. Dynack is activated passing -1 as coverage class
to lower drivers and it is automatically disabled setting valid value for
coverage class. Currently dynack is supported just by ath9k.
Fix set_coverage_class signature for p54, ath9k, ath9k_htc and ath5k drivers.

Changes since v4:
- improve documentation

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
 include/net/mac80211.h                        |  6 ++++--
 include/uapi/linux/nl80211.h                  | 12 ++++++++++++
 net/mac80211/cfg.c                            |  9 +++++++--
 net/mac80211/driver-ops.h                     |  2 +-
 net/mac80211/trace.h                          |  4 ++--
 net/wireless/nl80211.c                        | 11 +++++++++++
 11 files changed, 45 insertions(+), 11 deletions(-)

-- 
1.9.1

