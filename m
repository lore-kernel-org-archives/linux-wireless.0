Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:62469 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbbBHKwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 05:52:08 -0500
Received: by mail-wg0-f54.google.com with SMTP id l18so5557677wgh.13
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 02:52:06 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: respect reason when deleting (deauthenticating) STA
Date: Sun,  8 Feb 2015 11:51:47 +0100
Message-Id: <1423392707-12417-1-git-send-email-zajec5@gmail.com> (sfid-20150208_115212_230206_730B0FF4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Starting with kernel 3.19 reason is provided by cfg80211.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index b59b8c6..a23bfaa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -4272,7 +4272,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	memcpy(&scbval.ea, params->mac, ETH_ALEN);
-	scbval.val = cpu_to_le32(WLAN_REASON_DEAUTH_LEAVING);
+	scbval.val = cpu_to_le32(params->reason_code);
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
 				     &scbval, sizeof(scbval));
 	if (err)
-- 
1.8.4.5

