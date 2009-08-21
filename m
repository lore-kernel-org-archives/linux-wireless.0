Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640AbZHUUe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/14] iwlwifi: set HT flags in ieee80211_rx_status for received packets
Date: Fri, 21 Aug 2009 13:34:21 -0700
Message-Id: <1250886867-4112-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Add code to set the HT flags (HT, 40 MHz, Short guard interval) in
the ieee80211_rx_status field passed to mac80211.  This ensures that mac80211
processes these HT packets correctly.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 353d9a2..e34d3fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -915,6 +915,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	u32 len;
 	u32 ampdu_status;
 	u16 fc;
+	u32 rate_n_flags;
 
 	/**
 	 * REPLY_RX and REPLY_RX_MPDU_CMD are handled differently.
@@ -1032,6 +1033,15 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
+	/* Set up the HT phy flags */
+	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
+	if (rate_n_flags & RATE_MCS_HT_MSK)
+		rx_status.flag |= RX_FLAG_HT;
+	if (rate_n_flags & RATE_MCS_HT40_MSK)
+		rx_status.flag |= RX_FLAG_40MHZ;
+	if (rate_n_flags & RATE_MCS_SGI_MSK)
+		rx_status.flag |= RX_FLAG_SHORT_GI;
+
 	if (iwl_is_network_packet(priv, header)) {
 		priv->last_rx_rssi = rx_status.signal;
 		priv->last_beacon_time =  priv->ucode_beacon_time;
-- 
1.5.6.3

