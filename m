Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35580 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbcE0Xef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 19:34:35 -0400
Received: by mail-lf0-f66.google.com with SMTP id q63so30963lfi.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2016 16:34:34 -0700 (PDT)
From: Mikael Kanstrup <mikael.kanstrup@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Mikael Kanstrup <mikael.kanstrup@gmail.com>
Subject: [RFCv3] brcmfmac: Add tracepoints for bcmdhd-dissector tool
Date: Sat, 28 May 2016 01:32:44 +0200
Message-Id: <20160527233244.27820-1-mikael.kanstrup@sonymobile.com> (sfid-20160528_013444_003460_21229549)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mikael Kanstrup <mikael.kanstrup@gmail.com>

Add tracepoints to be used with bcmdhd-dissector:
  https://github.com/kanstrup/bcmdhd-dissector

bcmdhd-dissector is a Wireshark LUA plugin dissector used to decode
protocol data between the brcmfmac driver and the wifi chip firmware.
This includes decoding firmware command requests and responses as
well as events and even tx/rx data interleaved if the dissect_data
tracepoint is enabled.

Signed-off-by: Mikael Kanstrup <mikael.kanstrup@gmail.com>
---
v3:
- Updated patch as per Arends comments, i.e:
  - Replaced memcpy in driver code with ethernet header added in
    trace-cmd plugin.
  - Removed global tmp buffer.
  - Moved tx/rx traces to start_xmit and netif_rx funcs.
  - Made functions return void.

v2:
- Add description of bcmdhd-dissector as suggested by Rafał
- Fix tx/rx data dump.
- Fix tx data dump on USB interface.

 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  4 ++
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  5 ++
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   | 23 ++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   | 14 ++++++
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  1 +
 .../broadcom/brcm80211/brcmfmac/tracepoint.h       | 53 ++++++++++++++++++++++
 6 files changed, 100 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index d1bc51f..e443891 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -134,6 +134,8 @@ brcmf_proto_bcdc_msg(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
 	if (len > BRCMF_TX_IOCTL_MAX_MSG_SIZE)
 		len = BRCMF_TX_IOCTL_MAX_MSG_SIZE;
 
+	brcmf_dbg_dissect_ioctl(1, &bcdc->msg, len);
+
 	/* Send request */
 	return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&bcdc->msg, len);
 }
@@ -152,6 +154,8 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 			break;
 	} while (BCDC_DCMD_ID(le32_to_cpu(bcdc->msg.flags)) != id);
 
+	brcmf_dbg_dissect_ioctl(0, &bcdc->msg, len);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index b590499..a130c2b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -28,6 +28,7 @@
 #include "core.h"
 #include "bus.h"
 #include "debug.h"
+#include "tracepoint.h"
 #include "fwil_types.h"
 #include "p2p.h"
 #include "cfg80211.h"
@@ -250,6 +251,8 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	if (eh->h_proto == htons(ETH_P_PAE))
 		atomic_inc(&ifp->pend_8021x_cnt);
 
+	trace_brcmf_dissect_data(skb->data, skb->len);
+
 	ret = brcmf_fws_process_skb(ifp, skb);
 
 done:
@@ -300,6 +303,8 @@ void brcmf_txflowblock(struct device *dev, bool state)
 
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
+	trace_brcmf_dissect_data(skb->data, skb->len);
+
 	if (skb->pkt_type == PACKET_MULTICAST)
 		ifp->stats.multicast++;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index e64557c..c3a4936 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -24,6 +24,7 @@
 #include "bus.h"
 #include "fweh.h"
 #include "debug.h"
+#include "tracepoint.h"
 
 static struct dentry *root_folder;
 
@@ -109,3 +110,25 @@ int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 					drvr->dbgfs_dir, read_fn);
 	return PTR_ERR_OR_ZERO(e);
 }
