Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2020 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab2IJNRT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 09:17:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/10] brcmfmac: fix big endian bug in i-scan.
Date: Mon, 10 Sep 2012 15:16:54 +0200
Message-ID: <1347283018-24223-7-git-send-email-arend@broadcom.com> (sfid-20120910_151727_214609_4B02BE0D)
In-Reply-To: <1347283018-24223-1-git-send-email-arend@broadcom.com>
References: <1347283018-24223-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

ssid len is 32 bit and needs endian conversion for big endian systems.

Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 4a27ca0..6623f48 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -501,8 +501,10 @@ static void brcmf_iscan_prep(struct brcmf_scan_params_le *params_le,
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


