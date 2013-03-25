Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:40418 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447Ab3CYPkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 11:40:13 -0400
From: Jonas Gorski <jogo@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
Subject: [PATCH] mwl8k: always apply configuration even when device is idle
Date: Mon, 25 Mar 2013 16:39:54 +0100
Message-Id: <1364225994-19375-1-git-send-email-jogo@openwrt.org> (sfid-20130325_164018_264244_A96E8CFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix settings not being applied when the device is idle and the firmware
gets reloaded (because of changing from STA to AP mode). This caused
the device using the wrong channel (and likely band), e.g. a 5 GHz only
card still defaulted to channel 6 in the 2.4 GHz band when left
unconfigured.

This issue was always present, but only made visible with "mwl8k: Do not
call mwl8k_cmd_set_rf_channel unconditionally" (0f4316b9), since before
that the channel was (re-)configured at the next _config call even when
it did not change from the mac80211 perspective.

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
---
 drivers/net/wireless/mwl8k.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 0640e7d..956c108 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4807,16 +4807,14 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 	struct mwl8k_priv *priv = hw->priv;
 	int rc;
 
-	if (conf->flags & IEEE80211_CONF_IDLE) {
-		mwl8k_cmd_radio_disable(hw);
-		return 0;
-	}
-
 	rc = mwl8k_fw_lock(hw);
 	if (rc)
 		return rc;
 
-	rc = mwl8k_cmd_radio_enable(hw);
+	if (conf->flags & IEEE80211_CONF_IDLE)
+		rc = mwl8k_cmd_radio_disable(hw);
+	else
+		rc = mwl8k_cmd_radio_enable(hw);
 	if (rc)
 		goto out;
 
-- 
1.7.10.4

