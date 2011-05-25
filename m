Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41522 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127Ab1EYAky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 20:40:54 -0400
Received: by iyb14 with SMTP id 14so5736865iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 17:40:53 -0700 (PDT)
Message-ID: <4DDC4FFD.6000903@ring3k.org> (sfid-20110525_024056_600072_1FEE0F56)
Date: Wed, 25 May 2011 09:40:29 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] rtlwifi: Assign rx buffer ownership to hardware last
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ownership of an rx buffer should only be given to the hardware
after all other changes are written, otherwise there's
a potential race.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index fd74396..4fe405a 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -782,8 +782,6 @@ done:
 		rtlpriv->cfg->ops->set_desc((u8 *) pdesc, false,
 					    HW_DESC_RXBUFF_ADDR,
 					    (u8 *)&bufferaddress);
-		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false, HW_DESC_RXOWN,
-					    (u8 *)&tmp_one);
 		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false,
 					    HW_DESC_RXPKT_LEN,
 					    (u8 *)&rtlpci->rxbuffersize);
@@ -793,6 +791,9 @@ done:
 						    HW_DESC_RXERO,
 						    (u8 *)&tmp_one);
 
+		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false, HW_DESC_RXOWN,
+					    (u8 *)&tmp_one);
+
 		index = (index + 1) % rtlpci->rxringcount;
 	}
 
-- 
1.7.4.1


