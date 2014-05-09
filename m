Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:36140 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaEIKhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 06:37:11 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Daniel Kim <dekim@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.15] brcmfmac: Fix iovar 'bw_cap' set command failure
Date: Fri, 9 May 2014 12:37:05 +0200
Message-ID: <1399631825-19319-1-git-send-email-arend@broadcom.com> (sfid-20140509_123716_916714_1E4B8656)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

Fix iovar 'bw_cap' set command failure introduced by

  commit ff3b0fba6f25555ef59c55d138a467d0f81d82d7
  Author: Arend van Spriel <arend@broadcom.com>
  Date:   Sat Mar 15 12:00:57 2014 +0100

      brcmfmac: fallback to mimo_bw_cap for older firmwares

This resulted in disabling 20MHz operation in the firmware.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

This patch fixes issue introduced by 3.15 patch. So this fix
is intended for v3.15 and applies to the master branch of the
wireless repository.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index afb3d15..be198529 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4948,7 +4948,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_if *ifp)
 	if (!err) {
 		/* only set 2G bandwidth using bw_cap command */
 		band_bwcap.band = cpu_to_le32(WLC_BAND_2G);
-		band_bwcap.bw_cap = cpu_to_le32(WLC_BW_40MHZ_BIT);
+		band_bwcap.bw_cap = cpu_to_le32(WLC_BW_CAP_40MHZ);
 		err = brcmf_fil_iovar_data_set(ifp, "bw_cap", &band_bwcap,
 					       sizeof(band_bwcap));
 	} else {
-- 
1.8.1.3

