Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57941 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaAOMJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 07:09:28 -0500
Received: by mail-ee0-f49.google.com with SMTP id d17so823105eek.36
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 04:09:27 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 3/9] mac80211: move csa_active setting in STA CSA
Date: Wed, 15 Jan 2014 13:04:48 +0100
Message-Id: <1389787494-7361-4-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130933_855780_FE376049)
In-Reply-To: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sdata->vif.csa_active could be left set after,
e.g. channel context contraints check fail in STA
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

