Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2017 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab2JVRgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:41 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/14] brcmfmac: change parameter list for
 send_key_to_dongle()
Date: Mon, 22 Oct 2012 10:36:26 -0700
Message-ID: <1350927387-25608-14-git-send-email-frankyl@broadcom.com> (sfid-20121022_193656_803536_202B0742)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The first two parameters given to send_key_to_dongle() are redundant
so they have been removed.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   25 ++++---------------
 1 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 61d9489..71bc310 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -432,8 +432,7 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 }
 
 static int
-send_key_to_dongle(struct brcmf_cfg80211_info *cfg, s32 bssidx,
-		   struct net_device *ndev, struct brcmf_wsec_key *key)
+send_key_to_dongle(struct net_device *ndev, struct brcmf_wsec_key *key)
 {
 	int err;
 	struct brcmf_wsec_key_le key_le;
@@ -1556,7 +1555,6 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	struct brcmf_wsec_key key;
 	s32 val;
 	s32 err = 0;
-	s32 bssidx;
 
 	WL_CONN("key len (%d)\n", sme->key_len);
 
@@ -1599,8 +1597,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	WL_CONN("key length (%d) key index (%d) algo (%d)\n",
 		key.len, key.index, key.algo);
 	WL_CONN("key \"%s\"\n", key.data);
-	bssidx = brcmf_find_bssidx(cfg, ndev);
-	err = send_key_to_dongle(cfg, bssidx, ndev, &key);
+	err = send_key_to_dongle(ndev, &key);
 	if (err)
 		return err;
 
@@ -1846,10 +1843,8 @@ static s32
 brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 	      u8 key_idx, const u8 *mac_addr, struct key_params *params)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_wsec_key key;
 	s32 err = 0;
-	s32 bssidx;
 
 	memset(&key, 0, sizeof(key));
 	key.index = (u32) key_idx;
@@ -1858,11 +1853,10 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 	if (!is_multicast_ether_addr(mac_addr))
 		memcpy((char *)&key.ea, (void *)mac_addr, ETH_ALEN);
 	key.len = (u32) params->key_len;
-	bssidx = brcmf_find_bssidx(cfg, ndev);
 	/* check for key index change */
 	if (key.len == 0) {
 		/* key delete */
-		err = send_key_to_dongle(cfg, bssidx, ndev, &key);
+		err = send_key_to_dongle(ndev, &key);
 		if (err)
 			WL_ERR("key delete error (%d)\n", err);
 	} else {
@@ -1917,7 +1911,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 			WL_ERR("Invalid cipher (0x%x)\n", params->cipher);
 			return -EINVAL;
 		}
-		err = send_key_to_dongle(cfg, bssidx, ndev, &key);
+		err = send_key_to_dongle(ndev, &key);
 		if (err)
 			WL_ERR("wsec_key error (%d)\n", err);
 	}
@@ -1935,7 +1929,6 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	s32 wsec;
 	s32 err = 0;
 	u8 keybuf[8];
-	s32 bssidx;
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
@@ -1997,8 +1990,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	bssidx = brcmf_find_bssidx(cfg, ndev);
-	err = send_key_to_dongle(cfg, bssidx, ndev, &key);
+	err = send_key_to_dongle(ndev, &key);
 	if (err)
 		goto done;
 
@@ -2023,10 +2015,8 @@ static s32
 brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_wsec_key key;
 	s32 err = 0;
-	s32 bssidx;
 
 	WL_TRACE("Enter\n");
 	if (!check_sys_up(wiphy))
@@ -2041,8 +2031,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	WL_CONN("key index (%d)\n", key_idx);
 
 	/* Set the new key/index */
-	bssidx = brcmf_find_bssidx(cfg, ndev);
-	err = send_key_to_dongle(cfg, bssidx, ndev, &key);
+	err = send_key_to_dongle(ndev, &key);
 	if (err) {
 		if (err == -EINVAL) {
 			if (key.index >= DOT11_MAX_DEFAULT_KEYS)
@@ -2068,7 +2057,6 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
 	s32 err = 0;
-	s32 bssidx;
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
@@ -2077,7 +2065,6 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	memset(&params, 0, sizeof(params));
 
-	bssidx = brcmf_find_bssidx(cfg, ndev);
 	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wsec", &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
-- 
1.7.6


