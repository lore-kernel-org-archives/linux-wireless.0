Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:45827 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab2JRGfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 02:35:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v6 0/6] add scan flags support
Date: Wed, 17 Oct 2012 23:34:25 -0700
Message-Id: <1350542071-26498-1-git-send-email-bzhao@marvell.com> (sfid-20121018_083544_829732_D683086A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v6: move enum nl80211_scan_flags placeholder from 1/6 to 3/6,
    and merge with new flag in 3/6 to avoid breaking build in 1/6.
    This makes patch series friendly to bisect. (Fengguang Wu)

    Other 4 patches are not changed.

---
Amitkumar Karwar (1):
  cfg80211: code rearrangement to avoid forward declarations

Johannes Berg (1):
  wireless: use OR operation to set wiphy features

Sam Leffler (4):
  {nl,cfg}80211: add a flags word to scan requests
  cfg80211: add scan flag to indicate its priority
  cfg80211: add support for flushing old scan results
  mac80211: add support for tx to abort low priority scan requests

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c    |    4 +-
 include/net/cfg80211.h                     |    7 ++
 include/uapi/linux/nl80211.h               |   23 +++++
 net/mac80211/ieee80211_i.h                 |    2 +
 net/mac80211/main.c                        |    9 ++-
 net/mac80211/scan.c                        |   21 ++++-
 net/wireless/core.c                        |    2 +
 net/wireless/nl80211.c                     |   30 +++++++
 net/wireless/scan.c                        |  120 +++++++++++++++++-----------
 net/wireless/sme.c                         |    1 +
 11 files changed, 164 insertions(+), 57 deletions(-)

