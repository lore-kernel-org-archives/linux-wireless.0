Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbbLAJ7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:53 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/41] iwlwifi: mvm: use firmware station lookup, combine code
Date: Tue,  1 Dec 2015 11:58:55 +0200
Message-Id: <1448963947-24302-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110002_313100_06914D29)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In most cases, the firmware will already match the station that
we received a given frame from and tell us the station ID in the
RX status, so we can look up the station from that. This lets us
skip the (more expensive) hash table lookup in mac80211.

Also change the fallback case (no station info from the firmware)
to not attempt to look up a multicast source address.

While at it, also combine all the code using the station into a
single if block.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        | 43 ++++++++++++++--------
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index 9b7e49d..d790322 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -229,7 +229,8 @@ enum iwl_mvm_rx_status {
 	RX_MPDU_RES_STATUS_CSUM_DONE			= BIT(16),
 	RX_MPDU_RES_STATUS_CSUM_OK			= BIT(17),
 	RX_MPDU_RES_STATUS_HASH_INDEX_MSK		= (0x3F0000),
-	RX_MPDU_RES_STATUS_STA_ID_MSK			= (0x1f000000),
+	RX_MDPU_RES_STATUS_STA_ID_SHIFT			= 24,
+	RX_MPDU_RES_STATUS_STA_ID_MSK			= 0x1f << RX_MDPU_RES_STATUS_STA_ID_SHIFT,
 	RX_MPDU_RES_STATUS_RRF_KILL			= BIT(29),
 	RX_MPDU_RES_STATUS_FILTERING_MSK		= (0xc00000),
 	RX_MPDU_RES_STATUS2_FILTERING_MSK		= (0xc0000000),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index d1d50ff..a0e957a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -61,6 +61,7 @@
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *****************************************************************************/
+#include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include "iwl-trans.h"
 #include "mvm.h"
@@ -262,7 +263,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rx_phy_info *phy_info;
 	struct iwl_rx_mpdu_res_start *rx_res;
-	struct ieee80211_sta *sta;
+	struct ieee80211_sta *sta = NULL;
 	struct sk_buff *skb;
 	u32 len;
 	u32 ampdu_status;
@@ -333,22 +334,33 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 			      (unsigned long long)rx_status->mactime);
 
 	rcu_read_lock();
-	/*
-	 * We have tx blocked stations (with CS bit). If we heard frames from
-	 * a blocked station on a new channel we can TX to it again.
-	 */
-	if (unlikely(mvm->csa_tx_block_bcn_timeout)) {
-		sta = ieee80211_find_sta(
-			rcu_dereference(mvm->csa_tx_blocked_vif), hdr->addr2);
-		if (sta)
-			iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, false);
+	if (rx_pkt_status & RX_MPDU_RES_STATUS_SRC_STA_FOUND) {
+		u32 id = rx_pkt_status & RX_MPDU_RES_STATUS_STA_ID_MSK;
+
+		id >>= RX_MDPU_RES_STATUS_STA_ID_SHIFT;
+
+		if (!WARN_ON_ONCE(id >= IWL_MVM_STATION_COUNT)) {
+			sta = rcu_dereference(mvm->fw_id_to_mac_id[id]);
+			if (IS_ERR(sta))
+				sta = NULL;
+		}
+	} else if (!is_multicast_ether_addr(hdr->addr2)) {
+		/* This is fine since we prevent two stations with the same
+		 * address from being added.
+		 */
+		sta = ieee80211_find_sta_by_ifaddr(mvm->hw, hdr->addr2, NULL);
 	}
 
-	/* This is fine since we don't support multiple AP interfaces */
-	sta = ieee80211_find_sta_by_ifaddr(mvm->hw, hdr->addr2, NULL);
 	if (sta) {
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
+		/* We have tx blocked stations (with CS bit). If we heard
+		 * frames from a blocked station on a new channel we can
+		 * TX to it again.
+		 */
+		if (unlikely(mvm->csa_tx_block_bcn_timeout))
+			iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, false);
+
 		rs_update_last_rssi(mvm, &mvmsta->lq_sta, rx_status);
 
 		if (iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_RSSI) &&
@@ -369,11 +381,10 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 			if (trig_check && rx_status->signal < rssi)
 				iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL);
 		}
-	}
-
-	if (sta && ieee80211_is_data(hdr->frame_control))
-		iwl_mvm_rx_csum(sta, skb, rx_pkt_status);
 
+		if (ieee80211_is_data(hdr->frame_control))
+			iwl_mvm_rx_csum(sta, skb, rx_pkt_status);
+	}
 	rcu_read_unlock();
 
 	/* set the preamble flag if appropriate */
-- 
2.5.0

