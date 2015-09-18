Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13486 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbIRUI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:28 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 16/16] brcmfmac: Accept events when TDLS is used in combination with p2p.
Date: Fri, 18 Sep 2015 22:08:19 +0200
Message-ID: <1442606899-31872-17-git-send-email-arend@broadcom.com> (sfid-20150918_220833_173158_0D41818B)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

TDLS events are mapped back to primary interface but when p2p is in
use then this fails because the check was incorrect by checking
bsscfg number. Which can be different when a p2p device has been
created.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 81542e0..383d6fa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -300,8 +300,7 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 			goto event_free;
 		}
 
-		if ((event->code == BRCMF_E_TDLS_PEER_EVENT) &&
-		    (emsg.bsscfgidx == 1))
+		if (event->code == BRCMF_E_TDLS_PEER_EVENT)
 			ifp = drvr->iflist[0];
 		else
 			ifp = drvr->iflist[emsg.bsscfgidx];
-- 
1.9.1

