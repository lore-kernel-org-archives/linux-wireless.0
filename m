Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1664 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162000Ab3DEI6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/16] brcmfmac: remove condition for calling event
 handler
Date: Fri, 5 Apr 2013 10:57:46 +0200
Message-ID: <1365152274-4252-9-git-send-email-arend@broadcom.com> (sfid-20130405_105823_345947_E53EEFDB)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In fweh module the event handler was only called if the
struct brcmf_if instance had a non-null netdev associated.
This restriction is no longer valid for P2P_DEVICE type
of interface. This patch removes that restriction.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 9672b99..51ba13d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -156,7 +156,7 @@ static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,
 		fweh = &ifp->drvr->fweh;
 
 		/* handle the event if valid interface and handler */
-		if (ifp->ndev && fweh->evt_handler[code])
+		if (fweh->evt_handler[code])
 			err = fweh->evt_handler[code](ifp, emsg, data);
 		else
 			brcmf_err("unhandled event %d ignored\n", code);
-- 
1.7.10.4


