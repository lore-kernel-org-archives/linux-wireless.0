Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:21622 "EHLO
        mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755151AbcIOLlj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 07:41:39 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: stable@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] brcmfmac: avoid potential stack overflow in brcmf_cfg80211_start_ap()
Date: Thu, 15 Sep 2016 12:41:31 +0100
Message-Id: <1473939694-11006-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160915_134143_419338_C8BFAA70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit ded89912156b1a47d940a0c954c43afbabd0c42c upstream

User-space can choose to omit NL80211_ATTR_SSID and only provide raw
IE TLV data. When doing so it can provide SSID IE with length exceeding
the allowed size. The driver further processes this IE copying it
into a local variable without checking the length. Hence stack can be
corrupted and used as exploit.

Cc: stable@vger.kernel.org # v4.4, v4.1
Reported-by: Daxing Guo <freener.gdx@gmail.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 5db56a7..b8aec5e5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -4527,7 +4527,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 				(u8 *)&settings->beacon.head[ie_offset],
 				settings->beacon.head_len - ie_offset,
 				WLAN_EID_SSID);
-		if (!ssid_ie)
+		if (!ssid_ie || ssid_ie->len > IEEE80211_MAX_SSID_LEN)
 			return -EINVAL;
 
 		memcpy(ssid_le.SSID, ssid_ie->data, ssid_ie->len);
-- 
1.9.1
