Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46606 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaADVY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jan 2014 16:24:26 -0500
Received: by mail-pd0-f179.google.com with SMTP id r10so16713995pdi.10
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jan 2014 13:24:25 -0800 (PST)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH] mac80211: SMPS: Fix the overwrite of rx_chains in the interface loop.
Date: Sun,  5 Jan 2014 02:54:13 +0530
Message-Id: <1388870653-3507-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140104_222430_478014_280447E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interface loop identifies the no of static and dynamic
smps chains, but overwrites their values across the VIF's
(assuming there are more than one, in my case its AP and STA
loopback), so the driver might not intimated about this update
of SMPS mode, is the value is same. 

So inform driver for every VIF.

For Ex: STA's SMPS state is changed, but in the loop AP appears
at the last, SMPS state of AP is unchanged hence not intimated
to the driver.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---

 net/mac80211/chan.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f43613a..e153a7e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -483,26 +483,26 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 
 		rx_chains_static = max(rx_chains_static, needed_static);
 		rx_chains_dynamic = max(rx_chains_dynamic, needed_dynamic);
-	}
-	rcu_read_unlock();
+		if (!local->use_chanctx) {
+				if (rx_chains_static > 1)
+					local->smps_mode = IEEE80211_SMPS_OFF;
+				else if (rx_chains_dynamic > 1)
+					local->smps_mode = IEEE80211_SMPS_DYNAMIC;
+				else
+					local->smps_mode = IEEE80211_SMPS_STATIC;
+						ieee80211_hw_config(local, 0);
+		}
 
-	if (!local->use_chanctx) {
-		if (rx_chains_static > 1)
-			local->smps_mode = IEEE80211_SMPS_OFF;
-		else if (rx_chains_dynamic > 1)
-			local->smps_mode = IEEE80211_SMPS_DYNAMIC;
-		else
-			local->smps_mode = IEEE80211_SMPS_STATIC;
-		ieee80211_hw_config(local, 0);
-	}
+		if (rx_chains_static == chanctx->conf.rx_chains_static &&
+		rx_chains_dynamic == chanctx->conf.rx_chains_dynamic)
+				return;
 
-	if (rx_chains_static == chanctx->conf.rx_chains_static &&
-	    rx_chains_dynamic == chanctx->conf.rx_chains_dynamic)
-		return;
+		chanctx->conf.rx_chains_static = rx_chains_static;
+		chanctx->conf.rx_chains_dynamic = rx_chains_dynamic;
+		drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RX_CHAINS);
+	}
+	rcu_read_unlock();
 
-	chanctx->conf.rx_chains_static = rx_chains_static;
-	chanctx->conf.rx_chains_dynamic = rx_chains_dynamic;
-	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RX_CHAINS);
 }
 
 int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
