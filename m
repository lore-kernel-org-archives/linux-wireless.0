Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4090 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab2IKTRQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 15:17:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	stable <stable@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/2] brcmfmac: fix big endian bug in i-scan.
Date: Tue, 11 Sep 2012 21:16:47 +0200
Message-ID: <1347391008-10583-2-git-send-email-arend@broadcom.com> (sfid-20120911_211719_307194_233692AF)
In-Reply-To: <1347391008-10583-1-git-send-email-arend@broadcom.com>
References: <1347391008-10583-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

ssid len is 32 bit and needs endian conversion for big endian systems.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c36e923..50b5553 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -500,8 +500,10 @@ static void wl_iscan_prep(struct brcmf_scan_params_le *params_le,
 	params_le->active_time = cpu_to_le32(-1);
 	params_le->passive_time = cpu_to_le32(-1);
 	params_le->home_time = cpu_to_le32(-1);
-	if (ssid && ssid->SSID_len)
-		memcpy(&params_le->ssid_le, ssid, sizeof(struct brcmf_ssid));
+	if (ssid && ssid->SSID_len) {
+		params_le->ssid_le.SSID_len = cpu_to_le32(ssid->SSID_len);
+		memcpy(&params_le->ssid_le.SSID, ssid->SSID, ssid->SSID_len);
+	}
 }
 
 static s32
-- 
1.7.9.5


