Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61502 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1K1WXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 17:23:22 -0500
Received: by vcbfk14 with SMTP id fk14so4095806vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 14:23:22 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	compat@orbit-lab.org, Paul Stewart <pstew@google.com>,
	Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC v2 2/2] cfg80211: Restore orig channel values upon disconnect
Date: Mon, 28 Nov 2011 17:23:11 -0500
Message-Id: <1322518991-7040-3-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_232326_100615_109CF11A)
In-Reply-To: <1322518991-7040-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322518991-7040-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

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
 net/wireless/reg.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4fe396a..3d60b8d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1801,6 +1801,7 @@ static void restore_regulatory_settings(bool reset_user)
 	struct reg_beacon *reg_beacon, *btmp;
 	struct regulatory_request *reg_request, *tmp;
 	LIST_HEAD(tmp_reg_req_list);
+	struct wiphy *wiphy;
 
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
@@ -1853,6 +1854,25 @@ static void restore_regulatory_settings(bool reset_user)
 		kfree(last_request);
 	last_request = &core_request_world;
 
+	wiphy = wiphy_idx_to_wiphy(0);
+	if (wiphy && wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
+		struct ieee80211_supported_band *sband;
+		enum ieee80211_band band;
+		struct ieee80211_channel *chan;
+		int i;
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+			sband = wiphy->bands[band];
+			if (!sband)
+				continue;
+			for (i = 0; i < sband->n_channels; i++) {
+				chan = &sband->channels[i];
+				chan->flags = chan->orig_flags;
+				chan->max_antenna_gain = chan->orig_mag;
+				chan->max_power = chan->orig_mpwr;
+			}
+		}
+	}
+
 	mutex_unlock(&reg_mutex);
 	mutex_unlock(&cfg80211_mutex);
 
-- 
1.7.4.15.g7811d

