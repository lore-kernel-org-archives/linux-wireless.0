Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYLBUNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:17 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/11] iwl3945 : Fix a-band association for passive channels
Date: Tue,  2 Dec 2008 12:14:07 -0800
Message-Id: <1228248847-10424-12-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211329_837003_A082FAB2)
In-Reply-To: <1228248847-10424-11-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-7-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-8-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-9-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-10-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch does following things
    1) This patch fixes the a-band association for passive channels with new
    uCode feature that it allows direct scan on passive channels after
    auto-switch from passive to active. This enables sending of direct probes
    on passive channels, as long as some traffic is detected on that channel.
    This improves the scanning for hidden SSIDs in A-band,which is all
    passive channels.

    This patch fixes the bug no 1748.

        http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1748

    2) This fix will only work with uCode version 15.28.2.8 and above.
    Prior versions of uCode would work only if we heard the traffic within
     active dwell time, which is much shorter than passive dwell time and
    is shorter than typical beacon periods. This patch also provids full
    active dwell time even if we hear traffic late in passive dwell.

    3) uCode API version is incremented to 2.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   30 ++++++++++++++++++++------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index d6502b4..5c2c15e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -51,7 +51,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #include "iwl-3945-led.h"
 
 /* Highest firmware API version supported */
-#define IWL3945_UCODE_API_MAX 1
+#define IWL3945_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
 #define IWL3945_UCODE_API_MIN 1
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8e14607..e9e30cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4824,17 +4824,33 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 			continue;
 		}
 
+		scan_ch->active_dwell = cpu_to_le16(active_dwell);
+		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
+		/* If passive , set up for auto-switch
+		 *  and use long active_dwell time.
+		 */
 		if (!is_active || is_channel_passive(ch_info) ||
-		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
+		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN)) {
 			scan_ch->type = 0;	/* passive */
-		else
+			if (IWL_UCODE_API(priv->ucode_ver) == 1)
+				scan_ch->active_dwell = cpu_to_le16(passive_dwell - 1);
+		} else {
 			scan_ch->type = 1;	/* active */
+		}
 
-		if ((scan_ch->type & 1) && n_probes)
-			scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
-
-		scan_ch->active_dwell = cpu_to_le16(active_dwell);
-		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
+		/* Set direct probe bits. These may be used both for active
+		 * scan channels (probes gets sent right away),
+		 * or for passive channels (probes get se sent only after
+		 * hearing clear Rx packet).*/
+		if (IWL_UCODE_API(priv->ucode_ver) >= 2) {
+			if (n_probes)
+				scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
+		} else {
+			/* uCode v1 does not allow setting direct probe bits on
+			 * passive channel. */
+			if ((scan_ch->type & 1) && n_probes)
+				scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
+		}
 
 		/* Set txpower levels to defaults */
 		scan_ch->tpc.dsp_atten = 110;
-- 
1.5.4.3

