Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1674 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab2K1Uoc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:32 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/11] brcmfmac: change debug output for received event.
Date: Wed, 28 Nov 2012 21:44:14 +0100
Message-ID: <1354135454-7035-12-git-send-email-arend@broadcom.com> (sfid-20121128_214442_296379_5F871B76)
In-Reply-To: <1354135454-7035-1-git-send-email-arend@broadcom.com>
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

see header.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index fa8fc44..7a00c46 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -314,7 +314,7 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 	while ((event = brcmf_fweh_dequeue_event(fweh))) {
 		ifp = drvr->iflist[event->ifidx];
 
-		brcmf_dbg(EVENT, "event %s (%u) ifidx %u bsscfg %u addr %pM:\n",
+		brcmf_dbg(EVENT, "event %s (%u) ifidx %u bsscfg %u addr %pM\n",
 			  brcmf_fweh_event_name(event->code), event->code,
 			  event->emsg.ifidx, event->emsg.bsscfgidx,
 			  event->emsg.addr);
@@ -337,7 +337,7 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 			  emsg.version, emsg.flags, emsg.status, emsg.reason);
 		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), event->data,
 				   min_t(u32, emsg.datalen, 64),
-				   "appended:");
+				   "event payload, len=%d\n", emsg.datalen);
 
 		/* special handling of interface event */
 		if (event->code == BRCMF_E_IF) {
-- 
1.7.10.4


