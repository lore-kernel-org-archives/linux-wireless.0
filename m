Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:34824 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012Ab2I0S7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 14:59:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 0/5] add scan flags support
Date: Thu, 27 Sep 2012 11:59:09 -0700
Message-Id: <1348772354-15936-1-git-send-email-bzhao@marvell.com> (sfid-20120927_205942_356492_E66F4676)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the v2 series prepared by Amitkumar Karwar.

1) TX_ABORT flag is renamed to LOW_PRIORITY to have more generic
approach. Let the drivers decide behaviour for background scan. 
2) An extra parameter is added to __cfg80211_bss_expire() to
avoid race condition pointed by Johannes.

Note that "PATCH v2 5/5 mwifiex: use LOW_PRIORITY flag ..."
does not apply to mac80211-next cleanly because some recent
mwifiex patches in wireless-testing have not been pulled yet.

=== original post (v1) by Sam Leffler ===

These add per-scan request controls for optional behaviours we've found
useful (they've been in Chrome OS for a long time).  A patch for iw will
follow separately and the mods for wpa_supplicant are in our repo and
I'll push them to Jouni if these are accepted.

Amitkumar Karwar (1):
  mwifiex: use LOW_PRIORITY flag provided in scan request

Sam Leffler (4):
  {nl,cfg}80211: add a flags word to scan requests
  cfg80211: add scan flag to indicate its priority
  cfg80211: add support for flushing old scan results
  mac80211: add support for tx to abort low priority scan requests

 drivers/net/wireless/mwifiex/cfg80211.c |    3 ++-
 drivers/net/wireless/mwifiex/scan.c     |    6 +++++-
 include/linux/nl80211.h                 |   19 +++++++++++++++++++
 include/net/cfg80211.h                  |   17 +++++++++++++++++
 net/mac80211/ieee80211_i.h              |    2 ++
 net/mac80211/scan.c                     |   22 ++++++++++++++++++----
 net/wireless/nl80211.c                  |   12 ++++++++++++
 net/wireless/scan.c                     |   31 +++++++++++++++++++++++++++----
 net/wireless/sme.c                      |    1 +
 9 files changed, 103 insertions(+), 10 deletions(-)

