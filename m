Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50818 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031Ab2JDEr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 00:47:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 0/5] add scan flags support
Date: Wed,  3 Oct 2012 21:47:41 -0700
Message-Id: <1349326066-28501-1-git-send-email-bzhao@marvell.com> (sfid-20121004_064801_696290_EF181BB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the v3 series prepared by Amitkumar Karwar.

1/5: Remove unnecessary "enum cfg80211_scan_flags" (Johannes Berg)
     Add missing check for "nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS"
     (Johannes Berg)

2/5: Add WIPHY_FLAG_LOW_PRIORITY_SCAN flag so that device can advertise
     low priority scan capability. An error will be returned to the
     application if device doesn't support this feature.
     Flush scan table feature is by default enabled.
     (Johannes Berg)

3/5, 4/5: Rearrange the code to avoid static forward declarations.
     (Johannes Berg)

5/5: Removed use of unlikely() macro (Johannes Berg)
     Advertise low priority scan capability (Johannes Berg)

---
Amitkumar Karwar (1):
  cfg80211: code rearrangement to avoid forward declarations

Sam Leffler (4):
  {nl,cfg}80211: add a flags word to scan requests
  cfg80211: add scan flag to indicate its priority
  cfg80211: add support for flushing old scan results
  mac80211: add support for tx to abort low priority scan requests

 include/linux/nl80211.h    |   19 +++++++
 include/net/cfg80211.h     |    9 +++
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/main.c        |    3 +-
 net/mac80211/scan.c        |   21 ++++++--
 net/wireless/nl80211.c     |   22 ++++++++
 net/wireless/scan.c        |  119 ++++++++++++++++++++++++++-----------------
 net/wireless/sme.c         |    1 +
 8 files changed, 144 insertions(+), 52 deletions(-)

