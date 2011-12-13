Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26911 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1LMIzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 03:55:39 -0500
Cc: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC 2/2] mac80211: Fix power save in change save
Date: Tue, 13 Dec 2011 14:25:15 +0530
Message-ID: <1323766515-19223-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111213_095543_559143_BA2E42EE)
In-Reply-To: <1323766515-19223-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1323766515-19223-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

we found that power save is not getting enabled when we do
change interface in this order STA->IBSS->STA. this is
because ieee80211_setup_sdata clears type-dependen union

Reported-by: Leela Kella <leela@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 67a6be1..d87fde3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2371,6 +2371,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 		    (unsigned long) sdata);
 
 	ifmgd->flags = 0;
+	ifmgd->powersave = sdata->wdev.ps;
 
 	mutex_init(&ifmgd->mtx);
 
-- 
1.7.0.4

