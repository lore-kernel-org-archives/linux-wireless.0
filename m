Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:35784 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138Ab1DEKa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 06:30:58 -0400
Subject: [PATCH] mwl8k: Do not configure tx power unconditionally
From: Nishant Sarmukadam <nishants@marvell.com>
Reply-To: nishants@marvell.com
To: <linux-wireless@vger.kernel.org>
CC: <buytenh@wantstofly.org>
Content-Type: text/plain
Date: Tue, 5 Apr 2011 14:18:09 +0530
Message-ID: <1301993289.3447.41.camel@localhost.localdomain>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of configuring tx power unconditionally, check for
IEEE80211_CONF_CHANGE_POWER and configure it only when stack
sets this flag

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 53920f3..45b1704 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4463,9 +4463,12 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 		conf->power_level = 18;
 
 	if (priv->ap_fw) {
-		rc = mwl8k_cmd_tx_power(hw, conf, conf->power_level);
-		if (rc)
-			goto out;
+
+		if (conf->flags & IEEE80211_CONF_CHANGE_POWER) {
+			rc = mwl8k_cmd_tx_power(hw, conf, conf->power_level);
+			if (rc)
+				goto out;
+		}
 
 		rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_RX, 0x3);
 		if (rc)
-- 
1.6.0.3



