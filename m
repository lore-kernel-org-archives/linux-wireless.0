Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:32896 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbcEXVCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 17:02:47 -0400
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
Subject: [PATCH] brcmfmac: print error in p2p_ifadd firmware command fails
Date: Tue, 24 May 2016 23:01:49 +0200
Message-Id: <1464123728-7555-1-git-send-email-zajec5@gmail.com> (sfid-20160524_230311_826671_E3E8E5AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is helpful for debugging, without this all I was getting from "iw"
command on device with BCM43602 was:
> command failed: Too many open files in system (-23)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 1652a48..f7b7e29 100644
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
-- 
1.8.4.5

