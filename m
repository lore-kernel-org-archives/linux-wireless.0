Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3439 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933035Ab3DBTGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 15:06:37 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.9 3/4] brcmfmac: fix returning cipher_suite for
 get_key operation.
Date: Tue, 2 Apr 2013 21:06:19 +0200
Message-ID: <1364929580-6206-4-git-send-email-arend@broadcom.com> (sfid-20130402_210654_878559_1B17D15D)
In-Reply-To: <1364929580-6206-1-git-send-email-arend@broadcom.com>
References: <1364929580-6206-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When multiple cipher suites have been programmed then the lowest
suite is to be retured. This fixes issue when AP mode is using
CCMP and TKIP WPA combination where rekeying will fail.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index b9dbf2c..ec46fff 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2121,8 +2121,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 		err = -EAGAIN;
 		goto done;
 	}
-	switch (wsec & ~SES_OW_ENABLED) {
-	case WEP_ENABLED:
+	if (wsec & WEP_ENABLED) {
 		sec = &profile->sec;
 		if (sec->cipher_pairwise & WLAN_CIPHER_SUITE_WEP40) {
 			params.cipher = WLAN_CIPHER_SUITE_WEP40;
@@ -2131,16 +2130,13 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 			params.cipher = WLAN_CIPHER_SUITE_WEP104;
 			brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_WEP104\n");
 		}
-		break;
-	case TKIP_ENABLED:
+	} else if (wsec & TKIP_ENABLED) {
 		params.cipher = WLAN_CIPHER_SUITE_TKIP;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_TKIP\n");
-		break;
-	case AES_ENABLED:
+	} else if (wsec & AES_ENABLED) {
 		params.cipher = WLAN_CIPHER_SUITE_AES_CMAC;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_AES_CMAC\n");
-		break;
-	default:
+	} else  {
 		brcmf_err("Invalid algo (0x%x)\n", wsec);
 		err = -EINVAL;
 		goto done;
-- 
1.7.10.4


