Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4885 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab3ABOMz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:12:55 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>, stable@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.8 2/2] brcmfmac: fix parsing rsn ie for ap mode.
Date: Wed, 2 Jan 2013 15:12:39 +0100
Message-ID: <1357135959-16696-2-git-send-email-arend@broadcom.com> (sfid-20130102_151300_869690_6644BC94)
In-Reply-To: <1357135959-16696-1-git-send-email-arend@broadcom.com>
References: <1357135959-16696-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

RSN IEs got incorrectly parsed and therefore ap mode using WPA2
security was not working.

Cc: stable@vger.kernel.org
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 1261a9b..75464ad 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3091,10 +3091,11 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 
 	len = wpa_ie->len + TLV_HDR_LEN;
 	data = (u8 *)wpa_ie;
-	offset = 0;
+	offset = TLV_HDR_LEN;
 	if (!is_rsn_ie)
 		offset += VS_IE_FIXED_HDR_LEN;
-	offset += WPA_IE_VERSION_LEN;
+	else
+		offset += WPA_IE_VERSION_LEN;
 
 	/* check for multicast cipher suite */
 	if (offset + WPA_IE_MIN_OUI_LEN > len) {
-- 
1.7.10.4


