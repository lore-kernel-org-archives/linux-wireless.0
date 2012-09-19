Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3867 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab2ISUVo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/13] brcmfmac: remove unused function.
Date: Wed, 19 Sep 2012 22:21:12 +0200
Message-ID: <1348086078-19183-8-git-send-email-arend@broadcom.com> (sfid-20120919_222156_123107_427BA33D)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

clean up code.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 2f0a103..d434934 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4708,20 +4708,3 @@ s32 brcmf_cfg80211_down(struct brcmf_cfg80211_dev *cfg_dev)
 	return err;
 }
 
-static __used s32 brcmf_add_ie(struct brcmf_cfg80211_priv *cfg_priv,
-			       u8 t, u8 l, u8 *v)
-{
-	struct brcmf_cfg80211_ie *ie = &cfg_priv->ie;
-	s32 err = 0;
-
-	if (ie->offset + l + 2 > WL_TLV_INFO_MAX) {
-		WL_ERR("ei crosses buffer boundary\n");
-		return -ENOSPC;
-	}
-	ie->buf[ie->offset] = t;
-	ie->buf[ie->offset + 1] = l;
-	memcpy(&ie->buf[ie->offset + 2], v, l);
-	ie->offset += l + 2;
-
-	return err;
-}
-- 
1.7.9.5


