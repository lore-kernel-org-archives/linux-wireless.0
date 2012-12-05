Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:43543 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2LEEMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 23:12:50 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC] mac80211_hwsim: dont modify TBTT if beacon is already enabled
Date: Tue,  4 Dec 2012 20:12:41 -0800
Message-Id: <1354680761-32703-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121205_051300_029187_A9EA1871)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the beacon is already enabled, do not modify the beacon timer. This causes
a hard TBTT adjustment and may cause mischief for powersave or synchronization.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index bc763d2..abfa7e6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1174,7 +1174,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	data->power_level = conf->power_level;
 	if (!data->started || !data->beacon_int)
 		del_timer(&data->beacon_timer);
-	else
+	else if (!timer_pending(&data->beacon_timer))
 		mod_timer(&data->beacon_timer, jiffies + data->beacon_int);
 
 	return 0;
-- 
1.7.9.5

