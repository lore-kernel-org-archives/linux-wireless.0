Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46568 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbZA0SdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 13:33:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: stable@kernel.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.28-stable] iwlwifi: fix rs_get_rate WARN_ON()
Date: Tue, 27 Jan 2009 10:36:15 -0800
Message-Id: <1233081375-17580-1-git-send-email-reinette.chatre@intel.com> (sfid-20090127_193327_472992_71C996CB)
In-Reply-To: <>
References: <>
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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This patch can be found in Linus's repo as commit
c338ba3ca5bef2df2082d9e8d336ff7b2880c326. It fixes a WARN
message that has the driver on the front page of kerneloops.org.


 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   14 +++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   14 ++++++++++++--
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 9b60a0c..21c8418 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -638,12 +638,16 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	s8 scale_action = 0;
 	unsigned long flags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	u16 fc, rate_mask;
+	u16 fc;
+	u16 rate_mask = 0;
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_r;
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_RATE("enter\n");
 
+	if (sta)
+		rate_mask = sta->supp_rates[sband->band];
+
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
 	fc = le16_to_cpu(hdr->frame_control);
@@ -651,11 +655,13 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	    is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !priv_sta) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
-		sel->rate_idx = rate_lowest_index(sband, sta);
+		if (!rate_mask)
+			sel->rate_idx = rate_lowest_index(sband, NULL);
+		else
+			sel->rate_idx = rate_lowest_index(sband, sta);
 		return;
 	}
 
-	rate_mask = sta->supp_rates[sband->band];
 	index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index f3f1792..27f5047 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -944,7 +944,8 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	}
 
 	/* See if there's a better rate or modulation mode to try. */
-	rs_rate_scale_perform(priv, hdr, sta, lq_sta);
+	if (sta && sta->supp_rates[sband->band])
+		rs_rate_scale_perform(priv, hdr, sta, lq_sta);
 out:
 	return;
 }
@@ -2101,15 +2102,22 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc;
 	struct iwl_lq_sta *lq_sta;
+	u64 mask_bit = 0;
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
+	if (sta)
+		mask_bit = sta->supp_rates[sband->band];
+
 	/* Send management frames and broadcast/multicast data using lowest
 	 * rate. */
 	fc = hdr->frame_control;
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !priv_sta) {
-		sel->rate_idx = rate_lowest_index(sband, sta);
+		if (!mask_bit)
+			sel->rate_idx = rate_lowest_index(sband, NULL);
+		else
+			sel->rate_idx = rate_lowest_index(sband, sta);
 		return;
 	}
 
-- 
1.5.4.3

