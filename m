Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZJPFVa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:21:30 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 16/16] iwmc3200wifi: handle coexistence radio notification
Date: Fri, 16 Oct 2009 13:19:00 +0800
Message-Id: <1255670340-22565-17-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-16-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-9-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-10-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-11-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-12-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-13-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-14-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-15-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-16-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle WiFi/WiMax coexistence radio preemption notification event.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 95deb0a..bdb1d7e 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -733,6 +733,19 @@ static int iwm_mlme_update_sta_table(struct iwm_priv *iwm, u8 *buf,
 	return 0;
 }
 
+static int iwm_mlme_medium_lost(struct iwm_priv *iwm, u8 *buf,
+				unsigned long buf_size,
+				struct iwm_wifi_cmd *cmd)
+{
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
+
+	IWM_DBG_NTF(iwm, DBG, "WiFi/WiMax coexistence radio is OFF\n");
+
+	wiphy_rfkill_set_hw_state(wiphy, true);
+
+	return 0;
+}
+
 static int iwm_mlme_update_bss_table(struct iwm_priv *iwm, u8 *buf,
 				     unsigned long buf_size,
 				     struct iwm_wifi_cmd *cmd)
@@ -919,6 +932,8 @@ static int iwm_ntf_mlme(struct iwm_priv *iwm, u8 *buf,
 	case WIFI_IF_NTFY_EXTENDED_IE_REQUIRED:
 		IWM_DBG_MLME(iwm, DBG, "Extended IE required\n");
 		break;
+	case WIFI_IF_NTFY_RADIO_PREEMPTION:
+		return iwm_mlme_medium_lost(iwm, buf, buf_size, cmd);
 	case WIFI_IF_NTFY_BSS_TRK_TABLE_CHANGED:
 		return iwm_mlme_update_bss_table(iwm, buf, buf_size, cmd);
 	case WIFI_IF_NTFY_BSS_TRK_ENTRIES_REMOVED:
-- 
1.6.0.4

