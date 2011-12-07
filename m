Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52713 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab1LGQUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:32 -0500
Cc: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<compat@orbit-lab.org>, Paul Stewart <pstew@google.com>,
	Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 2/2] cfg80211: Restore orig channel values upon disconnect
Date: Wed, 7 Dec 2011 21:50:08 +0530
Message-ID: <1323274808-14094-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111207_172226_013968_93E2C40B)
In-Reply-To: <1323274808-14094-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1323274808-14094-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we restore regulatory settings the world regulatory domain
is properly reset on cfg80211 (or user prefered regulatory domain)
but we were never setting back channel values for drivers that use
WIPHY_FLAG_CUSTOM_REGULATORY. Set these values up again by using
the orig_ channel parameters.

This fixes restoring custom regulatory settings upon disconnect
events.

Cc: compat@orbit-lab.org
Cc: Paul Stewart <pstew@google.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/reg.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 88e0c62..db958ba 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1780,6 +1780,26 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 		REG_DBG_PRINT("Restoring regulatory settings\n");
 }
 
+static void restore_custom_reg_settings(struct wiphy *wiphy)
+{
+	struct ieee80211_supported_band *sband;
+	enum ieee80211_band band;
+	struct ieee80211_channel *chan;
+	int i;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		sband = wiphy->bands[band];
+		if (!sband)
+			continue;
+		for (i = 0; i < sband->n_channels; i++) {
+			chan = &sband->channels[i];
+			chan->flags = chan->orig_flags;
+			chan->max_antenna_gain = chan->orig_mag;
+			chan->max_power = chan->orig_mpwr;
+		}
+	}
+}
+
 /*
  * Restoring regulatory settings involves ingoring any
  * possibly stale country IE information and user regulatory
@@ -1801,6 +1821,7 @@ static void restore_regulatory_settings(bool reset_user)
 	struct reg_beacon *reg_beacon, *btmp;
 	struct regulatory_request *reg_request, *tmp;
 	LIST_HEAD(tmp_reg_req_list);
+	struct cfg80211_registered_device *rdev;
 
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
@@ -1849,6 +1870,11 @@ static void restore_regulatory_settings(bool reset_user)
 	/* First restore to the basic regulatory settings */
 	cfg80211_regdomain = cfg80211_world_regdom;
 
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (rdev->wiphy.flags & WIPHY_FLAG_CUSTOM_REGULATORY)
+			restore_custom_reg_settings(&rdev->wiphy);
+	}
+
 	mutex_unlock(&reg_mutex);
 	mutex_unlock(&cfg80211_mutex);
 
-- 
1.7.8

