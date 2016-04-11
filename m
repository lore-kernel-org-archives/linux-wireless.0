Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8031 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbcDKJp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 05:45:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/8] brcmfmac: clear eventmask array before using it
Date: Mon, 11 Apr 2016 11:35:21 +0200
Message-Id: <1460367328-12082-2-git-send-email-arend@broadcom.com> (sfid-20160411_114531_756211_1530F7A7)
In-Reply-To: <1460367328-12082-1-git-send-email-arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

When the event_msgs iovar is set an array is used to configure the
enabled events. This arrays needs to nulled before configuring
otherwise unhandled events will be enabled. This solves a problem
where in case of wowl the host got woken by an incorrectly enabled
event.

Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index d414fbb..b390561 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -371,6 +371,7 @@ int brcmf_fweh_activate_events(struct brcmf_if *ifp)
 	int i, err;
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 
+	memset(eventmask, 0, sizeof(eventmask));
 	for (i = 0; i < BRCMF_E_LAST; i++) {
 		if (ifp->drvr->fweh.evt_handler[i]) {
 			brcmf_dbg(EVENT, "enable event %s\n",
-- 
1.9.1

