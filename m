Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55364 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab0BNXfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 18:35:09 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: dsd@gentoo.org, kune@deine-taler.de
Cc: linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 1/2] zd1211rw: Experimental change to add proper monitor support
Date: Mon, 15 Feb 2010 00:34:58 +0100
Message-Id: <1266190499-2387-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this patch, monitor mode does not returns all frames. With this patch,
the performance are quite poor if we create a monitor interface. Note :
creating a monitor interface with the "cook" flag has no impact on performance.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 2d555cc..9cb6cbc 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -904,8 +904,26 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct ieee80211_conf *conf = &hw->conf;
+	int ret;
 
-	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		/*
+		 * Warning : enabling this register kills RX & TX
+		 * performance
+		 */
+		u32 cr_sniffer = !!(conf->flags & IEEE80211_CONF_MONITOR);
+		ret = zd_iowrite32(&mac->chip, CR_SNIFFER_ON, cr_sniffer);
+		if (!ret)
+			return ret;
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		ret = zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
+		if (!ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static void zd_process_intr(struct work_struct *work)
-- 
1.5.6.5

