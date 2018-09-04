Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTHQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:16 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 07/22] mt76x0: remove empty sta_notify
Date: Tue,  4 Sep 2018 16:41:00 +0200
Message-Id: <1536072075-6990-8-git-send-email-sgruszka@redhat.com> (sfid-20180904_164201_716818_C38412F3)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove empty implementation of sta_notify.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index f58c7ee332e0..24fe92febe50 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -151,12 +151,6 @@ mt76x0_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 
 static void
-mt76x0_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
-{
-}
-
-static void
 mt76x0_sw_scan(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif,
 		const u8 *mac_addr)
@@ -224,7 +218,6 @@ const struct ieee80211_ops mt76x0_ops = {
 	.bss_info_changed = mt76x0_bss_info_changed,
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
-	.sta_notify = mt76x0_sta_notify,
 	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x0_conf_tx,
 	.sw_scan_start = mt76x0_sw_scan,
-- 
2.7.5
