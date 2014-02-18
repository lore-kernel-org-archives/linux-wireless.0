Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63183 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390AbaBRXsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 18:48:03 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: enable obss scan offload feature flag
Date: Tue, 18 Feb 2014 15:47:57 -0800
Message-ID: <1392767277-10941-3-git-send-email-bzhao@marvell.com> (sfid-20140219_004817_787131_D82A8DB6)
In-Reply-To: <1392767277-10941-1-git-send-email-bzhao@marvell.com>
References: <1392767277-10941-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We don't perform OBSS scan internally. As we intend to use
corresponding feature in application, we will enable this flag.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 436ba43..dca2a7b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2908,7 +2908,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 
 	wiphy->features |= NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_INACTIVITY_TIMER |
-			   NL80211_FEATURE_LOW_PRIORITY_SCAN;
+			   NL80211_FEATURE_LOW_PRIORITY_SCAN |
+			   NL80211_FEATURE_NEED_OBSS_SCAN;
 
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
-- 
1.8.2.3

