Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60829 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaATOZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:25:42 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so3543018eek.9
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:25:41 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/7] mac80211: move csa_active setting in STA CSA
Date: Mon, 20 Jan 2014 15:21:06 +0100
Message-Id: <1390227670-19030-4-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152551_905171_A2AFC6D2)
In-Reply-To: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sdata->vif.csa_active could be left set after,
e.g. channel context constraints check fail in STA
mode leaving the interface in a strange state for
a brief period of time until it is disconnected.
This was harmless but ugly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fc1d824..bfb81cb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1001,7 +1001,6 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
-	sdata->vif.csa_active = true;
 
 	mutex_lock(&local->chanctx_mtx);
 	if (local->use_chanctx) {
@@ -1039,6 +1038,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&local->chanctx_mtx);
 
 	sdata->csa_chandef = csa_ie.chandef;
+	sdata->vif.csa_active = true;
 
 	if (csa_ie.mode)
 		ieee80211_stop_queues_by_reason(&local->hw,
-- 
1.8.4.rc3

