Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35742 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750807AbdI2K44 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 06:56:56 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: Random MAC address during scanning
Date: Fri, 29 Sep 2017 16:23:10 +0530
Message-ID: <1506682390-27716-1-git-send-email-gbhat@marvell.com> (sfid-20170929_125702_066419_3953DE74)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik Ananthapadmanabha <karthida@marvell.com>

Driver will advertise RANDOM_MAC support only if the device
supports this feature.

Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 10 ++++++----
 drivers/net/wireless/marvell/mwifiex/fw.h       |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 32c5074..f22f7b8 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4306,10 +4306,12 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->features |= NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_INACTIVITY_TIMER |
 			   NL80211_FEATURE_LOW_PRIORITY_SCAN |
-			   NL80211_FEATURE_NEED_OBSS_SCAN |
-			   NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR |
-			   NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
-			   NL80211_FEATURE_ND_RANDOM_MAC_ADDR;
+			   NL80211_FEATURE_NEED_OBSS_SCAN;
+
+	if (ISSUPP_RANDOM_MAC(adapter->fw_cap_info))
+		wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR |
+				   NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
+				   NL80211_FEATURE_ND_RANDOM_MAC_ADDR;
 
 	if (ISSUPP_TDLS_ENABLED(adapter->fw_cap_info))
 		wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 9e75522..6b765f3 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -238,6 +238,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define ISSUPP_DRCS_ENABLED(FwCapInfo) (FwCapInfo & BIT(15))
 #define ISSUPP_SDIO_SPA_ENABLED(FwCapInfo) (FwCapInfo & BIT(16))
 #define ISSUPP_ADHOC_ENABLED(FwCapInfo) (FwCapInfo & BIT(25))
+#define ISSUPP_RANDOM_MAC(FwCapInfo) (FwCapInfo & BIT(27))
 
 #define MWIFIEX_DEF_HT_CAP	(IEEE80211_HT_CAP_DSSSCCK40 | \
 				 (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT) | \
-- 
1.9.1
