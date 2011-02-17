Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58084 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1BQWvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:51:31 -0500
Received: by qwa26 with SMTP id 26so2838438qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 14:51:31 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org
Subject: [PATCH V2 1/3] mwl8k: fix rf_antenna rx argument for AP
Date: Thu, 17 Feb 2011 14:45:16 -0800
Message-Id: <1297982718-20377-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

When configuring rx antennas using CMD_RF_ANTENNA, the argument input is
the number of antennas to be enabled. For AP, we support 3 rx antennas
and hence set the field to 3. For tx antennas, value is a bitmap, so 0x7
enables all three.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index af4f2c6..f79da1b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3945,9 +3945,13 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 		if (rc)
 			goto out;
 
-		rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_RX, 0x7);
-		if (!rc)
-			rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_TX, 0x7);
+		rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_RX, 0x3);
+		if (rc)
+			wiphy_warn(hw->wiphy, "failed to set # of RX antennas");
+		rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_TX, 0x7);
+		if (rc)
+			wiphy_warn(hw->wiphy, "failed to set # of TX antennas");
+
 	} else {
 		rc = mwl8k_cmd_rf_tx_power(hw, conf->power_level);
 		if (rc)
-- 
1.7.0.4

