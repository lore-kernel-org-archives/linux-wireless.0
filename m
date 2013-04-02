Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3436 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab3DBTGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 15:06:37 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.9 1/4] brcmfmac: fix tkip mic tx/rx ap swap bug.
Date: Tue, 2 Apr 2013 21:06:17 +0200
Message-ID: <1364929580-6206-2-git-send-email-arend@broadcom.com> (sfid-20130402_210652_436834_23396638)
In-Reply-To: <1364929580-6206-1-git-send-email-arend@broadcom.com>
References: <1364929580-6206-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

tx and rx michael tkip keys are always swapped in case being
configured per mac. This is wrong for AP. The swap should only
be done for STA mode.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 2af9c0f..3bc47ea 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1891,8 +1891,10 @@ static s32
 brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 	      u8 key_idx, const u8 *mac_addr, struct key_params *params)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_wsec_key key;
 	s32 err = 0;
+	u8 keybuf[8];
 
 	memset(&key, 0, sizeof(key));
 	key.index = (u32) key_idx;
@@ -1916,8 +1918,9 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(CONN, "Setting the key index %d\n", key.index);
 		memcpy(key.data, params->key, key.len);
 
-		if (params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-			u8 keybuf[8];
+		if ((ifp->vif->mode != WL_MODE_AP) &&
+		    (params->cipher == WLAN_CIPHER_SUITE_TKIP)) {
+			brcmf_dbg(CONN, "Swapping RX/TX MIC key\n");
 			memcpy(keybuf, &key.data[24], sizeof(keybuf));
 			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
 			memcpy(&key.data[16], keybuf, sizeof(keybuf));
@@ -2013,7 +2016,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		if (ifp->vif->mode != WL_MODE_AP) {
-			brcmf_dbg(CONN, "Swapping key\n");
+			brcmf_dbg(CONN, "Swapping RX/TX MIC key\n");
 			memcpy(keybuf, &key.data[24], sizeof(keybuf));
 			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
 			memcpy(&key.data[16], keybuf, sizeof(keybuf));
-- 
1.7.10.4


