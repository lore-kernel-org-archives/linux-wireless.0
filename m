Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44241 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaSxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 14:53:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlagn: avoid sleep in softirq context
Date: Fri, 31 Oct 2008 13:58:24 -0400
Message-Id: <1225475904-25184-1-git-send-email-linville@tuxdriver.com> (sfid-20081031_195336_378707_3338F8C3)
In-Reply-To: <1225399265.1115.356.camel@rc-desk>
References: <1225399265.1115.356.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__ieee80211_tasklet_handler -> __ieee80211_rx ->
	__ieee80211_rx_handle_packet -> ieee80211_invoke_rx_handlers ->
	ieee80211_rx_h_decrypt -> ieee80211_crypto_tkip_decrypt ->
	ieee80211_tkip_decrypt_data -> iwl4965_mac_update_tkip_key ->
	iwl_scan_cancel_timeout -> msleep

Ooops!

Avoid the sleep by changing iwl_scan_cancel_timeout with
iwl_scan_cancel and simply returning on failure if the scan persists.
This will cause hardware decryption to fail and we'll handle a few more
frames with software decryption.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 89450e3..5cca7bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3247,7 +3247,12 @@ static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 		return;
 	}
 
-	iwl_scan_cancel_timeout(priv, 100);
+	if (iwl_scan_cancel(priv)) {
+		/* cancel scan failed, just live w/ bad key and rely
+		   briefly on SW decrpyption */
+		IWL_DEBUG_MAC80211("leave - failed to cancel scan\n");
+		return;
+	}
 
 	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-- 
1.5.4.3

