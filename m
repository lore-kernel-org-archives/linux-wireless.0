Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34722 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbaFUKLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 06:11:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/8] brcmfmac: clear ht info during attach phase
Date: Sat, 21 Jun 2014 12:11:14 +0200
Message-ID: <1403345479-13467-4-git-send-email-arend@broadcom.com> (sfid-20140621_121128_757528_92AA85E0)
In-Reply-To: <1403345479-13467-1-git-send-email-arend@broadcom.com>
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After updating 2G bandwidth capability clear ht info. This will be properly
set upon calling brcmf_update_wiphy_bands().

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index db3d848..6bbd708 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5051,6 +5051,9 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
 						      BRCMF_OBSS_COEX_AUTO);
 	}
+	/* clear for now and rely on update later */
+	wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.ht_supported = false;
+	wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap = 0;
 
 	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
 	if (err) {
-- 
1.7.9.5

