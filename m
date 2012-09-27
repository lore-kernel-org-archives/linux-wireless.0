Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:39218 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab2I0THR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 15:07:17 -0400
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
Subject: [PATCH v2 2/5] cfg80211: add scan flag to indicate its priority
Date: Thu, 27 Sep 2012 11:59:11 -0700
Message-Id: <1348772354-15936-3-git-send-email-bzhao@marvell.com> (sfid-20120927_210723_153083_785E2C4C)
In-Reply-To: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

Add NL80211_SCAN_FLAG_LOW_PRIORITY flag support. It tells drivers
that this is a low priority scan request, so that they can take
necessary action.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Tested-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 109f75d..e512baf 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3079,8 +3079,11 @@ enum nl80211_connect_failed_reason {
  * Scan request control flags are used to control the handling
  * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
  * requests.
+ *
+ * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
  */
 enum nl80211_scan_flags {
+	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 };
 
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2c0c14a..ed659db 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -993,8 +993,11 @@ struct cfg80211_ssid {
 
 /**
  * enum cfg80211_scan_flags -  scan request control flags
+ *
+ * @CFG80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
  */
 enum cfg80211_scan_flags {
+	CFG80211_SCAN_FLAG_LOW_PRIORITY	= NL80211_SCAN_FLAG_LOW_PRIORITY,
 };
 
 /**
-- 
1.7.0.2

