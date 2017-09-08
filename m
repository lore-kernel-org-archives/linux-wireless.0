Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35623 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756928AbdIHTON (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 15:14:13 -0400
Received: by mail-pf0-f175.google.com with SMTP id g13so5880886pfm.2
        for <linux-wireless@vger.kernel.org>; Fri, 08 Sep 2017 12:14:13 -0700 (PDT)
From: Kevin Cernekee <cernekee@chromium.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: [PATCH 3/3] brcmfmac: Add check for short event packets
Date: Fri,  8 Sep 2017 12:13:42 -0700
Message-Id: <20170908191342.28053-4-cernekee@chromium.org> (sfid-20170908_211423_167752_D009AB9C)
In-Reply-To: <20170908191342.28053-1-cernekee@chromium.org>
References: <20170908191342.28053-1-cernekee@chromium.org>
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
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 5aabdc9ed7e0..4cad1f0d2a82 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -429,7 +429,8 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 	if (code != BRCMF_E_IF && !fweh->evt_handler[code])
 		return;
 
-	if (datalen > BRCMF_DCMD_MAXLEN)
+	if (datalen > BRCMF_DCMD_MAXLEN ||
+	    datalen + sizeof(*event_packet) < packet_len)
 		return;
 
 	if (in_interrupt())
-- 
2.14.1.581.gf28d330327-goog
