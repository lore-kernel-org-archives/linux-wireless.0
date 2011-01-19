Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab1ASWeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 17:34:50 -0500
Received: by fxm20 with SMTP id 20so1417828fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 14:34:48 -0800 (PST)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFT 2/8] staging: brcm80211: Use linux ethhdr struct.
Date: Wed, 19 Jan 2011 23:35:26 +0100
Message-Id: <1295476532-21130-3-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1295476532-21130-2-git-send-email-jonas.gorski@gmail.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-2-git-send-email-jonas.gorski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the linux ethhdr struct instead of defining one itself.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   16 ++++++++--------
 drivers/staging/brcm80211/include/proto/bcmevent.h |    4 ++--
 drivers/staging/brcm80211/include/proto/ethernet.h |    6 ------
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |    2 +-
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index db45083..87bf42d 100644
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
+		if (eh->h_proto == htons(ETH_P_PAE))
 			atomic_inc(&dhd->pend_8021x_cnt);
 	}
 
@@ -1254,15 +1254,15 @@ void dhd_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp, bool success)
 {
 	uint ifidx;
 	dhd_info_t *dhd = (dhd_info_t *) (dhdp->info);
-	struct ether_header *eh;
-	u16 type;
+	struct ethhdr *eh;
+	__be16 type;
 
 	dhd_prot_hdrpull(dhdp, &ifidx, txp);
 
-	eh = (struct ether_header *)(txp->data);
-	type = ntoh16(eh->ether_type);
+	eh = (struct ethhdr *)(txp->data);
+	type = eh->h_proto;
 
-	if (type == ETH_P_PAE)
+	if (type == htons(ETH_P_PAE))
 		atomic_dec(&dhd->pend_8021x_cnt);
 
 }
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
index 106a8bf..af3b977 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -34,12 +34,6 @@
 #define ETHER_SRC_OFFSET	(1 * ETH_ALEN)
 #define ETHER_TYPE_OFFSET	(2 * ETH_ALEN)
 
-BWL_PRE_PACKED_STRUCT struct ether_header {
-	u8 ether_dhost[ETH_ALEN];
-	u8 ether_shost[ETH_ALEN];
-	u16 ether_type;
-} BWL_POST_PACKED_STRUCT;
-
 BWL_PRE_PACKED_STRUCT struct ether_addr {
 	u8 octet[ETH_ALEN];
 } BWL_POST_PACKED_STRUCT;
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 1d5d01a..9c57573 100644
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
1.5.6.5

