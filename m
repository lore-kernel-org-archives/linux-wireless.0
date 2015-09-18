Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13486 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbbIRUIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/16] brcmfmac: Only handle p2p_stop_device if vif is valid
Date: Fri, 18 Sep 2015 22:08:13 +0200
Message-ID: <1442606899-31872-11-git-send-email-arend@broadcom.com> (sfid-20150918_221654_488528_F372E3E6)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

In some situations it is possible that vif has been removed while
cfg80211 invokes the p2p_stop_device handler. This will result in
crash.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 83027dc..76e4771 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2327,11 +2327,17 @@ void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev)
 	struct brcmf_cfg80211_vif *vif;
 
 	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
-	mutex_lock(&cfg->usr_sync);
-	(void)brcmf_p2p_deinit_discovery(p2p);
-	brcmf_abort_scanning(cfg);
-	clear_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state);
-	mutex_unlock(&cfg->usr_sync);
+	/* This call can be result of the unregister_wdev call. In that case
+	 * we dont want to do anything anymore. Just return. The config vif
+	 * will have been cleared at this point.
+	 */
+	if (p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif == vif) {
+		mutex_lock(&cfg->usr_sync);
+		(void)brcmf_p2p_deinit_discovery(p2p);
+		brcmf_abort_scanning(cfg);
+		clear_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state);
+		mutex_unlock(&cfg->usr_sync);
+	}
 }
 
 /**
-- 
1.9.1

