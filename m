Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:38177 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915AbcGLLnb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 07:43:31 -0400
From: weiyj_lk@163.com
To: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-wireless@vger.kernel.org
Subject: [PATCH -next] mwifiex: fix possible memory leak in mwifiex_cfg80211_start_ap()
Date: Tue, 12 Jul 2016 11:43:18 +0000
Message-Id: <1468323798-6075-1-git-send-email-weiyj_lk@163.com> (sfid-20160712_134335_630445_0AE3758E)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

memory is malloced in mwifiex_cfg80211_start_ap() and should be
freed before leaving from the error handling cases, otherwise it
will cause memory leak.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index df5ebdf..1eec77e 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1936,10 +1936,9 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	mwifiex_set_uap_rates(bss_cfg, params);
 
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
-		kfree(bss_cfg);
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "Failed to parse secuirty parameters!\n");
-		return -1;
+		goto out;
 	}
 
 	mwifiex_set_ht_params(priv, bss_cfg, params);
@@ -1968,7 +1967,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		if (mwifiex_11h_activate(priv, false)) {
 			mwifiex_dbg(priv->adapter, ERROR,
 				    "Failed to disable 11h extensions!!");
-			return -1;
+			goto out;
 		}
 		priv->state_11h.is_11h_active = false;
 	}
@@ -1976,12 +1975,11 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	if (mwifiex_config_start_uap(priv, bss_cfg)) {
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "Failed to start AP\n");
-		kfree(bss_cfg);
-		return -1;
+		goto out;
 	}
 
 	if (mwifiex_set_mgmt_ies(priv, &params->beacon))
-		return -1;
+		goto out;
 
 	if (!netif_carrier_ok(priv->netdev))
 		netif_carrier_on(priv->netdev);
@@ -1990,6 +1988,10 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	memcpy(&priv->bss_cfg, bss_cfg, sizeof(priv->bss_cfg));
 	kfree(bss_cfg);
 	return 0;
+
+out:
+	kfree(bss_cfg);
+	return -1;
 }
 
 /*


