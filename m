Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:37060 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaEaSuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 14:50:03 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so3379020wes.2
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 11:50:02 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/9] b43: b43_op_config: use IEEE80211_CONF_CHANGE_CHANNEL
Date: Sat, 31 May 2014 20:49:35 +0200
Message-Id: <1401562181-14608-4-git-send-email-zajec5@gmail.com> (sfid-20140531_205014_453950_00CD0CC5)
In-Reply-To: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
References: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is tiny optimization and grouping band/channel ops.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index a9e50ee..59aa4fd 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3807,16 +3807,23 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&wl->mutex);
 	b43_mac_suspend(dev);
 
-	/* Switch the band (if necessary). This might change the active core. */
-	err = b43_switch_band(dev, conf->chandef.chan);
-	if (err)
-		goto out_unlock_mutex;
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		if (conf_is_ht(conf))
+			phy->is_40mhz = conf_is_ht40_minus(conf) ||
+					conf_is_ht40_plus(conf);
+		else
+			phy->is_40mhz = false;
 
-	if (conf_is_ht(conf))
-		phy->is_40mhz =
-			(conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf));
-	else
-		phy->is_40mhz = false;
+		/* Switch the band (if necessary). */
+		err = b43_switch_band(dev, conf->chandef.chan);
+		if (err)
+			goto out_mac_enable;
+
+		/* Switch to the requested channel.
+		 * The firmware takes care of races with the TX handler.
+		 */
+		b43_switch_channel(dev, conf->chandef.chan->hw_value);
+	}
 
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		b43_set_retry_limits(dev, conf->short_frame_max_tx_count,
@@ -3825,11 +3832,6 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (!changed)
 		goto out_mac_enable;
 
-	/* Switch to the requested channel.
-	 * The firmware takes care of races with the TX handler. */
-	if (conf->chandef.chan->hw_value != phy->channel)
-		b43_switch_channel(dev, conf->chandef.chan->hw_value);
-
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_MONITOR);
 
 	/* Adjust the desired TX power level. */
@@ -3865,7 +3867,6 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 
 out_mac_enable:
 	b43_mac_enable(dev);
-out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 
 	return err;
-- 
1.8.4.5

