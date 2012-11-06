Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4441 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2KFAWo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:44 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/24] brcmfmac: simplify if-else condition in
 brcmf_cfg80211_escan()
Date: Mon, 5 Nov 2012 16:22:10 -0800
Message-ID: <1352161352-30405-3-git-send-email-frankyl@broadcom.com> (sfid-20121106_012309_456429_9992D6E4)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Code flow was:
	err = foo();
	if (!err)
		return err;
	else
		goto exit;
	return 0;

Changed it to just to exit label if err is non-zero.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 9da9d05..f05ab77 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -966,9 +966,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	if (escan_req) {
 		err = brcmf_do_escan(cfg, wiphy, ndev, request);
-		if (!err)
-			return err;
-		else
+		if (err)
 			goto scan_out;
 	} else {
 		WL_SCAN("ssid \"%s\", ssid_len (%d)\n",
-- 
1.7.9.5


