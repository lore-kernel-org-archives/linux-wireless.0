Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:51407 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240Ab1IHFoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 01:44:11 -0400
Received: by mail-ww0-f45.google.com with SMTP id 9so323944wwg.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 22:44:08 -0700 (PDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Luciano Coelho <coelho@ti.com>,
	Shahar Levi <shahar_levi@ti.com>
Subject: [PATCH] mac80211: Update device channel in case of HW channel switch supported
Date: Thu,  8 Sep 2011 08:44:05 +0300
Message-Id: <1315460645-16837-1-git-send-email-shahar_levi@ti.com> (sfid-20110908_074414_622624_6F3E908A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hw.conf.channel value is not updated properly for drivers that
support HW channel switch.  Since the switch is done entirely by the
driver and we don't call ieee80211_hw_config(), this value remains
untouched.  This patch fixes that by setting the new channel directly in
ieee80211_chswitch_work().

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 net/mac80211/mlme.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d6470c7..6f65ceb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -394,6 +394,9 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		/* call "hw_config" only if doing sw channel switch */
 		ieee80211_hw_config(sdata->local,
 			IEEE80211_CONF_CHANGE_CHANNEL);
+	} else {
+		/* update the device channel directly */
+		sdata->local->hw.conf.channel = sdata->local->oper_channel;
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-- 
1.7.1

