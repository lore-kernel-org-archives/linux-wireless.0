Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:62534 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYGXBgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 21:36:38 -0400
Received: by py-out-1112.google.com with SMTP id p76so1941585pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 18:36:37 -0700 (PDT)
Subject: [PATCH-next] mac80211: fix sparse integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 18:36:38 -0700
Message-Id: <1216863398.30386.64.camel@brick> (sfid-20080724_033642_555352_689D4B33)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/mac80211_hwsim.c:503:20: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e802ccd..d593f2b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -500,7 +500,7 @@ failed_hw:
 	device_unregister(data->dev);
 failed_drvdata:
 	ieee80211_free_hw(hw);
-	hwsim_radios[i] = 0;
+	hwsim_radios[i] = NULL;
 failed:
 	mac80211_hwsim_free();
 	return err;
-- 
1.5.6.4.570.g052e

