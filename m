Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:41185 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaGXKjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:39:25 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so2574663wes.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 03:39:24 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCHv2 0/2] configure dynack through mac80211 stack
Date: Thu, 24 Jul 2014 12:39:20 +0200
Message-Id: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140724_123929_253234_BDD97F10)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend set_coverage_class API in order to enable ACK timeout estimation
algorithm (dynack). Currently dynack is supported just by ath9k. In a different
patchset I will fix signature issue for p54, ath9k_htc and ath5k drivers.

Changes since v1:
- extend set_coverage_class signature insted of define enable_dynack API

Lorenzo Bianconi (2):
  cfg80211: extend coverage_class datatype
  mac80211: extend set_coverage_class signature

 include/net/cfg80211.h       |  5 +++--
 include/net/mac80211.h       |  5 +++--
 include/uapi/linux/nl80211.h |  5 +++++
 net/mac80211/driver-ops.h    |  9 +++------
 net/mac80211/trace.h         |  4 ++--
 net/wireless/nl80211.c       | 14 ++++++++++----
 6 files changed, 26 insertions(+), 16 deletions(-)

-- 
1.9.1

