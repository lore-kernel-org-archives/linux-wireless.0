Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:51406 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbbIRUI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/16] brcmfmac: Make p2pon module param always available.
Date: Fri, 18 Sep 2015 22:08:10 +0200
Message-ID: <1442606899-31872-8-git-send-email-arend@broadcom.com> (sfid-20150918_220831_691685_F9F77C5C)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

p2pon module param is currently under define BRCMDBG. Though it is
a needed option for older versions of the wpa_supplicant which do not
support the P2P_DEVICE interface.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 3b169f5..031283a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -62,10 +62,8 @@ MODULE_PARM_DESC(debug, "level of debug output");
 
 /* P2P0 enable */
 static int brcmf_p2p_enable;
-#ifdef CONFIG_BRCMDBG
 module_param_named(p2pon, brcmf_p2p_enable, int, 0);
-MODULE_PARM_DESC(p2pon, "enable p2p management functionality");
-#endif
+MODULE_PARM_DESC(p2pon, "enable legacy p2p management functionality");
 
 char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 {
-- 
1.9.1

