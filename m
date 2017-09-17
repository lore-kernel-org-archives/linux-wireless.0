Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:45146 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdIQEIb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 00:08:31 -0400
Received: by mail-pg0-f42.google.com with SMTP id 188so3423843pgb.2
        for <linux-wireless@vger.kernel.org>; Sat, 16 Sep 2017 21:08:31 -0700 (PDT)
From: Kevin Cernekee <cernekee@chromium.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: [PATCH V3 2/3] brcmfmac: Delete redundant length check
Date: Sat, 16 Sep 2017 21:08:23 -0700
Message-Id: <20170917040824.22237-2-cernekee@chromium.org> (sfid-20170917_060839_008063_A3DC271D)
In-Reply-To: <20170917040824.22237-1-cernekee@chromium.org>
References: <20170917040824.22237-1-cernekee@chromium.org>
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


V2->V3: No change


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
2.14.1.690.gbb1197296e-goog
