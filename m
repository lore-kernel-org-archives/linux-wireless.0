Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:42898 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab3JDIbR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 04:31:17 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix station authorization
Date: Fri, 4 Oct 2013 10:30:28 +0200
Message-ID: <1380875428-20899-1-git-send-email-michal.kazior@tieto.com> (sfid-20131004_103122_020310_A29B9BD5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peer authorization should be delayed until
mac80211 says given station has transitioned into
authorized state.

The state is propagated from mac80211 for both
open and protected networks.

This should prevent data traffic to/from given
station until authorization completes. Until now
it was probably possible for unauthorized traffic
to pass leading to possible security issues.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
I've been keeping this patch in my closet apparently.

Tested briefly and seems there are no regressions.

 drivers/net/wireless/ath/ath10k/mac.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8684e03..0175d22 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -781,7 +781,6 @@ static void ath10k_peer_assoc_h_basic(struct ath10k *ar,
 	memcpy(arg->addr, sta->addr, ETH_ALEN);
 	arg->vdev_id = arvif->vdev_id;
 	arg->peer_aid = sta->aid;
-	arg->peer_flags |= WMI_PEER_AUTH;
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_STA)
 		/*
@@ -2603,6 +2602,32 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		if (ret)
 			ath10k_warn("Failed to disassociate station: %pM\n",
 				    sta->addr);
+	} else if (old_state == IEEE80211_STA_ASSOC &&
+		   new_state == IEEE80211_STA_AUTHORIZED) {
+		/*
+		 * Authorization
+		 */
+		ath10k_dbg(ATH10K_DBG_MAC, "mac sta %pM authorized\n",
+			   sta->addr);
+
+		ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+						WMI_PEER_AUTHORIZE, 1);
+		if (ret)
+			ath10k_warn("Failed to authorize station: %pM\n",
+				    sta->addr);
+	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
+		   new_state == IEEE80211_STA_ASSOC) {
+		/*
+		 * De-Authorization
+		 */
+		ath10k_dbg(ATH10K_DBG_MAC, "mac sta %pM de-authorized\n",
+			   sta->addr);
+
+		ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+						WMI_PEER_AUTHORIZE, 0);
+		if (ret)
+			ath10k_warn("Failed to de-authorize station: %pM\n",
+				    sta->addr);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
-- 
1.7.9.5

