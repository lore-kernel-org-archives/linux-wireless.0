Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr720123.outbound.protection.outlook.com ([40.107.72.123]:16697
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727141AbeHONYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 09:24:45 -0400
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Subject: [PATCH 1/2] brcmfmac: add FT-based AKMs in brcmf_set_key_mgmt() for FT support
Date: Wed, 15 Aug 2018 05:32:39 -0500
Message-Id: <1534329160-131774-2-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180815_123312_126363_BBBA8426)
In-Reply-To: <1534329160-131774-1-git-send-email-chi-hsien.lin@cypress.com>
References: <1534329160-131774-1-git-send-email-chi-hsien.lin@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

Add WLAN_AKM_SUITE_FT_8021X and WLAN_AKM_SUITE_FT_PSK in
brcmf_set_key_mgmt() for FT support.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 6 ++++++
 drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 24c4e18e7d80..f56d76de0812 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1649,6 +1649,12 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 		case WLAN_AKM_SUITE_PSK:
 			val = WPA2_AUTH_PSK;
 			break;
+		case WLAN_AKM_SUITE_FT_8021X:
+			val = WPA2_AUTH_UNSPECIFIED | WPA2_AUTH_FT;
+			break;
+		case WLAN_AKM_SUITE_FT_PSK:
+			val = WPA2_AUTH_PSK | WPA2_AUTH_FT;
+			break;
 		default:
 			brcmf_err("invalid cipher group (%d)\n",
 				  sme->crypto.cipher_group);
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h
index 7b9a77981df1..91fca79e6158 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h
@@ -237,6 +237,7 @@ static inline bool ac_bitmap_tst(u8 bitmap, int prec)
 #define WPA2_AUTH_RESERVED4	0x0400
 #define WPA2_AUTH_RESERVED5	0x0800
 #define WPA2_AUTH_1X_SHA256	0x1000  /* 1X with SHA256 key derivation */
+#define WPA2_AUTH_FT		0x4000	/* Fast BSS Transition */
 #define WPA2_AUTH_PSK_SHA256	0x8000	/* PSK with SHA256 key derivation */
 
 #define DOT11_DEFAULT_RTS_LEN		2347
-- 
2.1.0
