Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:49757 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0JANC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 09:02:58 -0400
From: juuso.oikarinen@nokia.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Add validity check for beacon_crc value
Date: Fri,  1 Oct 2010 16:02:31 +0300
Message-Id: <1285938151-6306-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

On association to an AP, after receiving beacons, the beacon_crc value is set.
The beacon_crc value is not reset in disassociation, but the BSS data may be
expired at a later point. When associating again, it's possible that a
beacon for the AP is not received, resulting in the beacon_ies to remain NULL.

After association, further beacons will not update the beacon data, as the
crc value of the beacon has not changed, and the beacon_crc still holds a
value matching the beacon. The beacon_ies will remain forever null.

One of the results of this is that WLAN power save cannot be entered, the STA
will remain foreven in active mode.

Fix this by adding a validation flag for the beacon_crc, which is cleared on
association.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 945fbf2..c7aaf03 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -369,6 +369,7 @@ struct ieee80211_if_managed {
 
 	unsigned int flags;
 
+	bool beacon_crc_valid;
 	u32 beacon_crc;
 
 	enum {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 77913a1..c37086a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1639,7 +1639,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		directed_tim = ieee80211_check_tim(elems.tim, elems.tim_len,
 						   ifmgd->aid);
 
-	if (ncrc != ifmgd->beacon_crc) {
+	if (ncrc != ifmgd->beacon_crc || !ifmgd->beacon_crc_valid) {
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems,
 				      true);
 
@@ -1670,9 +1670,10 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (ncrc == ifmgd->beacon_crc)
+	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
 		return;
 	ifmgd->beacon_crc = ncrc;
+	ifmgd->beacon_crc_valid = true;
 
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		erp_valid = true;
@@ -2214,6 +2215,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
 	ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 
+	ifmgd->beacon_crc_valid = false;
+
 	for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
 		if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP ||
-- 
1.6.3.3

