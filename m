Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62177 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbaA2HBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 02:01:23 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so666553eei.12
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 23:01:22 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] mac80211: move csa_active setting in STA CSA
Date: Wed, 29 Jan 2014 07:56:19 +0100
Message-Id: <1390978581-13273-4-git-send-email-michal.kazior@tieto.com> (sfid-20140129_080148_846247_780EF42B)
In-Reply-To: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
References: <1390978581-13273-1-git-send-email-michal.kazior@tieto.com>
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
index cadf059..6c9ebca 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1012,7 +1012,6 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
-	sdata->vif.csa_active = true;
 
 	mutex_lock(&local->chanctx_mtx);
 	if (local->use_chanctx) {
@@ -1050,6 +1049,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&local->chanctx_mtx);
 
 	sdata->csa_chandef = csa_ie.chandef;
+	sdata->vif.csa_active = true;
 
 	if (csa_ie.mode)
 		ieee80211_stop_queues_by_reason(&local->hw,
-- 
1.8.5.3

