Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48569 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaEaSuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 14:50:10 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so3394882wgh.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 11:50:08 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 6/9] b43: store current channel using struct cfg80211_chan_def
Date: Sat, 31 May 2014 20:49:38 +0200
Message-Id: <1401562181-14608-7-git-send-email-zajec5@gmail.com> (sfid-20140531_205019_890951_9E2A283B)
In-Reply-To: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
References: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c       | 1 +
 drivers/net/wireless/b43/phy_common.c | 9 +++++++--
 drivers/net/wireless/b43/phy_common.h | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5e4eed3..2b99ed3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3808,6 +3808,7 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	b43_mac_suspend(dev);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		phy->chandef = &conf->chandef;
 		phy->channel = conf->chandef.chan->hw_value;
 		if (conf_is_ht(conf))
 			phy->is_40mhz = conf_is_ht40_minus(conf) ||
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index b465011..9aa6c9c 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -94,8 +94,13 @@ int b43_phy_init(struct b43_wldev *dev)
 	const struct b43_phy_operations *ops = phy->ops;
 	int err;
 
-	if (!phy->channel)
-		phy->channel = ops->get_default_chan(dev);
+	/* During PHY init we need to use some channel. On the first init this
+	 * function is called *before* b43_op_config, so our pointer is NULL.
+	 */
+	if (!phy->chandef) {
+		phy->chandef = &dev->wl->hw->conf.chandef;
+		phy->channel = phy->chandef->chan->hw_value;
+	}
 
 	phy->ops->switch_analog(dev, true);
 	b43_software_rfkill(dev, false);
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 9a92df4..56dfe7a 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -267,6 +267,7 @@ struct b43_phy {
 	unsigned long next_txpwr_check_time;
 
 	/* Current channel */
+	struct cfg80211_chan_def *chandef;
 	unsigned int channel;
 	u16 channel_freq;
 	enum nl80211_channel_type channel_type;
-- 
1.8.4.5

