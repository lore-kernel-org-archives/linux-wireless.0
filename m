Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:55188 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaEVNKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:10:25 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so2613395eei.14
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 06:10:24 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] b43: store current channel using struct cfg80211_chan_def
Date: Thu, 22 May 2014 15:10:10 +0200
Message-Id: <1400764210-30238-1-git-send-email-zajec5@gmail.com> (sfid-20140522_151028_959731_087CDAEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
I'm looking for a nice way of storing info about current wireless channel.
The initial "channel" unsigned int isn't enough, we need to keep info about
hw_value, frequency (or frequencies), width, HT, power, extra flags (like _IR).
In other words I need info you can find in struct cfg80211_chan_def.

So my idea is to add pointer to such struct and then drop old parameters
(channel, channel_freq, channel_type, is_40mhz).

Is this OK? Could you review my changes, please?
---
 drivers/net/wireless/b43/main.c       | 7 +++++--
 drivers/net/wireless/b43/phy_common.c | 8 ++++++++
 drivers/net/wireless/b43/phy_common.h | 1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5d1a5c7..7a094d1 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3840,8 +3840,11 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
-	if (conf->chandef.chan->hw_value != phy->channel)
-		b43_switch_channel(dev, conf->chandef.chan->hw_value);
+	if (conf->chandef.chan->hw_value != phy->channel) {
+		/* TODO: Is this safe to keep this pointer and use it later? */
+		phy->chandef = &conf->chandef;
+		b43_switch_channel(dev, phy->chandef->chan->hw_value);
+	}
 
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_MONITOR);
 
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index fb0dddd..066f0ed 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -94,6 +94,14 @@ int b43_phy_init(struct b43_wldev *dev)
 	const struct b43_phy_operations *ops = phy->ops;
 	int err;
 
+	/* During PHY init we need to use some channel. During the first init
+	 * this function is called *before* b43_op_config, so our pointer is
+	 * NULL.
+	 */
+	/* TODO: Is this safe? Seems to work fine. */
+	if (!phy->chandef)
+		phy->chandef = &dev->wl->hw->conf.chandef;
+
 	phy->channel = ops->get_default_chan(dev);
 
 	phy->ops->switch_analog(dev, true);
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 47b5585..92ddaa0 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -264,6 +264,7 @@ struct b43_phy {
 	unsigned long next_txpwr_check_time;
 
 	/* Current channel */
+	struct cfg80211_chan_def *chandef;
 	unsigned int channel;
 	u16 channel_freq;
 	enum nl80211_channel_type channel_type;
-- 
1.8.4.5

