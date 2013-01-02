Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52267 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3ABWzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 17:55:51 -0500
Received: by mail-pa0-f47.google.com with SMTP id fa10so8239253pad.34
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 14:55:51 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.org
Cc: j@w1.fi, linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 1/4] mac80211_hwsim: fix tsf adjustment
Date: Wed,  2 Jan 2013 14:55:16 -0800
Message-Id: <1357167319-13338-1-git-send-email-thomas@cozybit.com> (sfid-20130102_235558_975337_498EDF6E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make hwsim TSF offset adjustments cumulative and relative
to the fake PHY TSF. Now adding 1000us, then adding -1000us
doesn't result in a tsf_offset of -1000. Also the beacon
timestamp can now correctly be expressed as (tsf +
data->tsf_offset), which will be done in a later patch.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ff90855..59761fb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -357,7 +357,7 @@ struct mac80211_hwsim_data {
 	int power_level;
 
 	/* difference between this hw's clock and the real clock, in usecs */
-	u64 tsf_offset;
+	s64 tsf_offset;
 };
 
 
@@ -423,9 +423,10 @@ static void mac80211_hwsim_set_tsf(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif, u64 tsf)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
-	struct timeval tv = ktime_to_timeval(ktime_get_real());
-	u64 now = tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
-	data->tsf_offset = tsf - now;
+	u64 now = mac80211_hwsim_get_tsf(hw, vif);
+	s64 delta = tsf - now;
+
+	data->tsf_offset += delta;
 }
 
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
-- 
1.7.10.4

