Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:36001 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdIITaf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Sep 2017 15:30:35 -0400
Received: by mail-pg0-f45.google.com with SMTP id i130so2163358pgc.3
        for <linux-wireless@vger.kernel.org>; Sat, 09 Sep 2017 12:30:35 -0700 (PDT)
From: Kevin Cernekee <cernekee@chromium.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: [PATCH V2 3/3] brcmfmac: Add check for short event packets
Date: Sat,  9 Sep 2017 12:30:20 -0700
Message-Id: <20170909193020.19061-3-cernekee@chromium.org> (sfid-20170909_213041_390665_CEFCD62F)
In-Reply-To: <20170909193020.19061-1-cernekee@chromium.org>
References: <20170909193020.19061-1-cernekee@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The length of the data in the received skb is currently passed into
brcmf_fweh_process_event() as packet_len, but this value is not checked.
event_packet should be followed by DATALEN bytes of additional event
data.  Ensure that the received packet actually contains at least
DATALEN bytes of additional data, to avoid copying uninitialized memory
into event->data.

Suggested-by: Mattias Nissler <mnissler@chromium.org>
Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


V1->V2: No change.


diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 27e661fa356f..28361bb865f3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -424,7 +424,8 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 	if (code != BRCMF_E_IF && !fweh->evt_handler[code])
 		return;
 
-	if (datalen > BRCMF_DCMD_MAXLEN)
+	if (datalen > BRCMF_DCMD_MAXLEN ||
+	    datalen + sizeof(*event_packet) < packet_len)
 		return;
 
 	if (in_interrupt())
-- 
2.14.1.581.gf28d330327-goog
