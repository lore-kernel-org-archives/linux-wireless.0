Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:37915 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756936AbdIHTOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 15:14:12 -0400
Received: by mail-pg0-f42.google.com with SMTP id v66so6247756pgb.5
        for <linux-wireless@vger.kernel.org>; Fri, 08 Sep 2017 12:14:11 -0700 (PDT)
From: Kevin Cernekee <cernekee@chromium.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: [PATCH 2/3] brcmfmac: Don't print out-of-bounds event data
Date: Fri,  8 Sep 2017 12:13:41 -0700
Message-Id: <20170908191342.28053-3-cernekee@chromium.org> (sfid-20170908_211423_544504_3A0D8229)
In-Reply-To: <20170908191342.28053-1-cernekee@chromium.org>
References: <20170908191342.28053-1-cernekee@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debug print that dumps out newly-dequeued events uses emsg.datalen
before that field has been validated, which may lead to an out-of-bounds
read.  Assume that any properly-formed event message has a valid length
field, and move the debug print below the length check.

Suggested-by: Mattias Nissler <mnissler@chromium.org>
Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 4eb1e1ce9ace..5aabdc9ed7e0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -252,17 +252,17 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 		emsg.ifidx = emsg_be->ifidx;
 		emsg.bsscfgidx = emsg_be->bsscfgidx;
 
-		brcmf_dbg(EVENT, "  version %u flags %u status %u reason %u\n",
-			  emsg.version, emsg.flags, emsg.status, emsg.reason);
-		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), event->data,
-				   min_t(u32, emsg.datalen, 64),
-				   "event payload, len=%d\n", emsg.datalen);
 		if (emsg.datalen > event->datalen) {
 			brcmf_err("event invalid length header=%d, msg=%d\n",
 				  event->datalen, emsg.datalen);
 			goto event_free;
 		}
 
+		brcmf_dbg(EVENT, "  version %u flags %u status %u reason %u\n",
+			  emsg.version, emsg.flags, emsg.status, emsg.reason);
+		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), event->data,
+				   min_t(u32, emsg.datalen, 64),
+				   "event payload, len=%d\n", emsg.datalen);
 		/* special handling of interface event */
 		if (event->code == BRCMF_E_IF) {
 			brcmf_fweh_handle_if_event(drvr, &emsg, event->data);
-- 
2.14.1.581.gf28d330327-goog
