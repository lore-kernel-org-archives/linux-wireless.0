Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49665 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3KRRC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:02:57 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx12so994036bkb.6
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 09:02:56 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Avri Altman <avri.altman@intel.com>
Subject: [PATCH 4/6] mac80211: update ht flag if bss configuration changed
Date: Mon, 18 Nov 2013 19:02:44 +0200
Message-Id: <1384794166-10906-4-git-send-email-egrumbach@gmail.com> (sfid-20131118_180303_739766_D39524AA)
In-Reply-To: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

The bug concerned failing to update the ht flag properly.
updating the ht flag when bss configuration changes should
be done independently of channel changes.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b3a3ce3..03aa33f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -330,6 +330,16 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON_ONCE(!sta))
 		return -EINVAL;
 
+	/*
+	 * if bss configuration changed store the new one -
+	 * this may be applicable even if channel is identical
+	 */
+	ht_opmode = le16_to_cpu(ht_oper->operation_mode);
+	if (sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
+		*changed |= BSS_CHANGED_HT;
+		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
+	}
+
 	chan = sdata->vif.bss_conf.chandef.chan;
 	sband = local->hw.wiphy->bands[chan->band];
 
@@ -416,14 +426,6 @@ static int ieee80211_config_bw(struct ieee80211_sub_if_data *sdata,
 					 IEEE80211_RC_BW_CHANGED);
 	}
 
-	ht_opmode = le16_to_cpu(ht_oper->operation_mode);
-
-	/* if bss configuration changed store the new one */
-	if (sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
-		*changed |= BSS_CHANGED_HT;
-		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
-	}
-
 	return 0;
 }
 
-- 
1.7.9.5

