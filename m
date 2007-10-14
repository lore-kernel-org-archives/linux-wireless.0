Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24399 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbXJNUWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 16:22:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/5] iwlwifi: remove cck_flag from iwl_driver_hw_info
Date: Sun, 14 Oct 2007 22:20:30 +0200
Message-Id: <11923932343888-git-send-email-tomas.winkler@intel.com> (sfid-20071014_212229_277737_8C7586B5)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove cck_flag from iwl_driver_hw_info, this flag
is unused

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ++++--
 drivers/net/wireless/iwlwifi/iwlwifi.h      |    3 +--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 0f6ef76..fecc008 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2211,7 +2211,6 @@ int iwl_hw_set_hw_setting(struct iwl_priv *priv)
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	priv->hw_setting.cck_flag = 0;
 	priv->hw_setting.max_stations = IWL3945_STATION_COUNT;
 	priv->hw_setting.bcast_sta_id = IWL3945_BROADCAST_ID;
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1bfa50f..9b274f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1722,8 +1722,6 @@ int iwl_hw_set_hw_setting(struct iwl_priv *priv)
 
 	priv->hw_setting.max_txq_num = iwl_param_queues_num;
 	priv->hw_setting.ac_queue_count = AC_NUM;
-
-	priv->hw_setting.cck_flag = RATE_MCS_CCK_MSK;
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index b601455..7cbfa93 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -507,8 +507,10 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
 	station->sta.sta.sta_id = index;
 	station->sta.station_flags = 0;
 
-	rate = (priv->phymode == MODE_IEEE80211A) ? IWL_RATE_6M_PLCP :
-				IWL_RATE_1M_PLCP | priv->hw_setting.cck_flag;
+	if (priv->phymode == MODE_IEEE80211A)
+		rate = IWL_RATE_6M_PLCP;
+	else
+		rate =	IWL_RATE_1M_PLCP;
 
 	/* Turn on both antennas for the station... */
 	station->sta.rate_n_flags =
diff --git a/drivers/net/wireless/iwlwifi/iwlwifi.h b/drivers/net/wireless/iwlwifi/iwlwifi.h
index e0b97c3..a6983bf 100644
--- a/drivers/net/wireless/iwlwifi/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi/iwlwifi.h
@@ -532,11 +532,10 @@ struct iwl_ibss_seq {
 struct iwl_driver_hw_info {
 	u16 max_txq_num;
 	u16 ac_queue_count;
-	u32 rx_buffer_size;
 	u16 tx_cmd_len;
 	u16 max_rxq_size;
+	u32 rx_buffer_size;
 	u16 max_rxq_log;
-	u32 cck_flag;
 	u8  max_stations;
 	u8  bcast_sta_id;
 	void *shared_virt;
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
