Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58507 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab3I2MsG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Sep 2013 08:48:06 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.12] mac80211: fix a tx power handling regression
Date: Sun, 29 Sep 2013 14:48:03 +0200
Message-Id: <1380458883-19862-1-git-send-email-nbd@openwrt.org> (sfid-20130929_144824_118345_F20376DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 1ea6f9c0d48b11b6ec3ec4b5579ec74fc3951cf8
"mac80211: handle TX power per virtual interface"

This commit added support for tracking tx power configuration for
multiple interfaces, however instead of using the maximum value of all
virtual interfaces, it uses the minimum.

This causes the configured tx power to be reset to the absolute minimum
for all virtual interfaces, whenever an interface is created and destroyed
immediately afterwards.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 21d5d44..87c5509 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -97,7 +97,7 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	struct cfg80211_chan_def chandef = {};
 	u32 changed = 0;
-	int power;
+	int power = 0;
 	u32 offchannel_flag;
 
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
@@ -142,16 +142,16 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}
 
-	power = ieee80211_chandef_max_power(&chandef);
-
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!rcu_access_pointer(sdata->vif.chanctx_conf))
 			continue;
-		power = min(power, sdata->vif.bss_conf.txpower);
+		power = max(power, sdata->vif.bss_conf.txpower);
 	}
 	rcu_read_unlock();
 
+	power = min(power, ieee80211_chandef_max_power(&chandef));
+
 	if (local->hw.conf.power_level != power) {
 		changed |= IEEE80211_CONF_CHANGE_POWER;
 		local->hw.conf.power_level = power;
-- 
1.8.0.2

