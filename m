Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:46833 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754296AbeDJPBt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 11:01:49 -0400
Received: by mail-pl0-f67.google.com with SMTP id 59-v6so7683348plc.13
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 08:01:49 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Subject: [v2 3/7] rsi: use appropriate interface for power save configuration
Date: Tue, 10 Apr 2018 20:34:13 +0530
Message-Id: <1523372657-6067-4-git-send-email-siva8118@gmail.com> (sfid-20180410_170153_931829_832A6E76)
In-Reply-To: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
References: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Power save request should be sent on station interface. Virtual
interface which is connected should be preferred. This patch
resolves device not entering power save problem in certain
situations

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 5edc3a9..77aa3bb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -614,7 +614,7 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 
 	/* Power save parameters */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		struct ieee80211_vif *vif;
+		struct ieee80211_vif *vif, *sta_vif = NULL;
 		unsigned long flags;
 		int i, set_ps = 1;
 
@@ -628,13 +628,17 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 				set_ps = 0;
 				break;
 			}
+			if ((vif->type == NL80211_IFTYPE_STATION ||
+			     vif->type == NL80211_IFTYPE_P2P_CLIENT) &&
+			    (!sta_vif || vif->bss_conf.assoc))
+				sta_vif = vif;
 		}
-		if (set_ps) {
+		if (set_ps && sta_vif) {
 			spin_lock_irqsave(&adapter->ps_lock, flags);
 			if (conf->flags & IEEE80211_CONF_PS)
-				rsi_enable_ps(adapter, vif);
+				rsi_enable_ps(adapter, sta_vif);
 			else
-				rsi_disable_ps(adapter, vif);
+				rsi_disable_ps(adapter, sta_vif);
 			spin_unlock_irqrestore(&adapter->ps_lock, flags);
 		}
 	}
-- 
2.7.4
