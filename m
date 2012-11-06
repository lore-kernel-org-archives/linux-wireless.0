Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1045 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab2KFAWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:51 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 20/24] brcmfmac: return immediately error for out of
 range key_idx.
Date: Mon, 5 Nov 2012 16:22:28 -0800
Message-ID: <1352161352-30405-21-git-send-email-frankyl@broadcom.com> (sfid-20121106_012313_631331_1384F957)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

when brcmf_cfg80211_del_key was called with out of range key index
then firmware would return error. Checking was added to
brcmf_cfg80211_del_key to immediately return error.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 228fcae..4fbf5b3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1822,6 +1822,12 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
+	if (key_idx >= DOT11_MAX_DEFAULT_KEYS) {
+		/* we ignore this key index in this case */
+		WL_ERR("invalid key index (%d)\n", key_idx);
+		return -EINVAL;
+	}
+
 	memset(&key, 0, sizeof(key));
 
 	key.index = (u32) key_idx;
@@ -1832,15 +1838,6 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	/* Set the new key/index */
 	err = send_key_to_dongle(ndev, &key);
-	if (err) {
-		if (err == -EINVAL) {
-			if (key.index >= DOT11_MAX_DEFAULT_KEYS)
-				/* we ignore this key index in this case */
-				WL_ERR("invalid key index (%d)\n", key_idx);
-		}
-		/* Ignore this error, may happen during DISASSOC */
-		err = -EAGAIN;
-	}
 
 	WL_TRACE("Exit\n");
 	return err;
-- 
1.7.9.5


