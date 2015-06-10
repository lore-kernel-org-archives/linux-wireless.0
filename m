Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:25612 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbbFJWMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 18:12:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/7] brcmfmac: free ifp for non-netdev interface in p2p module
Date: Thu, 11 Jun 2015 00:12:21 +0200
Message-ID: <1433974343-16982-6-git-send-email-arend@broadcom.com> (sfid-20150611_001256_785345_9628387C)
In-Reply-To: <1433974343-16982-1-git-send-email-arend@broadcom.com>
References: <1433974343-16982-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Making it more clear by freeing the ifp in same place where the
vif object is freed.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 2 --
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c  | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index f8f47dc..8cf4a1e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -867,8 +867,6 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 		}
 		/* unregister will take care of freeing it */
 		unregister_netdev(ifp->ndev);
-	} else {
-		kfree(ifp);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 710fbe5..abcaa77 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2238,6 +2238,7 @@ static void brcmf_p2p_delete_p2pdev(struct brcmf_p2p_info *p2p,
 {
 	cfg80211_unregister_wdev(&vif->wdev);
 	p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif = NULL;
+	kfree(vif->ifp);
 	brcmf_free_vif(vif);
 }
 
@@ -2364,6 +2365,8 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 		break;
 
 	case NL80211_IFTYPE_P2P_DEVICE:
+		brcmf_p2p_cancel_remain_on_channel(vif->ifp);
+		brcmf_p2p_deinit_discovery(p2p);
 		brcmf_p2p_delete_p2pdev(p2p, vif);
 		return 0;
 	default:
-- 
1.9.1

