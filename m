Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4377 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865Ab3JONpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:08 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/12] brcmfmac: add tracepoint for capturing the SDPCM
 header
Date: Tue, 15 Oct 2013 15:44:47 +0200
Message-ID: <1381844697-24881-3-git-send-email-arend@broadcom.com> (sfid-20131015_154553_076258_3FCD40DC)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having the SDPCM header information in the traces is a valuable
piece of information.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c   |    3 +++
 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h |   17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 67f05db..ab1c919 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1147,6 +1147,8 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 	u8 rx_seq, fc, tx_seq_max;
 	u32 swheader;
 
+	trace_brcmf_sdpcm_hdr(false, header);
+
 	/* hw header */
 	len = get_unaligned_le16(header);
 	checksum = get_unaligned_le16(header + sizeof(u16));
@@ -1269,6 +1271,7 @@ static void brcmf_sdio_hdpack(struct brcmf_sdio *bus, u8 *header,
 		     SDPCM_DOFFSET_MASK;
 	*(((__le32 *)header) + 1) = cpu_to_le32(sw_header);
 	*(((__le32 *)header) + 2) = 0;
+	trace_brcmf_sdpcm_hdr(true, header);
 }
 
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
index 4605a1d..3c67529 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
@@ -110,6 +110,23 @@ TRACE_EVENT(brcmf_bdchdr,
 	TP_printk("bdc: prio=%d siglen=%d", __entry->prio, __entry->siglen)
 );
 
+TRACE_EVENT(brcmf_sdpcm_hdr,
+	TP_PROTO(bool tx, void *data),
+	TP_ARGS(tx, data),
+	TP_STRUCT__entry(
+		__field(u8, tx)
+		__field(u16, len)
+		__array(u8, hdr, 12)
+	),
+	TP_fast_assign(
+		memcpy(__entry->hdr, data, 12);
+		__entry->len = __entry->hdr[0] | (__entry->hdr[1] << 8);
+		__entry->tx = tx ? 1 : 0;
+	),
+	TP_printk("sdpcm: %s len %u, seq %d", __entry->tx ? "TX" : "RX",
+		  __entry->len, __entry->hdr[4])
+);
+
 #ifdef CONFIG_BRCM_TRACING
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.10.4


