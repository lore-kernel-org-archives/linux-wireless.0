Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1153 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933276Ab2KOCqg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/19] brcmfmac: correct handling IF firmware event
Date: Wed, 14 Nov 2012 18:46:10 -0800
Message-ID: <1352947583-25341-7-git-send-email-frankyl@broadcom.com> (sfid-20121115_041528_854464_BB9BE048)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Testing revealed the IF ADD event contains the interface
index of the new interface. This would result in a NULL
pointer access when handling the event.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c |   66 +++++++++++-------------
 1 file changed, 31 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 825be26..e1521af 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -191,42 +191,13 @@ static const char *brcmf_fweh_event_name(enum brcmf_fweh_event_code code)
 /**
  * brcmf_fweh_queue_event() - create and queue event.
  *
- * @ifp: firmware interface object.
- * @code: event code.
- * @pkt: event ether packet.
+ * @fweh: firmware event handling info.
+ * @event: event queue entry.
  */
-static void brcmf_fweh_queue_event(struct brcmf_if *ifp,
-				   enum brcmf_fweh_event_code code,
-				   struct brcmf_event *pkt)
+static void brcmf_fweh_queue_event(struct brcmf_fweh_info *fweh,
+				   struct brcmf_fweh_queue_item *event)
 {
-	struct brcmf_fweh_info *fweh = &ifp->drvr->fweh;
-	struct brcmf_fweh_queue_item *event;
-	gfp_t alloc_flag = GFP_KERNEL;
 	ulong flags;
-	void *data;
-	u32 datalen;
-
-	/* determine event data */
-	datalen = get_unaligned_be32(&pkt->msg.datalen);
-	data = &pkt[1];
-
-	if (!ifp->ndev || (code != BRCMF_E_IF && !fweh->evt_handler[code])) {
-		brcmf_dbg(EVENT, "event ignored: code=%d\n", code);
-		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), data, datalen, "event:");
-		return;
-	}
-
-	if (in_interrupt())
-		alloc_flag = GFP_ATOMIC;
-
-	event = kzalloc(sizeof(*event) + datalen, alloc_flag);
-	event->code = code;
-	event->ifidx = ifp->idx;
-
-	/* use memcpy to get aligned event message */
-	memcpy(&event->emsg, &pkt->msg, sizeof(event->emsg));
-	memcpy(event->data, data, datalen);
-	memcpy(event->ifaddr, pkt->eth.h_dest, ETH_ALEN);
 
 	spin_lock_irqsave(&fweh->evt_q_lock, flags);
 	list_add_tail(&event->q, &fweh->event_q);
@@ -489,10 +460,35 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 			      struct brcmf_event *event_packet, u8 *ifidx)
 {
 	enum brcmf_fweh_event_code code;
+	struct brcmf_fweh_info *fweh = &drvr->fweh;
+	struct brcmf_fweh_queue_item *event;
+	gfp_t alloc_flag = GFP_KERNEL;
+	void *data;
+	u32 datalen;
 
-	/* determine event code and interface index */
+	/* get event info */
 	code = get_unaligned_be32(&event_packet->msg.event_type);
+	datalen = get_unaligned_be32(&event_packet->msg.datalen);
 	*ifidx = event_packet->msg.ifidx;
+	data = &event_packet[1];
+
+	if (code != BRCMF_E_IF && !fweh->evt_handler[code]) {
+		brcmf_dbg(EVENT, "event ignored: code=%d\n", code);
+		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), data, datalen, "event:");
+		return;
+	}
+
+	if (in_interrupt())
+		alloc_flag = GFP_ATOMIC;
+
+	event = kzalloc(sizeof(*event) + datalen, alloc_flag);
+	event->code = code;
+	event->ifidx = *ifidx;
+
+	/* use memcpy to get aligned event message */
+	memcpy(&event->emsg, &event_packet->msg, sizeof(event->emsg));
+	memcpy(event->data, data, datalen);
+	memcpy(event->ifaddr, event_packet->eth.h_dest, ETH_ALEN);
 
-	brcmf_fweh_queue_event(drvr->iflist[*ifidx], code, event_packet);
+	brcmf_fweh_queue_event(fweh, event);
 }
-- 
1.7.9.5


