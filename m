Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbaA1IMv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 03:12:51 -0500
Date: Tue, 28 Jan 2014 09:14:48 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net
Subject: [PATCH] ath9k_htc: make ->sta_rc_update atomic for most calls
Message-ID: <20140128081433.GA1771@redhat.com> (sfid-20140128_091317_595834_7410FBBF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sta_rc_update() callback must be atomic, hence we can not take mutexes
or do other operations, which can sleep in ath9k_htc_sta_rc_update().

I think we can just return from ath9k_htc_sta_rc_update(), if it is
called without IEEE80211_RC_SUPP_RATES_CHANGED bit. That will help 
with scheduling while atomic bug for most cases (except mesh and IBSS
modes).

For mesh and IBSS I do not see other solution like creating additional
workqueue, because sending firmware command require us to sleep, but
this can be done in additional patch.

Patch partially fixes bug:
https://bugzilla.redhat.com/show_bug.cgi?id=990955

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 608d739..a57af9b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1315,21 +1315,22 @@ static void ath9k_htc_sta_rc_update(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_target_rate trate;
 
+	if (!(changed & IEEE80211_RC_SUPP_RATES_CHANGED))
+		return;
+
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 
-	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED) {
-		memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
-		ath9k_htc_setup_rate(priv, sta, &trate);
-		if (!ath9k_htc_send_rate_cmd(priv, &trate))
-			ath_dbg(common, CONFIG,
-				"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
-				sta->addr, be32_to_cpu(trate.capflags));
-		else
-			ath_dbg(common, CONFIG,
-				"Unable to update supported rates for sta: %pM\n",
-				sta->addr);
-	}
+	memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
+	ath9k_htc_setup_rate(priv, sta, &trate);
+	if (!ath9k_htc_send_rate_cmd(priv, &trate))
+		ath_dbg(common, CONFIG,
+			"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
+			sta->addr, be32_to_cpu(trate.capflags));
+	else
+		ath_dbg(common, CONFIG,
+			"Unable to update supported rates for sta: %pM\n",
+			sta->addr);
 
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
-- 
1.7.11.7

