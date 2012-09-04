Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2IDRlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 13:41:32 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlwifi: fix antenna bitmask
Date: Tue,  4 Sep 2012 19:42:08 +0200
Message-Id: <1346780528-2352-1-git-send-email-johannes@sipsolutions.net> (sfid-20120904_194134_412057_D16D112F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The device only supports a maximum of three
antennas, and only three bits are used, the
fourth bit is the A-MPDU indicator.

The only consequence of this is reporting
invalid information in radiotap, so this
isn't an important change.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/commands.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index 4a361c5..cee8a05 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -1055,7 +1055,7 @@ struct iwl_wep_cmd {
 #define RX_RES_PHY_FLAGS_MOD_CCK_MSK		cpu_to_le16(1 << 1)
 #define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	cpu_to_le16(1 << 2)
 #define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
-#define RX_RES_PHY_FLAGS_ANTENNA_MSK		0xf0
+#define RX_RES_PHY_FLAGS_ANTENNA_MSK		0x70
 #define RX_RES_PHY_FLAGS_ANTENNA_POS		4
 
 #define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
-- 
1.7.10.4

