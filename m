Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35013 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753245AbdHKNqA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 09:46:00 -0400
Received: by mail-pg0-f67.google.com with SMTP id l64so3184659pge.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 06:46:00 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 03/11] rsi: remove interface changes for AP mode
Date: Fri, 11 Aug 2017 19:11:21 +0530
Message-Id: <1502458889-9690-4-git-send-email-amitkarwar@gmail.com> (sfid-20170811_154605_860499_46558046)
In-Reply-To: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

remove_interface callback of mac80211 is handled for AP mode.
Same is notified to firmware through vap_capabilities frame
with VAP status VAP_DELETE.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index edcba56..99446bb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -405,13 +405,31 @@ static void rsi_mac80211_remove_interface(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	enum opmode opmode;
+
+	rsi_dbg(INFO_ZONE, "Remove Interface Called\n");
 
 	mutex_lock(&common->mutex);
-	if (vif->type == NL80211_IFTYPE_STATION) {
-		adapter->sc_nvifs--;
-		rsi_set_vap_capabilities(common, STA_OPMODE, vif->addr,
-					 0, VAP_DELETE);
+
+	if (adapter->sc_nvifs <= 0) {
+		mutex_unlock(&common->mutex);
+		return;
+	}
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		opmode = STA_OPMODE;
+		break;
+	case NL80211_IFTYPE_AP:
+		opmode = AP_OPMODE;
+		break;
+	default:
+		mutex_unlock(&common->mutex);
+		return;
 	}
+	rsi_set_vap_capabilities(common, opmode, vif->addr,
+				 0, VAP_DELETE);
+	adapter->sc_nvifs--;
 
 	if (!memcmp(adapter->vifs[0], vif, sizeof(struct ieee80211_vif)))
 		adapter->vifs[0] = NULL;
-- 
2.7.4
