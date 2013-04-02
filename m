Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:33387 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759591Ab3DBQkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 12:40:04 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: zefir.kurtisi@neratec.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] mac80211: fix recalc_radar hwconf sync problem
Date: Tue,  2 Apr 2013 18:39:49 +0200
Message-Id: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130402_184017_183870_B78BD6C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

local->hw.conf maybe not be synced when recalcing whether radar is
enabled, sometimes leaving radar enabled even if it's not neccesary
anymore.

Fix this by always applying the setting.

Reported-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/chan.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 931be41..9442c46 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -251,9 +251,6 @@ void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 	}
 	rcu_read_unlock();
 
-	if (radar_enabled == chanctx->conf.radar_enabled)
-		return;
-
 	chanctx->conf.radar_enabled = radar_enabled;
 	local->radar_detect_enabled = chanctx->conf.radar_enabled;
 
-- 
1.7.10.4

