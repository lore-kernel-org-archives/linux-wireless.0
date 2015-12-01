Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbbLAKAA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 05:00:00 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/41] iwlwifi: mvm: Align bt-coex priority with requirements
Date: Tue,  1 Dec 2015 11:59:00 +0200
Message-Id: <1448963947-24302-34-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110010_467857_F3A09D5B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Fix the gaps between the system requirements and our code.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c | 36 ++++++++++++++++-----------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 808f234..c9ca029 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -901,6 +901,7 @@ u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac)
 {
 	__le16 fc = hdr->frame_control;
+	bool mplut_enabled = iwl_mvm_is_mplut_supported(mvm);
 
 	if (info->band != IEEE80211_BAND_2GHZ)
 		return 0;
@@ -908,22 +909,27 @@ u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 	if (unlikely(mvm->bt_tx_prio))
 		return mvm->bt_tx_prio - 1;
 
-	/* High prio packet (wrt. BT coex) if it is EAPOL, MCAST or MGMT */
-	if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO ||
-	     is_multicast_ether_addr(hdr->addr1) ||
-	     ieee80211_is_ctl(fc) || ieee80211_is_mgmt(fc) ||
-	     ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc))
+	if (likely(ieee80211_is_data(fc))) {
+		if (likely(ieee80211_is_data_qos(fc))) {
+			switch (ac) {
+			case IEEE80211_AC_BE:
+				return mplut_enabled ? 1 : 0;
+			case IEEE80211_AC_VI:
+				return mplut_enabled ? 2 : 3;
+			case IEEE80211_AC_VO:
+				return 3;
+			default:
+				return 0;
+			}
+		} else if (is_multicast_ether_addr(hdr->addr1)) {
+			return 3;
+		} else
+			return 0;
+	} else if (ieee80211_is_mgmt(fc)) {
+		return ieee80211_is_disassoc(fc) ? 0 : 3;
+	} else if (ieee80211_is_ctl(fc)) {
+		/* ignore cfend and cfendack frames as we never send those */
 		return 3;
-
-	switch (ac) {
-	case IEEE80211_AC_BE:
-		return 1;
-	case IEEE80211_AC_VO:
-		return 3;
-	case IEEE80211_AC_VI:
-		return 2;
-	default:
-		break;
 	}
 
 	return 0;
-- 
2.5.0

