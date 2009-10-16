Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZJPFUn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:20:43 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/16] iwmc3200wifi: Update statistics notification structure
Date: Fri, 16 Oct 2009 13:18:51 +0800
Message-Id: <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

The latest firmware adds a ht_rates and a chain_energy field. The latter is
needed as we want to eventually support RSSI/antenna handling.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/umac.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/umac.h b/drivers/net/wireless/iwmc3200wifi/umac.h
index c5a14ae..be90354 100644
--- a/drivers/net/wireless/iwmc3200wifi/umac.h
+++ b/drivers/net/wireless/iwmc3200wifi/umac.h
@@ -687,6 +687,9 @@ struct iwm_umac_notif_rx_ticket {
 /* Tx/Rx rates window (number of max of last update window per second) */
 #define UMAC_NTF_RATE_SAMPLE_NR	4
 
+/* Max numbers of bits required to go through all antennae in bitmasks */
+#define UMAC_PHY_NUM_CHAINS     3
+
 #define IWM_UMAC_MGMT_TID	8
 #define IWM_UMAC_TID_NR		8
 
@@ -697,9 +700,11 @@ struct iwm_umac_notif_stats {
 	__le16 tid_load[IWM_UMAC_TID_NR + 2]; /* 1 non-QoS + 1 dword align */
 	__le16 tx_rate[UMAC_NTF_RATE_SAMPLE_NR];
 	__le16 rx_rate[UMAC_NTF_RATE_SAMPLE_NR];
+	__le32 chain_energy[UMAC_PHY_NUM_CHAINS];
 	s32 rssi_dbm;
 	s32 noise_dbm;
 	__le32 supp_rates;
+	__le32 supp_ht_rates;
 	__le32 missed_beacons;
 	__le32 rx_beacons;
 	__le32 rx_dir_pkts;
-- 
1.6.0.4

