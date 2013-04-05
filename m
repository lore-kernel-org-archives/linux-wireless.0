Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1571 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162002Ab3DEI6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/16] brcmfmac: only use ifidx from BDC header in
 brcmf_rx_frames()
Date: Fri, 5 Apr 2013 10:57:54 +0200
Message-ID: <1365152274-4252-17-git-send-email-arend@broadcom.com> (sfid-20130405_105819_847261_9A55928B)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_rx_frames() the call to brcmf_fweh_process_skb() could
change the ifidx using information in the event data. This is
only different to the BDC ifidx for IF ADD event. However, the
creation of the new interface is deferred to event worker so
it does not exist. After brcmf_fweh_process_skb() it is only
used to set statistics.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    9 ++-------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c      |    6 ++----
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h      |    6 +++---
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index e68500b..763a84e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -323,13 +323,8 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 		/* Strip header, count, deliver upward */
 		skb_pull(skb, ETH_HLEN);
 
-		/* Process special event packets and then discard them */
-		brcmf_fweh_process_skb(drvr, skb, &ifidx);
-
-		if (drvr->iflist[ifidx]) {
-			ifp = drvr->iflist[ifidx];
-			ifp->ndev->last_rx = jiffies;
-		}
+		/* Process special event packets */
+		brcmf_fweh_process_skb(drvr, skb);
 
 		if (!(ifp->ndev->flags & IFF_UP)) {
 			brcmu_pkt_buf_free_skb(skb);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 51ba13d..5a64280 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -407,13 +407,12 @@ int brcmf_fweh_activate_events(struct brcmf_if *ifp)
  *
  * @drvr: driver information object.
  * @event_packet: event packet to process.
- * @ifidx: index of the firmware interface (may change).
  *
  * If the packet buffer contains a firmware event message it will
  * dispatch the event to a registered handler (using worker).
  */
 void brcmf_fweh_process_event(struct brcmf_pub *drvr,
-			      struct brcmf_event *event_packet, u8 *ifidx)
+			      struct brcmf_event *event_packet)
 {
 	enum brcmf_fweh_event_code code;
 	struct brcmf_fweh_info *fweh = &drvr->fweh;
@@ -425,7 +424,6 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 	/* get event info */
 	code = get_unaligned_be32(&event_packet->msg.event_type);
 	datalen = get_unaligned_be32(&event_packet->msg.datalen);
-	*ifidx = event_packet->msg.ifidx;
 	data = &event_packet[1];
 
 	if (code >= BRCMF_E_LAST)
@@ -442,7 +440,7 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 		return;
 
 	event->code = code;
-	event->ifidx = *ifidx;
+	event->ifidx = event_packet->msg.ifidx;
 
 	/* use memcpy to get aligned event message */
 	memcpy(&event->emsg, &event_packet->msg, sizeof(event->emsg));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index 8c39b51..6ec5db9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -187,10 +187,10 @@ void brcmf_fweh_unregister(struct brcmf_pub *drvr,
 			   enum brcmf_fweh_event_code code);
 int brcmf_fweh_activate_events(struct brcmf_if *ifp);
 void brcmf_fweh_process_event(struct brcmf_pub *drvr,
-			      struct brcmf_event *event_packet, u8 *ifidx);
+			      struct brcmf_event *event_packet);
 
 static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
-					  struct sk_buff *skb, u8 *ifidx)
+					  struct sk_buff *skb)
 {
 	struct brcmf_event *event_packet;
 	u8 *data;
@@ -213,7 +213,7 @@ static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
 	if (usr_stype != BCMILCP_BCM_SUBTYPE_EVENT)
 		return;
 
-	brcmf_fweh_process_event(drvr, event_packet, ifidx);
+	brcmf_fweh_process_event(drvr, event_packet);
 }
 
 #endif /* FWEH_H_ */
-- 
1.7.10.4


