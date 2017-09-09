Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:37461 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdIITae (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Sep 2017 15:30:34 -0400
Received: by mail-pg0-f54.google.com with SMTP id d8so9527772pgt.4
        for <linux-wireless@vger.kernel.org>; Sat, 09 Sep 2017 12:30:34 -0700 (PDT)
From: Kevin Cernekee <cernekee@chromium.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: [PATCH V2 2/3] brcmfmac: Delete redundant length check
Date: Sat,  9 Sep 2017 12:30:19 -0700
Message-Id: <20170909193020.19061-2-cernekee@chromium.org> (sfid-20170909_213038_750594_15599EB9)
In-Reply-To: <20170909193020.19061-1-cernekee@chromium.org>
References: <20170909193020.19061-1-cernekee@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_fweh_process_event() sets event->datalen to the
endian-swapped value of event_packet->msg.datalen, which is the
same as emsg.datalen.  This length is already validated in
brcmf_fweh_process_event(), so there is no need to check it
again upon dequeuing the event.

Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 5 -----
 1 file changed, 5 deletions(-)


V1->V2: Delete the check instead of moving it.


diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 4eb1e1ce9ace..27e661fa356f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -257,11 +257,6 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), event->data,
 				   min_t(u32, emsg.datalen, 64),
 				   "event payload, len=%d\n", emsg.datalen);
-		if (emsg.datalen > event->datalen) {
-			brcmf_err("event invalid length header=%d, msg=%d\n",
-				  event->datalen, emsg.datalen);
-			goto event_free;
-		}
 
 		/* special handling of interface event */
 		if (event->code == BRCMF_E_IF) {
-- 
2.14.1.581.gf28d330327-goog
