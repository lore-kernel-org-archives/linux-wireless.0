Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4360 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab2ISUVo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/13] brcmfmac: fix bug in determining phy bands.
Date: Wed, 19 Sep 2012 22:21:13 +0200
Message-ID: <1348086078-19183-9-git-send-email-arend@broadcom.com> (sfid-20120919_222154_508277_9E301EEF)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch fixes a bug in routine where phy bands are determined.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d434934..e01ac96 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4541,7 +4541,7 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
 		return err;
 	}
 
-	phy = ((char *)&phy_list)[1];
+	phy = ((char *)&phy_list)[0];
 	WL_INFO("%c phy\n", phy);
 	if (phy == 'n' || phy == 'a') {
 		wiphy = cfg_to_wiphy(cfg_priv);
-- 
1.7.9.5


