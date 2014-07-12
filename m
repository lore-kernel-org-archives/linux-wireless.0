Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:43613 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaGLGtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:49:46 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 9/9] brcmfmac: add brcmf_p2p_detach() call in brcmf_cfg80211_detach()
Date: Sat, 12 Jul 2014 08:49:42 +0200
Message-ID: <1405147782-12768-10-git-send-email-arend@broadcom.com> (sfid-20140712_085013_260542_A87355EC)
In-Reply-To: <1405147782-12768-1-git-send-email-arend@broadcom.com>
References: <1405147782-12768-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_p2p_detach() was only called in error flow of the
brcmf_cfg80211_attach() routine, but it also needs to be called
upon brcmf_cfg80211_detach().

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d3bb4e0..48078a3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5682,6 +5682,7 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	WARN_ON(!list_empty(&cfg->vif_list));
 	wiphy_unregister(cfg->wiphy);
 	brcmf_btcoex_detach(cfg);
+	brcmf_p2p_detach(&cfg->p2p);
 	wl_deinit_priv(cfg);
 	brcmf_free_wiphy(cfg->wiphy);
 }
-- 
1.9.1

