Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:34018 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab2IZQ7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 12:59:55 -0400
Received: by wgbdt11 with SMTP id dt11so66992wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 09:59:54 -0700 (PDT)
From: Sam Leffler <sleffler@chromium.org>
Date: Tue, 25 Sep 2012 15:49:23 -0700
Subject: [PATCH 0/3] add scan flags support
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20120926165952.766801E10D3@sleffler.sfo.corp.google.com> (sfid-20120926_190007_974806_542DE774)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These add per-scan request controls for optional behaviours we've found
useful (they've been in Chrome OS for a long time).  A patch for iw will
follow separately and the mods for wpa_supplicant are in our repo and
I'll push them to Jouni if these are accepted.

Sam Leffler (3):
  {nl,cfg}80211: add a flags word to scan requests
  mac80211: add support for tx to abort scan requests
  cfg80211: add support for flushing old scan results

 include/linux/nl80211.h    |   19 +++++++++++++++++++
 include/net/cfg80211.h     |   17 +++++++++++++++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/scan.c        |   19 ++++++++++++++++---
 net/wireless/nl80211.c     |   12 ++++++++++++
 net/wireless/scan.c        |   24 +++++++++++++++++++++---
 net/wireless/sme.c         |    1 +
 7 files changed, 88 insertions(+), 6 deletions(-)

-- 
1.7.7.3

