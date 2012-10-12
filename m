Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:46577 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744Ab2JLEET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 00:04:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v4 0/5] add scan flags support
Date: Thu, 11 Oct 2012 21:03:30 -0700
Message-Id: <1350014615-14762-1-git-send-email-bzhao@marvell.com> (sfid-20121012_060423_475492_10C4CADA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the v4 series prepared by Amitkumar Karwar.

1) "wiphy->features" is used instead of "wiphy->flags" to advertise
   scan features. (Johannes Berg)
2) Added support to disable scan flush if driver requests for it
   explicitly. (Johannes Berg)
3) Used msecs_to_jiffies() to convert time interval into jiffies
   for comparison (Johannes Berg)

---
Amitkumar Karwar (1):
  cfg80211: code rearrangement to avoid forward declarations

Sam Leffler (4):
  {nl,cfg}80211: add a flags word to scan requests
  cfg80211: add scan flag to indicate its priority
  cfg80211: add support for flushing old scan results
  mac80211: add support for tx to abort low priority scan requests

 include/linux/nl80211.h    |   24 +++++++++
 include/net/cfg80211.h     |    7 +++
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/main.c        |    3 +-
 net/mac80211/scan.c        |   21 ++++++--
 net/wireless/nl80211.c     |   30 +++++++++++
 net/wireless/scan.c        |  120 +++++++++++++++++++++++++++-----------------
 net/wireless/sme.c         |    1 +
 8 files changed, 156 insertions(+), 52 deletions(-)

