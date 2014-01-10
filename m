Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaAJMvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 07:51:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/13] mac80211_hwsim: assign index from separate counter
Date: Fri, 10 Jan 2014 13:51:04 +0100
Message-Id: <1389358270-20901-8-git-send-email-johannes@sipsolutions.net> (sfid-20140110_135125_326787_0B36C1FA)
In-Reply-To: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
References: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To later allow dynamic registration, assign the index for the
struct device and MAC address from a new free-running counter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 59caa10..8df3d5e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -217,6 +217,7 @@ static const struct ieee80211_rate hwsim_rates[] = {
 
 static spinlock_t hwsim_radio_lock;
 static struct list_head hwsim_radios;
+static int hwsim_radio_idx;
 
 struct mac80211_hwsim_data {
 	struct list_head list;
@@ -2126,7 +2127,7 @@ static const struct ieee80211_iface_combination hwsim_if_comb[] = {
 	}
 };
 
-static int __init mac80211_hwsim_create_radio(int idx)
+static int __init mac80211_hwsim_create_radio(void)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2134,6 +2135,11 @@ static int __init mac80211_hwsim_create_radio(int idx)
 	struct ieee80211_hw *hw;
 	enum ieee80211_band band;
 	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
+	int idx;
+
+	spin_lock_bh(&hwsim_radio_lock);
+	idx = hwsim_radio_idx++;
+	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (channels > 1)
 		ops = &mac80211_hwsim_mchan_ops;
@@ -2375,7 +2381,7 @@ static int __init init_mac80211_hwsim(void)
 	}
 
 	for (i = 0; i < radios; i++) {
-		err = mac80211_hwsim_create_radio(i);
+		err = mac80211_hwsim_create_radio();
 		if (err)
 			goto out_free_radios;
 	}
-- 
1.8.5.1

