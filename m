Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25507 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYHOCE7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:59 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 12/15] iwl3945: replace association and beacon hooks with bss_info_changed cb
Date: Fri, 15 Aug 2008 10:01:17 +0800
Message-Id: <1218765680-8378-13-git-send-email-yi.zhu@intel.com> (sfid-20080815_040505_180185_58455D23)
In-Reply-To: <1218765680-8378-12-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-3-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-4-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-5-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-6-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-7-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-8-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-9-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-10-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-11-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-12-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Let mac80211 and bss_info_changed callback handle the association and
beacon changes.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   81 -------------------------------
 1 files changed, 0 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 6e7ad0a..163470a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -689,87 +689,6 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 
 	switch (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_MGMT:
-		switch (le16_to_cpu(header->frame_control) &
-			IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_PROBE_RESP:
-		case IEEE80211_STYPE_BEACON:{
-				/* If this is a beacon or probe response for
-				 * our network then cache the beacon
-				 * timestamp */
-				if ((((priv->iw_mode == IEEE80211_IF_TYPE_STA)
-				      && !compare_ether_addr(header->addr2,
-							     priv->bssid)) ||
-				     ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
-				      && !compare_ether_addr(header->addr3,
-							     priv->bssid)))) {
-					struct ieee80211_mgmt *mgmt =
-					    (struct ieee80211_mgmt *)header;
-					__le32 *pos;
-					pos = (__le32 *)&mgmt->u.beacon.
-					    timestamp;
-					priv->timestamp0 = le32_to_cpu(pos[0]);
-					priv->timestamp1 = le32_to_cpu(pos[1]);
-					priv->beacon_int = le16_to_cpu(
-					    mgmt->u.beacon.beacon_int);
-					if (priv->call_post_assoc_from_beacon &&
-					    (priv->iw_mode ==
-						IEEE80211_IF_TYPE_STA))
-						queue_work(priv->workqueue,
-						    &priv->post_associate.work);
-
-					priv->call_post_assoc_from_beacon = 0;
-				}
-
-				break;
-			}
-
-		case IEEE80211_STYPE_ACTION:
-			/* TODO: Parse 802.11h frames for CSA... */
-			break;
-
-			/*
-			 * TODO: Use the new callback function from
-			 * mac80211 instead of sniffing these packets.
-			 */
-		case IEEE80211_STYPE_ASSOC_RESP:
-		case IEEE80211_STYPE_REASSOC_RESP:{
-				struct ieee80211_mgmt *mgnt =
-				    (struct ieee80211_mgmt *)header;
-
-				/* We have just associated, give some
-				 * time for the 4-way handshake if
-				 * any. Don't start scan too early. */
-				priv->next_scan_jiffies = jiffies +
-					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
-
-				priv->assoc_id = (~((1 << 15) | (1 << 14)) &
-						  le16_to_cpu(mgnt->u.
-							      assoc_resp.aid));
-				priv->assoc_capability =
-				    le16_to_cpu(mgnt->u.assoc_resp.capab_info);
-				if (priv->beacon_int)
-					queue_work(priv->workqueue,
-					    &priv->post_associate.work);
-				else
-					priv->call_post_assoc_from_beacon = 1;
-				break;
-			}
-
-		case IEEE80211_STYPE_PROBE_REQ:{
-				DECLARE_MAC_BUF(mac1);
-				DECLARE_MAC_BUF(mac2);
-				DECLARE_MAC_BUF(mac3);
-				if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
-					IWL_DEBUG_DROP
-					    ("Dropping (non network): %s"
-					     ", %s, %s\n",
-					     print_mac(mac1, header->addr1),
-					     print_mac(mac2, header->addr2),
-					     print_mac(mac3, header->addr3));
-				return;
-			}
-		}
-
 	case IEEE80211_FTYPE_DATA:
 		/* fall through */
 	default:
-- 
1.5.3.6

