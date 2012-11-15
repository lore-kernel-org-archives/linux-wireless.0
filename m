Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3245 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227Ab2KOCqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:32 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/19] brcmfmac: restructure handling of IF event
Date: Wed, 14 Nov 2012 18:46:16 -0800
Message-ID: <1352947583-25341-13-git-send-email-frankyl@broadcom.com> (sfid-20121115_041526_944609_62818591)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The IF event need special care. It can be either an ADD, DEL, or
CHANGE. For an ADD we need to call brcmf_add_if() before the
event handler call. Upon a DEL we need to call brcmf_del_if()
after the event handler call. CHANGE does not require special
attention.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c |  102 +++++++++++++-----------
 1 file changed, 55 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 7b57b89..37f853d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -205,19 +205,40 @@ static void brcmf_fweh_queue_event(struct brcmf_fweh_info *fweh,
 	schedule_work(&fweh->event_work);
 }
 
+static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,
+					 enum brcmf_fweh_event_code code,
+					 struct brcmf_event_msg *emsg,
+					 void *data)
+{
+	struct brcmf_fweh_info *fweh;
+	int err = -EINVAL;
+
+	if (ifp) {
+		fweh = &ifp->drvr->fweh;
+
+		/* handle the event if valid interface and handler */
+		if (ifp->ndev && fweh->evt_handler[code])
+			err = fweh->evt_handler[code](ifp, emsg, data);
+		else
+			brcmf_dbg(ERROR, "unhandled event %d ignored\n", code);
+	} else {
+		brcmf_dbg(ERROR, "no interface object\n");
+	}
+	return err;
+}
+
 /**
- * brcmf_fweh_process_if_event() - handle IF event.
+ * brcmf_fweh_handle_if_event() - handle IF event.
  *
  * @drvr: driver information object.
  * @item: queue entry.
  * @ifpp: interface object (may change upon ADD action).
  */
-static int brcmf_fweh_process_if_event(struct brcmf_pub *drvr,
-				       struct brcmf_fweh_queue_item *item,
-				       struct brcmf_if **ifpp)
+static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
+				       struct brcmf_event_msg *emsg,
+				       void *data)
 {
-	struct brcmf_event_msg_be *event = &item->emsg;
-	struct brcmf_if_event *ifevent = (struct brcmf_if_event *)item->data;
+	struct brcmf_if_event *ifevent = data;
 	struct brcmf_if *ifp;
 	int err = 0;
 
@@ -228,34 +249,27 @@ static int brcmf_fweh_process_if_event(struct brcmf_pub *drvr,
 	if (ifevent->ifidx >= BRCMF_MAX_IFS) {
 		brcmf_dbg(ERROR, "invalid interface index: %u\n",
 			  ifevent->ifidx);
-		return -EINVAL;
+		return;
 	}
 
-	switch (ifevent->action) {
-	case BRCMF_E_IF_ADD:
-		brcmf_dbg(EVENT, "adding %s (%pM, %pM)\n", event->ifname,
-			  event->addr, item->ifaddr);
+	ifp = drvr->iflist[ifevent->ifidx];
+
+	if (ifevent->action == BRCMF_E_IF_ADD) {
+		brcmf_dbg(EVENT, "adding %s (%pM)\n", emsg->ifname,
+			  emsg->addr);
 		ifp = brcmf_add_if(drvr, ifevent->ifidx, ifevent->bssidx,
-				   event->ifname, item->ifaddr);
-		if (!IS_ERR(ifp)) {
-			*ifpp = ifp;
+				   emsg->ifname, emsg->addr);
+		if (IS_ERR(ifp))
+			return;
+
+		if (!drvr->fweh.evt_handler[BRCMF_E_IF])
 			err = brcmf_net_attach(ifp);
-		} else {
-			err = PTR_ERR(ifp);
-		}
-		break;
-	case BRCMF_E_IF_DEL:
-		brcmf_del_if(drvr, ifevent->ifidx);
-		break;
-	case BRCMF_E_IF_CHANGE:
-		/* nothing to do here */
-		break;
-	default:
-		brcmf_dbg(ERROR, "unknown event action: %u\n", ifevent->action);
-		err = -EBADE;
-		break;
 	}
-	return err;
+
+	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
+
+	if (ifevent->action == BRCMF_E_IF_DEL)
+		brcmf_del_if(drvr, ifevent->ifidx);
 }
 
 /**
@@ -306,13 +320,6 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 			  event->emsg.ifidx, event->emsg.bsscfgidx,
 			  event->emsg.addr);
 
-		/* handle interface event */
-		if (event->code == BRCMF_E_IF) {
-			err = brcmf_fweh_process_if_event(drvr, event, &ifp);
-			if (err)
-				goto event_free;
-		}
-
 		/* convert event message */
 		emsg_be = &event->emsg;
 		emsg.version = be16_to_cpu(emsg_be->version);
@@ -333,13 +340,14 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 				   min_t(u32, emsg.datalen, 64),
 				   "appended:");
 
-		/* handle the event if valid interface and handler */
-		if (ifp->ndev && fweh->evt_handler[event->code])
-			err = fweh->evt_handler[event->code](ifp, &emsg,
-							     event->data);
-		else
-			brcmf_dbg(ERROR, "unhandled event %d ignored\n",
-				  event->code);
+		/* special handling of interface event */
+		if (event->code == BRCMF_E_IF) {
+			brcmf_fweh_handle_if_event(drvr, &emsg, event->data);
+			goto event_free;
+		}
+
+		err = brcmf_fweh_call_event_handler(ifp, event->code, &emsg,
+						    event->data);
 		if (err) {
 			brcmf_dbg(ERROR, "event handler failed (%d)\n",
 				  event->code);
@@ -477,11 +485,11 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 	*ifidx = event_packet->msg.ifidx;
 	data = &event_packet[1];
 
-	if (code != BRCMF_E_IF && !fweh->evt_handler[code]) {
-		brcmf_dbg(EVENT, "event ignored: code=%d\n", code);
-		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), data, datalen, "event:");
+	if (code >= BRCMF_E_LAST)
+		return;
+
+	if (code != BRCMF_E_IF && !fweh->evt_handler[code])
 		return;
-	}
 
 	if (in_interrupt())
 		alloc_flag = GFP_ATOMIC;
-- 
1.7.9.5


