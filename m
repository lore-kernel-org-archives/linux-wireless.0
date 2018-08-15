Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr720123.outbound.protection.outlook.com ([40.107.72.123]:16697
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbeHONZ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 09:25:26 -0400
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
Subject: [PATCH 2/2] brcmfmac: add 4-way handshake offload detection for FT-802.1X
Date: Wed, 15 Aug 2018 05:32:40 -0500
Message-Id: <1534329160-131774-3-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180815_123352_844832_3A8FDD33)
In-Reply-To: <1534329160-131774-1-git-send-email-chi-hsien.lin@cypress.com>
References: <1534329160-131774-1-git-send-email-chi-hsien.lin@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

Add 4-way handshake offload detection for FT with EAP authentication.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f56d76de0812..8bc031eed4fd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1651,6 +1651,8 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			break;
 		case WLAN_AKM_SUITE_FT_8021X:
 			val = WPA2_AUTH_UNSPECIFIED | WPA2_AUTH_FT;
+			if (sme->want_1x)
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_1X;
 			break;
 		case WLAN_AKM_SUITE_FT_PSK:
 			val = WPA2_AUTH_PSK | WPA2_AUTH_FT;
-- 
2.1.0
