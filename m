Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53193 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab1BMOlF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 09:41:05 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so4702333bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 06:41:04 -0800 (PST)
From: Stanislav Fomichev <kernel@fomichev.me>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, gregkh@suse.de
Subject: [PATCH 7/8] brcm80211: replace ether_header with ethhdr
Date: Sun, 13 Feb 2011 17:40:42 +0300
Message-Id: <1297608043-18381-7-git-send-email-kernel@fomichev.me>
In-Reply-To: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
References: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use native linux interfaces instead of brcm80211 specific ones.

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   12 +++---
 drivers/staging/brcm80211/include/proto/bcmevent.h |    4 +-
 drivers/staging/brcm80211/include/proto/ethernet.h |   36 --------------------
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |    2 +-
 5 files changed, 10 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 01943f3..077ccc7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -868,7 +868,7 @@ wl_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 				if (ifevent->action == WLC_E_IF_ADD)
 					dhd_add_if(dhd, ifevent->ifidx,
 						   NULL, event->ifname,
-						   pvt_data->eth.ether_dhost,
+						   pvt_data->eth.h_dest,
 						   ifevent->flags,
 						   ifevent->bssidx);
 				else
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index c09e9a5..a3db566 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1030,11 +1030,11 @@ int dhd_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 	/* Update multicast statistic */
 	if (pktbuf->len >= ETH_ALEN) {
 		u8 *pktdata = (u8 *) (pktbuf->data);
-		struct ether_header *eh = (struct ether_header *)pktdata;
+		struct ethhdr *eh = (struct ethhdr *)pktdata;
 
-		if (is_multicast_ether_addr(eh->ether_dhost))
+		if (is_multicast_ether_addr(eh->h_dest))
 			dhdp->tx_multicast++;
-		if (ntoh16(eh->ether_type) == ETH_P_PAE)
+		if (ntoh16(eh->h_proto) == ETH_P_PAE)
 			atomic_inc(&dhd->pend_8021x_cnt);
 	}
 
@@ -1254,13 +1254,13 @@ void dhd_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp, bool success)
 {
 	uint ifidx;
 	dhd_info_t *dhd = (dhd_info_t *) (dhdp->info);
-	struct ether_header *eh;
+	struct ethhdr *eh;
 	u16 type;
 
 	dhd_prot_hdrpull(dhdp, &ifidx, txp);
 
-	eh = (struct ether_header *)(txp->data);
-	type = ntoh16(eh->ether_type);
+	eh = (struct ethhdr *)(txp->data);
+	type = ntoh16(eh->h_proto);
 
 	if (type == ETH_P_PAE)
 		atomic_dec(&dhd->pend_8021x_cnt);
diff --git a/drivers/staging/brcm80211/include/proto/bcmevent.h b/drivers/staging/brcm80211/include/proto/bcmevent.h
index 865d157..f61c048 100644
--- a/drivers/staging/brcm80211/include/proto/bcmevent.h
+++ b/drivers/staging/brcm80211/include/proto/bcmevent.h
@@ -40,13 +40,13 @@ typedef BWL_PRE_PACKED_STRUCT struct {
 
 #ifdef BRCM_FULLMAC
 typedef BWL_PRE_PACKED_STRUCT struct bcm_event {
-	struct ether_header eth;
+	struct ethhdr eth;
 	bcmeth_hdr_t		bcm_hdr;
 	wl_event_msg_t		event;
 } BWL_POST_PACKED_STRUCT bcm_event_t;
 #endif
 #define BCM_MSG_LEN	(sizeof(bcm_event_t) - sizeof(bcmeth_hdr_t) - \
-	sizeof(struct ether_header))
+	sizeof(struct ethhdr))
 
 #define WLC_E_SET_SSID		0
 #define WLC_E_JOIN		1
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index 567407d..1176df9 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -21,52 +21,16 @@
 
 #include <packed_section_start.h>
 
-#define	ETHER_TYPE_LEN		2
-#define	ETHER_CRC_LEN		4
-#define	ETHER_MIN_LEN		64
-#define	ETHER_MIN_DATA		46
 #define	ETHER_MAX_LEN		1518
-#define	ETHER_MAX_DATA		1500
 
 #define	ETHER_TYPE_BRCM		0x886c
 
-#define ETHER_DEST_OFFSET	(0 * ETH_ALEN)
-#define ETHER_SRC_OFFSET	(1 * ETH_ALEN)
-#define ETHER_TYPE_OFFSET	(2 * ETH_ALEN)
-
-#define	ETHER_IS_VALID_LEN(foo)	\
-	((foo) >= ETHER_MIN_LEN && (foo) <= ETHER_MAX_LEN)
-
-#define ETHER_FILL_MCAST_ADDR_FROM_IP(ea, mgrp_ip) {		\
-		((u8 *)ea)[0] = 0x01;			\
-		((u8 *)ea)[1] = 0x00;			\
-		((u8 *)ea)[2] = 0x5e;			\
-		((u8 *)ea)[3] = ((mgrp_ip) >> 16) & 0x7f;	\
-		((u8 *)ea)[4] = ((mgrp_ip) >>  8) & 0xff;	\
-		((u8 *)ea)[5] = ((mgrp_ip) >>  0) & 0xff;	\
-}
-
-BWL_PRE_PACKED_STRUCT struct ether_header {
-	u8 ether_dhost[ETH_ALEN];
-	u8 ether_shost[ETH_ALEN];
-	u16 ether_type;
-} BWL_POST_PACKED_STRUCT;
-
 BWL_PRE_PACKED_STRUCT struct ether_addr {
 	u8 octet[ETH_ALEN];
 } BWL_POST_PACKED_STRUCT;
 
-#define ETHER_SET_UNICAST(ea)	(((u8 *)(ea))[0] = (((u8 *)(ea))[0] & ~1))
-
 static const struct ether_addr ether_bcast = { {255, 255, 255, 255, 255, 255} };
 
-#define ETHER_MOVE_HDR(d, s) \
-do { \
-	struct ether_header t; \
-	t = *(struct ether_header *)(s); \
-	*(struct ether_header *)(d) = t; \
-} while (0)
-
 #include <packed_section_end.h>
 
 #endif				/* _NET_ETHERNET_H_ */
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index ddca7ff..8083244 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -1729,7 +1729,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 
 	/* some code depends on packed structures */
 	ASSERT(sizeof(struct ether_addr) == ETH_ALEN);
-	ASSERT(sizeof(struct ether_header) == ETH_HLEN);
+	ASSERT(sizeof(struct ethhdr) == ETH_HLEN);
 	ASSERT(sizeof(d11regs_t) == SI_CORE_SIZE);
 	ASSERT(sizeof(ofdm_phy_hdr_t) == D11_PHY_HDR_LEN);
 	ASSERT(sizeof(cck_phy_hdr_t) == D11_PHY_HDR_LEN);
-- 
1.7.1

