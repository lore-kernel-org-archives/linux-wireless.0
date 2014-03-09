Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:49961 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752623AbaCIVmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 17:42:32 -0400
Message-ID: <1394401348.6972.50.camel@joe-AO722> (sfid-20140309_224241_912769_1A7C1305)
Subject: Re: [PATCH 2/6] ath6kl: use braces on both arms of if statement
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Sun, 09 Mar 2014 14:42:28 -0700
In-Reply-To: <20140309065717.10793.76274.stgit@x230>
References: <20140309065606.10793.67068.stgit@x230>
	 <20140309065717.10793.76274.stgit@x230>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-09 at 08:57 +0200, Kalle Valo wrote:
> Fixes checkpatch warning:

Maybe better to check the bss value and return
early to save an indent level like:

---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 51 +++++++++++++++---------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c2c6f46..4c136e0 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -700,32 +700,33 @@ ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 	bss = cfg80211_get_bss(ar->wiphy, chan, bssid,
 			       vif->ssid, vif->ssid_len,
 			       cap_mask, cap_val);
-	if (bss == NULL) {
-		/*
-		 * Since cfg80211 may not yet know about the BSS,
-		 * generate a partial entry until the first BSS info
-		 * event becomes available.
-		 *
-		 * Prepend SSID element since it is not included in the Beacon
-		 * IEs from the target.
-		 */
-		ie = kmalloc(2 + vif->ssid_len + beacon_ie_len, GFP_KERNEL);
-		if (ie == NULL)
-			return NULL;
-		ie[0] = WLAN_EID_SSID;
-		ie[1] = vif->ssid_len;
-		memcpy(ie + 2, vif->ssid, vif->ssid_len);
-		memcpy(ie + 2 + vif->ssid_len, beacon_ie, beacon_ie_len);
-		bss = cfg80211_inform_bss(ar->wiphy, chan,
-					  bssid, 0, cap_val, 100,
-					  ie, 2 + vif->ssid_len + beacon_ie_len,
-					  0, GFP_KERNEL);
-		if (bss)
-			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
-				   "added bss %pM to cfg80211\n", bssid);
-		kfree(ie);
-	} else
+	if (!bss) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "cfg80211 already has a bss\n");
+		return NULL;
+	}
+
+	/* Since cfg80211 may not yet know about the BSS, generate a
+	 * partial entry until the first BSS info event becomes available.
+	 *
+	 * Prepend SSID element since it is not included in the Beacon
+	 * IEs from the target.
+	 */
+	ie = kmalloc(2 + vif->ssid_len + beacon_ie_len, GFP_KERNEL);
+	if (!ie)
+		return NULL;
+
+	ie[0] = WLAN_EID_SSID;
+	ie[1] = vif->ssid_len;
+	memcpy(ie + 2, vif->ssid, vif->ssid_len);
+	memcpy(ie + 2 + vif->ssid_len, beacon_ie, beacon_ie_len);
+	bss = cfg80211_inform_bss(ar->wiphy, chan, bssid, 0, cap_val, 100,
+				  ie, 2 + vif->ssid_len + beacon_ie_len,
+				  0, GFP_KERNEL);
+	if (bss)
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "added bss %pM to cfg80211\n",
+			   bssid);
+
+	kfree(ie);
 
 	return bss;
 }


