Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:59533 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397Ab3CGAp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 19:45:26 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix potential null dereference 'mef_entry'
Date: Wed,  6 Mar 2013 16:44:26 -0800
Message-Id: <1362617066-10703-1-git-send-email-bzhao@marvell.com> (sfid-20130307_014529_895221_A52332CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/mwifiex/cfg80211.c:2357 mwifiex_cfg80211_suspend()
  error: potential null dereference 'mef_entry'
  (kzalloc returns null)

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index df30107..c9bc5f5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2350,9 +2350,12 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		return 0;
 	}
 
+	mef_entry = kzalloc(sizeof(*mef_entry), GFP_KERNEL);
+	if (!mef_entry)
+		return -ENOMEM;
+
 	memset(&mef_cfg, 0, sizeof(mef_cfg));
 	mef_cfg.num_entries = 1;
-	mef_entry = kzalloc(sizeof(*mef_entry), GFP_KERNEL);
 	mef_cfg.mef_entry = mef_entry;
 	mef_entry->mode = MEF_MODE_HOST_SLEEP;
 	mef_entry->action = MEF_ACTION_ALLOW_AND_WAKEUP_HOST;
-- 
1.7.0.2

