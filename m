Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6905 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab2FAGjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 02:39:48 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<stable@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix a WARNING in suspend/resume with IBSS
Date: Fri, 1 Jun 2012 12:09:39 +0530
Message-ID: <1338532779-4621-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120601_083956_399882_A3D65832)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

In ath9k we make sure the following two things
*if the first interface is ADHOC we cannot have any other interface.
*we cannot add an ADHOC interface if there is already an interface
is present.

when drv_add_interface is called during resume we got to consider
number of vifs already present in addition to checking the drivers
'opmode' information about ADHOC, otherwise during suspend/resume
we incorrectly assume an ADHOC interface is already present.
Then we may miss some driver specific data for the ADHOC
interface after resume.

	ath: phy0: Cannot create ADHOC interface when other
	interfaces already exist.
	WARNING: at net/mac80211/driver-ops.h:12
	ieee80211_reconfig+0x1882/0x1ca0 [mac80211]()
	Hardware name: 2842RK1
	wlan2:  Failed check-sdata-in-driver check, flags: 0x0

	Call Trace:
	[<c01361b2>] warn_slowpath_common+0x72/0xa0
	[<f8aaa7c2>] ? ieee80211_reconfig+0x1882/0x1ca0
	[mac80211]
	[<f8aaa7c2>] ? ieee80211_reconfig+0x1882/0x1ca0
	[mac80211]
	[<c0136283>] warn_slowpath_fmt+0x33/0x40
	[<f8aaa7c2>] ieee80211_reconfig+0x1882/0x1ca0 [mac80211]
	[<c06c1d1a>] ? mutex_lock_nested+0x23a/0x2f0
	[<f8a95097>] ieee80211_resume+0x27/0x70 [mac80211]
	[<fd177edf>] wiphy_resume+0x8f/0xa0 [cfg80211]

Cc: stable@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4de4473..c26497d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1443,11 +1443,14 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		}
 	}
 
-	if ((ah->opmode == NL80211_IFTYPE_ADHOC) ||
-	    ((vif->type == NL80211_IFTYPE_ADHOC) &&
-	     sc->nvifs > 0)) {
-		ath_err(common, "Cannot create ADHOC interface when other"
-			" interfaces already exist.\n");
+	if ((ah->opmode == NL80211_IFTYPE_ADHOC) && (sc->nvifs > 0)) {
+		ath_err(common, "Cannot create any other interface when an ADHOC interface already exists.\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if ((vif->type == NL80211_IFTYPE_ADHOC) && (sc->nvifs > 0)) {
+		ath_err(common, "Cannot create ADHOC interface when other interfaces already exist.\n");
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.7.0.4

