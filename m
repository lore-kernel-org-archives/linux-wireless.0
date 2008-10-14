Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYJNTfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:35:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 7/9] iwl3945 : Fix a-band association for passive channels
Date: Tue, 14 Oct 2008 12:32:47 -0700
Message-Id: <1224012769-8920-8-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213529_086644_B03F15A6)
In-Reply-To: <1224012769-8920-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-4-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-5-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-6-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

This patch fixes the a-band association for passive channels.
This fix will only work with uCode version 15.28.1.8 and above.
uCode API version is incremented to 2.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   22 +++++++++++++++-------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index bdd3247..c124e9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -54,7 +54,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
  *   *only* when uCode interface or architecture changes so that it
  *   is not compatible with earlier drivers.
  * This number will also appear in << 8 position of 1st dword of uCode file */
-#define IWL3945_UCODE_API "-1"
+#define IWL3945_UCODE_API "-2"
 
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ce12609..4bd92c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4876,18 +4876,26 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 			continue;
 		}
 
+		/* If passive , set up for auto-switch
+		 *  and use long active_dwell time.
+		 */
 		if (!is_active || is_channel_passive(ch_info) ||
-		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
+		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN)) {
 			scan_ch->type = 0;	/* passive */
-		else
+			scan_ch->active_dwell = cpu_to_le16(passive_dwell - 1);
+		} else {
 			scan_ch->type = 1;	/* active */
+			scan_ch->active_dwell = cpu_to_le16(active_dwell);
+		}
+		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
 
-		if ((scan_ch->type & 1) && n_probes)
+		/* Set direct probe bits. These may be used both for active
+		 * scan channels (probes gets sent right away),
+		 * or for passive channels (probes get se sent only after
+		 * hearing clear Rx packet).*/
+		if (n_probes)
 			scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
 
-		scan_ch->active_dwell = cpu_to_le16(active_dwell);
-		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
-
 		/* Set txpower levels to defaults */
 		scan_ch->tpc.dsp_atten = 110;
 		/* scan_pwr_info->tpc.dsp_atten; */
@@ -6100,7 +6108,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	int rc = 0;
 	struct iwl3945_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
-	u8 n_probes = 2;
+	u8 n_probes = 0;
 	enum ieee80211_band band;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
-- 
1.5.4.3

