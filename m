Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:33008 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbbCIN0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 09:26:34 -0400
Received: by labmn12 with SMTP id mn12so8871079lab.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 06:26:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix WPA crypto
Date: Mon,  9 Mar 2015 14:24:17 +0100
Message-Id: <1425907457-15118-1-git-send-email-michal.kazior@tieto.com> (sfid-20150309_142638_420654_E7B5DAD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My recent patch `ath10k: fix broken traffic for
802.1x in client mode` introduced a regression on
WPA crypto. All keys were treated as if they were
WEP which resulted in WPA being incorrectly
installed to fw/hw and subsequently no traffic.

Reported-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 44 +++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1138f4f..d65a146 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4028,6 +4028,11 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		}
 	}
 
+	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+		flags |= WMI_KEY_PAIRWISE;
+	else
+		flags |= WMI_KEY_GROUP;
+
 	if (is_wep) {
 		if (cmd == SET_KEY)
 			arvif->wep_keys[key->keyidx] = key;
@@ -4053,29 +4058,24 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		 */
 		if (cmd == SET_KEY && arvif->def_wep_key_idx == -1)
 			flags |= WMI_KEY_TX_USAGE;
-	}
 
-	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
-		flags |= WMI_KEY_PAIRWISE;
-	else
-		flags |= WMI_KEY_GROUP;
-
-	/* mac80211 uploads static WEP keys as groupwise while fw/hw requires
-	 * pairwise keys for non-self peers, i.e. BSSID in STA mode and
-	 * associated stations in AP/IBSS.
-	 *
-	 * Static WEP keys for peer_addr=vif->addr and 802.1X WEP keys work
-	 * fine when mapped directly from mac80211.
-	 *
-	 * Note: When installing first static WEP groupwise key (which should
-	 * be pairwise) def_wep_key_idx isn't known yet (it's equal to -1).
-	 * Since .set_default_unicast_key is called only for static WEP it's
-	 * used to re-upload the key as pairwise.
-	 */
-	if (arvif->def_wep_key_idx >= 0 &&
-	    memcmp(peer_addr, arvif->vif->addr, ETH_ALEN)) {
-		flags &= ~WMI_KEY_GROUP;
-		flags |= WMI_KEY_PAIRWISE;
+		/* mac80211 uploads static WEP keys as groupwise while fw/hw
+		 * requires pairwise keys for non-self peers, i.e. BSSID in STA
+		 * mode and associated stations in AP/IBSS.
+		 *
+		 * Static WEP keys for peer_addr=vif->addr and 802.1X WEP keys
+		 * work fine when mapped directly from mac80211.
+		 *
+		 * Note: When installing first static WEP groupwise key (which
+		 * should be pairwise) def_wep_key_idx isn't known yet (it's
+		 * equal to -1).  Since .set_default_unicast_key is called only
+		 * for static WEP it's used to re-upload the key as pairwise.
+		 */
+		if (arvif->def_wep_key_idx >= 0 &&
+		    memcmp(peer_addr, arvif->vif->addr, ETH_ALEN)) {
+			flags &= ~WMI_KEY_GROUP;
+			flags |= WMI_KEY_PAIRWISE;
+		}
 	}
 
 	ret = ath10k_install_key(arvif, key, cmd, peer_addr, flags);
-- 
1.8.5.3

