Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12657 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176AbZJBUtt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/13] iwlwifi: fix compile warning
Date: Fri,  2 Oct 2009 13:43:57 -0700
Message-Id: <1254516247-4085-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Fixes following on big endian systems:
  CC [M]  drivers/net/wireless/iwlwifi/iwl-rx.o
  drivers/net/wireless/iwlwifi/iwl-rx.c: In function ‘iwl_rx_reply_rx’:
  drivers/net/wireless/iwlwifi/iwl-rx.c:1029: warning: integer overflow in
  expression

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reported-by: Marcel Holtmann <marcel@holtmann.org>
Tested-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 33e40c2..7bf447e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -610,7 +610,7 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	if (rx_status.band == IEEE80211_BAND_5GHZ)
 		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
 
-	rx_status.antenna = le16_to_cpu(rx_hdr->phy_flags &
+	rx_status.antenna = (le16_to_cpu(rx_hdr->phy_flags) &
 					RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
 
 	/* set the preamble flag if appropriate */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e5f40f3..ba3e4c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1164,7 +1164,7 @@ struct iwl_wep_cmd {
 #define RX_RES_PHY_FLAGS_MOD_CCK_MSK		cpu_to_le16(1 << 1)
 #define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	cpu_to_le16(1 << 2)
 #define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
-#define RX_RES_PHY_FLAGS_ANTENNA_MSK		cpu_to_le16(0xf0)
+#define RX_RES_PHY_FLAGS_ANTENNA_MSK		0xf0
 #define RX_RES_PHY_FLAGS_ANTENNA_POS		4
 
 #define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8e1bb53..493626b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1044,7 +1044,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	 * as a bitmask.
 	 */
 	rx_status.antenna =
-		le16_to_cpu(phy_res->phy_flags & RX_RES_PHY_FLAGS_ANTENNA_MSK)
+		(le16_to_cpu(phy_res->phy_flags) & RX_RES_PHY_FLAGS_ANTENNA_MSK)
 		>> RX_RES_PHY_FLAGS_ANTENNA_POS;
 
 	/* set the preamble flag if appropriate */
-- 
1.5.6.3