+
+#ifdef CONFIG_BRCM_TRACING
+void brcmf_dbg_dissect_event(void *data, int len)
+{
+	if (!trace_brcmf_dissect_event_enabled())
+		return;
+
+	/* Event tracing only needed if not done through data dump */
+	if (trace_brcmf_dissect_data_enabled())
+		return;
+
+	trace_brcmf_dissect_event(data, len);
+}
+
+void brcmf_dbg_dissect_ioctl(int tx, void *data, int len)
+{
+	if (!trace_brcmf_dissect_ioctl_enabled())
+		return;
+
+	trace_brcmf_dissect_ioctl(tx, data, len);
+}
+#endif
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 6687812..305b922 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -138,4 +138,18 @@ int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 }
 #endif
 
+#ifdef CONFIG_BRCM_TRACING
+void brcmf_dbg_dissect_event(void *data, int len);
+void brcmf_dbg_dissect_ioctl(int tx, void *data, int len);
+#else
+static inline
+void brcmf_dbg_dissect_event(void *data, int len)
+{
+}
+static inline
+void brcmf_dbg_dissect_ioctl(int tx, void *data, int len)
+{
+}
+#endif
+
 #endif /* BRCMFMAC_DEBUG_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index b390561..f711c15 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -246,6 +246,7 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 		emsg.ifidx = emsg_be->ifidx;
 		emsg.bsscfgidx = emsg_be->bsscfgidx;
 
+		brcmf_dbg_dissect_event(&event->emsg, sizeof(event->emsg));
 		brcmf_dbg(EVENT, "  version %u flags %u status %u reason %u\n",
 			  emsg.version, emsg.flags, emsg.status, emsg.reason);
 		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), event->data,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h
index 4d7d51f..506415c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h
@@ -110,6 +110,59 @@ TRACE_EVENT(brcmf_bcdchdr,
 	TP_printk("bcdc: prio=%d siglen=%d", __entry->prio, __entry->siglen)
 );
 
+TRACE_EVENT(brcmf_dissect_event,
+	TP_PROTO(void *data, size_t len),
+	TP_ARGS(data, len),
+	TP_STRUCT__entry(
+		__field(unsigned long, len)
+		__field(unsigned long, addr)
+		__dynamic_array(u8, hdata, len)
+	),
+	TP_fast_assign(
+		__entry->len = len;
+		__entry->addr = (unsigned long)data;
+		memcpy(__get_dynamic_array(hdata), data, len);
+	),
+	TP_printk("dissect_event [addr=%lx, length=%lu]",
+		  __entry->addr, __entry->len)
+);
+
+TRACE_EVENT(brcmf_dissect_ioctl,
+	TP_PROTO(int tx, void *data, size_t len),
+	TP_ARGS(tx, data, len),
+	TP_STRUCT__entry(
+		__field(int, tx)
+		__field(unsigned long, len)
+		__field(unsigned long, addr)
+		__dynamic_array(u8, hdata, len)
+	),
+	TP_fast_assign(
+		__entry->tx = tx;
+		__entry->len = len;
+		__entry->addr = (unsigned long)data;
+		memcpy(__get_dynamic_array(hdata), data, len);
+	),
+	TP_printk("dissect_ioctl [tx=%d addr=%lx, length=%lu]",
+		  __entry->tx, __entry->addr, __entry->len)
+);
+
+TRACE_EVENT(brcmf_dissect_data,
+	TP_PROTO(void *data, size_t len),
+	TP_ARGS(data, len),
+	TP_STRUCT__entry(
+		__field(unsigned long, len)
+		__field(unsigned long, addr)
+		__dynamic_array(u8, hdata, len)
+	),
+	TP_fast_assign(
+		__entry->len = len;
+		__entry->addr = (unsigned long)data;
+		memcpy(__get_dynamic_array(hdata), data, len);
+	),
+	TP_printk("dissect_data [addr=%lx, length=%lu]",
+		  __entry->addr, __entry->len)
+);
+
 #ifndef SDPCM_RX
 #define SDPCM_RX	0
 #endif
-- 
2.8.3

