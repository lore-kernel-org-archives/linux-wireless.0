Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:33048 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbcEYW6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2016 18:58:35 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V3] brcmfmac: print error if p2p_ifadd firmware command fails
Date: Thu, 26 May 2016 00:44:55 +0200
Message-Id: <1464216299-25232-1-git-send-email-zajec5@gmail.com> (sfid-20160526_005900_130227_5F86DC51)
In-Reply-To: <1464123910-8281-1-git-send-email-zajec5@gmail.com>
References: <1464123910-8281-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is helpful for debugging, without this all I was getting from "iw"
command on device with BCM43602 was:
> command failed: Too many open files in system (-23)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: s/in/if/ in commit message
V3: Add one more error message as suggested by Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 1652a48..bc26aec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2031,7 +2031,7 @@ static int brcmf_p2p_request_p2p_if(struct brcmf_p2p_info *p2p,
 	err = brcmf_fil_iovar_data_set(ifp, "p2p_ifadd", &if_request,
 				       sizeof(if_request));
 	if (err)
-		return err;
+		brcmf_err("p2p_ifadd failed %d\n", err);
 
 	return err;
 }
@@ -2185,6 +2185,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	err = brcmf_p2p_request_p2p_if(&cfg->p2p, ifp, cfg->p2p.int_addr,
 				       iftype);
 	if (err) {
+		brcmf_err("Failed to request P2P virtual interface %s\n", name);
 		brcmf_cfg80211_arm_vif_event(cfg, NULL);
 		goto fail;
 	}
-- 
1.8.4.5

