Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33504 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752253AbdHPNR5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 09:17:57 -0400
Received: by mail-pf0-f194.google.com with SMTP id c65so1361064pfl.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Aug 2017 06:17:57 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 03/11] rsi: remove interface changes for AP mode
Date: Wed, 16 Aug 2017 18:43:10 +0530
Message-Id: <1502889198-4478-4-git-send-email-amitkarwar@gmail.com> (sfid-20170816_151801_048841_1CBFC8B1)
In-Reply-To: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
References: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
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
