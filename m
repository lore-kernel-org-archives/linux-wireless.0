Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:53614 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZH1J7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:59:14 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 6/8] rndis_wlan: use is_zero_ether_addr() and
	is_broadcast_ether_addr()
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 28 Aug 2009 12:59:15 +0300
Message-ID: <20090828095915.10554.78334.stgit@fate.lan>
In-Reply-To: <20090828095849.10554.58857.stgit@fate.lan>
References: <20090828095849.10554.58857.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use is_zero_ether_addr() and is_broadcast_ether_addr() instead of
memcmp against ffff_bssid/zero_bssid.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index dc3083b..c28fde5 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -514,11 +514,6 @@ static struct cfg80211_ops rndis_config_ops = {
 static void *rndis_wiphy_privid = &rndis_wiphy_privid;
 
 
-static const unsigned char zero_bssid[ETH_ALEN] = {0,};
-static const unsigned char ffff_bssid[ETH_ALEN] = { 0xff, 0xff, 0xff,
-							0xff, 0xff, 0xff };
-
-
 static struct rndis_wlan_private *get_rndis_wlan_priv(struct usbnet *dev)
 {
 	return (struct rndis_wlan_private *)dev->driver_priv;
@@ -995,7 +990,7 @@ static int is_associated(struct usbnet *usbdev)
 
 	ret = get_bssid(usbdev, bssid);
 
-	return(ret == 0 && memcmp(bssid, zero_bssid, ETH_ALEN) != 0);
+	return (ret == 0 && !is_zero_ether_addr(bssid));
 }
 
 
@@ -1293,8 +1288,8 @@ static int add_wpa_key(struct usbnet *usbdev, const u8 *key, int key_len,
 		devdbg(usbdev, "add_wpa_key: recv seq flag without buffer");
 		return -EINVAL;
 	}
-	is_addr_ok = addr && memcmp(addr, zero_bssid, ETH_ALEN) != 0 &&
-			memcmp(addr, ffff_bssid, ETH_ALEN) != 0;
+	is_addr_ok = addr && !is_zero_ether_addr(addr) &&
+					!is_broadcast_ether_addr(addr);
 	if ((flags & NDIS_80211_ADDKEY_PAIRWISE_KEY) && !is_addr_ok) {
 		devdbg(usbdev, "add_wpa_key: pairwise but bssid invalid (%pM)",
 			addr);
@@ -1379,8 +1374,8 @@ static int restore_key(struct usbnet *usbdev, int key_idx)
 		/*if (priv->encr_tx_key_index == key_idx)
 			flags |= NDIS_80211_ADDKEY_TRANSMIT_KEY;*/
 
-		if (memcmp(key.bssid, zero_bssid, ETH_ALEN) != 0 &&
-				memcmp(key.bssid, ffff_bssid, ETH_ALEN) != 0)
+		if (!is_zero_ether_addr(key.bssid) &&
+				!is_broadcast_ether_addr(key.bssid))
 			flags |= NDIS_80211_ADDKEY_PAIRWISE_KEY;
 
 		return add_wpa_key(usbdev, key.material, key.len, key_idx,
@@ -1430,7 +1425,7 @@ static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
 		remove_key.index = cpu_to_le32(index);
 		if (bssid) {
 			/* pairwise key */
-			if (memcmp(bssid, ffff_bssid, ETH_ALEN) != 0)
+			if (!is_broadcast_ether_addr(bssid))
 				remove_key.index |=
 					NDIS_80211_ADDKEY_PAIRWISE_KEY;
 			memcpy(remove_key.bssid, bssid,

