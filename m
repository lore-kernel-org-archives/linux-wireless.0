Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1032 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3K2LZf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:35 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/19] brcmfmac: support hardware extension header in
 trace_brcmf_sdpcm_hdr()
Date: Fri, 29 Nov 2013 12:25:06 +0100
Message-ID: <1385724324-6361-2-git-send-email-arend@broadcom.com> (sfid-20131129_122541_929862_E3859EB3)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SDPCM header can be traced, but it used a fixed header size. With
txglom feature the SDPCM header will have additional 8 bytes of hardware
extension header so SDIO core can properly handle the txglom packet.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 +--
 .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |   29 ++++++++++++++------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2597a53..510ab18 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1147,7 +1147,7 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 	u8 rx_seq, fc, tx_seq_max;
 	u32 swheader;
 
-	trace_brcmf_sdpcm_hdr(false, header);
+	trace_brcmf_sdpcm_hdr(SDPCM_RX, header);
 
 	/* hw header */
 	len = get_unaligned_le16(header);
@@ -1271,7 +1271,7 @@ static void brcmf_sdio_hdpack(struct brcmf_sdio *bus, u8 *header,
 		     SDPCM_DOFFSET_MASK;
 	*(((__le32 *)header) + 1) = cpu_to_le32(sw_header);
 	*(((__le32 *)header) + 2) = 0;
-	trace_brcmf_sdpcm_hdr(true, header);
+	trace_brcmf_sdpcm_hdr(SDPCM_TX, header);
 }
 
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
index 3c67529..d229cda 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
@@ -110,21 +110,32 @@ TRACE_EVENT(brcmf_bdchdr,
 	TP_printk("bdc: prio=%d siglen=%d", __entry->prio, __entry->siglen)
 );
 
+#ifndef SDPCM_RX
+#define SDPCM_RX	0
+#endif
+#ifndef SDPCM_TX
+#define SDPCM_TX	1
+#endif
+#ifndef SDPCM_GLOM
+#define SDPCM_GLOM	2
+#endif
+
 TRACE_EVENT(brcmf_sdpcm_hdr,
-	TP_PROTO(bool tx, void *data),
-	TP_ARGS(tx, data),
+	TP_PROTO(u8 dir, void *data),
+	TP_ARGS(dir, data),
 	TP_STRUCT__entry(
-		__field(u8, tx)
+		__field(u8, dir)
 		__field(u16, len)
-		__array(u8, hdr, 12)
+		__dynamic_array(u8, hdr, dir == SDPCM_GLOM ? 20 : 12)
 	),
 	TP_fast_assign(
-		memcpy(__entry->hdr, data, 12);
-		__entry->len = __entry->hdr[0] | (__entry->hdr[1] << 8);
-		__entry->tx = tx ? 1 : 0;
+		memcpy(__get_dynamic_array(hdr), data, dir == SDPCM_GLOM ? 20 : 12);
+		__entry->len = *(u8 *)data | (*((u8 *)data + 1) << 8);
+		__entry->dir = dir;
 	),
-	TP_printk("sdpcm: %s len %u, seq %d", __entry->tx ? "TX" : "RX",
-		  __entry->len, __entry->hdr[4])
+	TP_printk("sdpcm: %s len %u, seq %d",
+		  __entry->dir == SDPCM_RX ? "RX" : "TX",
+		  __entry->len, ((u8 *)__get_dynamic_array(hdr))[4])
 );
 
 #ifdef CONFIG_BRCM_TRACING
-- 
1.7.10.4


