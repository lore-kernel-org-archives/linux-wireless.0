Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2948 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbZAUFbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 00:31:31 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/5] iwlwifi: fix rs_get_rate WARN_ON()
Date: Tue, 20 Jan 2009 21:33:51 -0800
Message-Id: <1232516035-25524-2-git-send-email-reinette.chatre@intel.com> (sfid-20090121_063155_215958_B402F697)
In-Reply-To: <1232516035-25524-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232516035-25524-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abbas, Mohamed <mohamed.abbas@intel.com>

In ieee80211_sta structure there is u64 supp_rates[IEEE80211_NUM_BANDS]
this is filled with all support rate from assoc_resp.  If we associate
with G-band AP only supp_rates of G-band will be set the other band
supp_rates will be set to 0. If the user type this command
this will cause mac80211 to set to new channel, mac80211
does not disassociate in setting new channel, so the active
band is now A-band. then in handling the new essid mac80211 will
kick in the assoc steps which involve sending disassociation frame.
in this mac80211 will WARN_ON sta->supp_rates[A_BAND] == 0.

This fixes:
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1822
http://www.kerneloops.org/searchweek.php?search=rs_get_rate

Signed-off-by: mohamed abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   14 +++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   14 ++++++++++++--
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index ba64034..25b4356 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -649,12 +649,16 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	s8 scale_action = 0;
 	unsigned long flags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	u16 fc, rate_mask;
+	u16 fc;
+	u16 rate_mask = 0;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	IWL_DEBUG_RATE("enter\n");
 
+	if (sta)
+		rate_mask = sta->supp_rates[sband->band];
+
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
 	fc = le16_to_cpu(hdr->frame_control);
@@ -662,11 +666,15 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	    is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !priv_sta) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
-		info->control.rates[0].idx = rate_lowest_index(sband, sta);
+		if (!rate_mask)
+			info->control.rates[0].idx =
+					rate_lowest_index(sband, NULL);
+		else
+			info->control.rates[0].idx =
+					rate_lowest_index(sband, sta);
 		return;
 	}
 
-	rate_mask = sta->supp_rates[sband->band];
 	index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT_3945 - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 4c460b1..a82cce5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -945,7 +945,8 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	}
 
 	/* See if there's a better rate or modulation mode to try. */
-	rs_rate_scale_perform(priv, hdr, sta, lq_sta);
+	if (sta && sta->supp_rates[sband->band])
+		rs_rate_scale_perform(priv, hdr, sta, lq_sta);
 out:
 	return;
 }
@@ -2105,14 +2106,23 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	int rate_idx;
+	u64 mask_bit = 0;
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
+	if (sta)
+		mask_bit = sta->supp_rates[sband->band];
+
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
 	if (!ieee80211_is_data(hdr->frame_control) ||
 	    is_multicast_ether_addr(hdr->addr1) || !sta || !lq_sta) {
-		info->control.rates[0].idx = rate_lowest_index(sband, sta);
+		if (!mask_bit)
+			info->control.rates[0].idx =
+					rate_lowest_index(sband, NULL);
+		else
+			info->control.rates[0].idx =
+					rate_lowest_index(sband, sta);
 		return;
 	}
 
-- 
1.5.4.3

