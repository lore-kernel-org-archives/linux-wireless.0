Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:43354 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbbBFRhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 12:37:05 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/6] brcmfmac: Remove error print for invalid key index.
Date: Fri, 6 Feb 2015 18:36:43 +0100
Message-ID: <1423244207-9707-3-git-send-email-arend@broadcom.com> (sfid-20150206_183717_774443_C5592010)
In-Reply-To: <1423244207-9707-1-git-send-email-arend@broadcom.com>
References: <1423244207-9707-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When a key is set or cleared with an unsupported key index then
brcmfmac will print an error. With most wpa_supplicants this is
happening a lot. The error print is confusing and not needed.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index b59b8c6..bc86009 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -2252,7 +2252,6 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (key_idx >= BRCMF_MAX_DEFAULT_KEYS) {
 		/* we ignore this key index in this case */
-		brcmf_err("invalid key index (%d)\n", key_idx);
 		return -EINVAL;
 	}
 
-- 
1.9.1

