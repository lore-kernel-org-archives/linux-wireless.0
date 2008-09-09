Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYIIC7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 22:59:05 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/3] iwl3945 : Code cleanup
Date: Tue,  9 Sep 2008 10:54:52 +0800
Message-Id: <1220928894-17998-2-git-send-email-yi.zhu@intel.com> (sfid-20080909_045918_035731_9116D851)
In-Reply-To: <1220928894-17998-1-git-send-email-yi.zhu@intel.com>
References: <1220928894-17998-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Simplify pass_packet_to_mac80211 code block.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 1377c81..3d100e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -681,19 +681,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 		priv->last_rx_noise = rx_status.noise;
 	}
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
-		return;
-	}
-
-	switch (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FTYPE) {
-	case IEEE80211_FTYPE_MGMT:
-	case IEEE80211_FTYPE_DATA:
-		/* fall through */
-	default:
-		iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
-		break;
-	}
+	iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
 }
 
 int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl3945_priv *priv, void *ptr,
-- 
1.5.3.6

