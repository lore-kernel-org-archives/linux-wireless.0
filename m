Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48284 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaEaSuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 14:50:08 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so3442077wgh.16
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 11:50:06 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/9] b43: b43_op_config: set channel info before switching band
Date: Sat, 31 May 2014 20:49:37 +0200
Message-Id: <1401562181-14608-6-git-send-email-zajec5@gmail.com> (sfid-20140531_205015_467096_B71E1B00)
In-Reply-To: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
References: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Band switching code needs to know what channel we switch to.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c       | 3 ++-
 drivers/net/wireless/b43/phy_common.c | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 59aa4fd..5e4eed3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3808,6 +3808,7 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	b43_mac_suspend(dev);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		phy->channel = conf->chandef.chan->hw_value;
 		if (conf_is_ht(conf))
 			phy->is_40mhz = conf_is_ht40_minus(conf) ||
 					conf_is_ht40_plus(conf);
@@ -3822,7 +3823,7 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 		/* Switch to the requested channel.
 		 * The firmware takes care of races with the TX handler.
 		 */
-		b43_switch_channel(dev, conf->chandef.chan->hw_value);
+		b43_switch_channel(dev, phy->channel);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 3bfb795..b465011 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -424,7 +424,6 @@ int b43_switch_channel(struct b43_wldev *dev, unsigned int new_channel)
 	if (err)
 		goto err_restore_cookie;
 
-	dev->phy.channel = new_channel;
 	/* Wait for the radio to tune to the channel and stabilize. */
 	msleep(8);
 
-- 
1.8.4.5

