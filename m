Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4838 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351Ab3FFLTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:19:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 20/22] brcmfmac: add trace event for capturing BDC
 header
Date: Thu, 6 Jun 2013 13:18:05 +0200
Message-ID: <1370517487-14395-21-git-send-email-arend@broadcom.com> (sfid-20130606_131933_219721_3E7A6DC9)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BDC header contains PropTx TLV signals that are useful to capture
for debugging. This event captures the header and tlv's in binary
form. This can be post-processed using trace-cmd plugin.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    3 +++
 .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |   21 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 59c77aa..dd85401 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -30,6 +30,7 @@
 #include "dhd_bus.h"
 #include "fwsignal.h"
 #include "dhd_dbg.h"
+#include "tracepoint.h"
 
 struct brcmf_proto_cdc_dcmd {
 	__le32 cmd;	/* dongle command value */
@@ -292,6 +293,7 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
 	h->flags2 = 0;
 	h->data_offset = offset;
 	BDC_SET_IF_IDX(h, ifidx);
+	trace_brcmf_bdchdr(pktbuf->data);
 }
 
 int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
@@ -309,6 +311,7 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 		return -EBADE;
 	}
 
+	trace_brcmf_bdchdr(pktbuf->data);
 	h = (struct brcmf_proto_bdc_header *)(pktbuf->data);
 
 	*ifidx = BDC_GET_IF_IDX(h);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
index 9df1f7a..bc29171 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
@@ -87,6 +87,27 @@ TRACE_EVENT(brcmf_hexdump,
 	TP_printk("hexdump [length=%lu]", __entry->len)
 );
 
+TRACE_EVENT(brcmf_bdchdr,
+	TP_PROTO(void *data),
+	TP_ARGS(data),
+	TP_STRUCT__entry(
+		__field(u8, flags)
+		__field(u8, prio)
+		__field(u8, flags2)
+		__field(u32, siglen)
+		__dynamic_array(u8, signal, *((u8 *)data + 3) * 4)
+	),
+	TP_fast_assign(
+		__entry->flags = *(u8 *)data;
+		__entry->prio = *((u8 *)data + 1);
+		__entry->flags2 = *((u8 *)data + 2);
+		__entry->siglen = *((u8 *)data + 3) * 4;
+		memcpy(__get_dynamic_array(signal),
+		       (u8 *)data + 4, __entry->siglen);
+	),
+	TP_printk("bdc: prio=%d siglen=%d", __entry->prio, __entry->siglen)
+);
+
 #ifdef CONFIG_BRCM_TRACING
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.10.4


