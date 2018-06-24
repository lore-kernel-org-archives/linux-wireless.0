Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:37787 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbeFXTrG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 15:47:06 -0400
Received: by mail-lf0-f67.google.com with SMTP id g21-v6so12792220lfb.4
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2018 12:47:05 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V4 3/3] brcmfmac: handle msgbuf packets marked with monitor mode flag
Date: Sun, 24 Jun 2018 21:44:37 +0200
Message-Id: <20180624194437.28766-3-zajec5@gmail.com> (sfid-20180624_214755_333672_7FAF7C34)
In-Reply-To: <20180624194437.28766-1-zajec5@gmail.com>
References: <20180624194437.28766-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

New Broadcom firmwares mark monitor mode packets using a newly defined
bit in the flags field. Use it to filter them out and pass to the
monitor interface. These defines were found in bcmmsgbuf.h from SDK.

As not every firmware generates radiotap header this commit introduces
BRCMF_FEAT_MONITOR_FMT_RADIOTAP flag. It has to be has based on firmware
capabilities. If not present brcmf_netif_mon_rx() will assume packet is
a raw 802.11 frame and will prepend it with an empty radiotap header.

This new code is limited to the msgbuf protocol at this point. Adding
support for SDIO/USB devices will require some extra work (possibly a
new firmware release).

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V2: Use cpu_to_le16 when setting it_len
V3: Update TODO comments
    Rename flag (after adding MONITOR)
    Update commit message
V4: Added missing return; after brcmu_pkt_buf_free_skb() call
---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 25 ++++++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 18 ++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 72954fd6df3b..b1f702faff4f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -21,6 +21,7 @@
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
 #include <net/addrconf.h>
+#include <net/ieee80211_radiotap.h>
 #include <net/ipv6.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
@@ -404,6 +405,30 @@ void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 		netif_rx_ni(skb);
 }
 
+void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb)
+{
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR_FMT_RADIOTAP)) {
+		/* Do nothing */
+	} else {
+		struct ieee80211_radiotap_header *radiotap;
+
+		/* TODO: use RX status to fill some radiotap data */
+		radiotap = skb_push(skb, sizeof(*radiotap));
+		memset(radiotap, 0, sizeof(*radiotap));
+		radiotap->it_len = cpu_to_le16(sizeof(*radiotap));
+
+		/* TODO: 4 bytes with receive status? */
+		skb->len -= 4;
+	}
+
+	skb->dev = ifp->ndev;
+	skb_reset_mac_header(skb);
+	skb->pkt_type = PACKET_OTHERHOST;
+	skb->protocol = htons(ETH_P_802_2);
+
+	brcmf_netif_rx(ifp, skb);
+}
+
 static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
 			    struct brcmf_if **ifp)
 {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 401f50458686..dcf6e27cc16f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -121,6 +121,7 @@ struct brcmf_pub {
 
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 	s32 if2bss[BRCMF_MAX_IFS];
+	struct brcmf_if *mon_if;
 
 	struct mutex proto_block;
 	unsigned char proto_buf[BRCMF_DCMD_MAXLEN];
@@ -216,6 +217,7 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
+void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 int __init brcmf_core_init(void);
 void __exit brcmf_core_exit(void);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index c40ba8855cd5..4e8397a0cbc8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -69,6 +69,8 @@
 #define BRCMF_MSGBUF_MAX_EVENTBUF_POST		8
 
 #define BRCMF_MSGBUF_PKT_FLAGS_FRAME_802_3	0x01
+#define BRCMF_MSGBUF_PKT_FLAGS_FRAME_802_11	0x02
+#define BRCMF_MSGBUF_PKT_FLAGS_FRAME_MASK	0x07
 #define BRCMF_MSGBUF_PKT_FLAGS_PRIO_SHIFT	5
 
 #define BRCMF_MSGBUF_TX_FLUSH_CNT1		32
@@ -1128,6 +1130,7 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 	struct sk_buff *skb;
 	u16 data_offset;
 	u16 buflen;
+	u16 flags;
 	u32 idx;
 	struct brcmf_if *ifp;
 
@@ -1137,6 +1140,7 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 	data_offset = le16_to_cpu(rx_complete->data_offset);
 	buflen = le16_to_cpu(rx_complete->data_len);
 	idx = le32_to_cpu(rx_complete->msg.request_id);
+	flags = le16_to_cpu(rx_complete->flags);
 
 	skb = brcmf_msgbuf_get_pktid(msgbuf->drvr->bus_if->dev,
 				     msgbuf->rx_pktids, idx);
@@ -1150,6 +1154,20 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	skb_trim(skb, buflen);
 
+	if ((flags & BRCMF_MSGBUF_PKT_FLAGS_FRAME_MASK) ==
+	    BRCMF_MSGBUF_PKT_FLAGS_FRAME_802_11) {
+		ifp = msgbuf->drvr->mon_if;
+
+		if (!ifp) {
+			brcmf_err("Received unexpected monitor pkt\n");
+			brcmu_pkt_buf_free_skb(skb);
+			return;
+		}
+
+		brcmf_netif_mon_rx(ifp, skb);
+		return;
+	}
+
 	ifp = brcmf_get_ifp(msgbuf->drvr, rx_complete->msg.ifidx);
 	if (!ifp || !ifp->ndev) {
 		brcmf_err("Received pkt for invalid ifidx %d\n",
-- 
2.13.7
