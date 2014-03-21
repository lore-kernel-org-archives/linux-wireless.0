Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56931 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaCUOJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 10:09:44 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so1844243eek.36
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 07:09:43 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: dont call csa_finish more than once
Date: Fri, 21 Mar 2014 15:02:00 +0100
Message-Id: <1395410520-26939-1-git-send-email-michal.kazior@tieto.com> (sfid-20140321_150948_706832_25F8B34B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver is supposed to call it only once for each
scheduled channel_switch_beacon().

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
This is required for multi-vif csa but since that
isn't merged yet I'm not including any specifics
in the commit log itself.

Preventing multiple ieee80211_csa_finish() calls
sounds like a good idea in general to me.


 drivers/net/wireless/ath/ath10k/core.h | 1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 5 +++--
 drivers/net/wireless/ath/ath10k/wmi.c  | 5 ++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ad209a6..cf4f756 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -228,6 +228,7 @@ struct ath10k_vif {
 	struct ath10k *ar;
 	struct ieee80211_vif *vif;
 
+	bool csa_finished;
 	bool is_started;
 	bool is_up;
 	u32 aid;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 52ae380..583daba 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4090,8 +4090,9 @@ static void ath10k_channel_switch_beacon(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 struct cfg80211_chan_def *chandef)
 {
-	/* there's no need to do anything here. vif->csa_active is enough */
-	return;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+
+	arvif->csa_finished = false;
 }
 
 static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 48130fe..1630cd8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1414,7 +1414,10 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		 * actual channel switch is done */
 		if (arvif->vif->csa_active &&
 		    ieee80211_csa_is_complete(arvif->vif)) {
-			ieee80211_csa_finish(arvif->vif);
+			if (!arvif->csa_finished) {
+				ieee80211_csa_finish(arvif->vif);
+				arvif->csa_finished = true;
+			}
 			continue;
 		}
 
-- 
1.8.5.3

