Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34506 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3GKHMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 03:12:23 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] wil6210: Align WMI header with latest FW
Date: Thu, 11 Jul 2013 10:12:07 +0300
Message-ID: <1373526729-10908-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130711_091230_415225_166354ED)
In-Reply-To: <1373526729-10908-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1373526729-10908-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW guys changed header structure; align driver code

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/trace.h   | 22 +++++++++++++---------
 drivers/net/wireless/ath/wil6210/wil6210.h | 17 ++++++++++++++---
 drivers/net/wireless/ath/wil6210/wmi.c     | 14 +++++++++-----
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/trace.h b/drivers/net/wireless/ath/wil6210/trace.h
index eff1239..e59239d 100644
--- a/drivers/net/wireless/ath/wil6210/trace.h
+++ b/drivers/net/wireless/ath/wil6210/trace.h
@@ -37,36 +37,40 @@ static inline void trace_ ## name(proto) {}
 #endif /* !CONFIG_WIL6210_TRACING || defined(__CHECKER__) */
 
 DECLARE_EVENT_CLASS(wil6210_wmi,
-	TP_PROTO(u16 id, void *buf, u16 buf_len),
+	TP_PROTO(struct wil6210_mbox_hdr_wmi *wmi, void *buf, u16 buf_len),
 
-	TP_ARGS(id, buf, buf_len),
+	TP_ARGS(wmi, buf, buf_len),
 
 	TP_STRUCT__entry(
+		__field(u8, mid)
 		__field(u16, id)
+		__field(u32, timestamp)
 		__field(u16, buf_len)
 		__dynamic_array(u8, buf, buf_len)
 	),
 
 	TP_fast_assign(
-		__entry->id = id;
+		__entry->mid = wmi->mid;
+		__entry->id = le16_to_cpu(wmi->id);
+		__entry->timestamp = le32_to_cpu(wmi->timestamp);
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
 
 	TP_printk(
-		"id 0x%04x len %d",
-		__entry->id, __entry->buf_len
+		"MID %d id 0x%04x len %d timestamp %d",
+		__entry->mid, __entry->id, __entry->buf_len, __entry->timestamp
 	)
 );
 
 DEFINE_EVENT(wil6210_wmi, wil6210_wmi_cmd,
-	TP_PROTO(u16 id, void *buf, u16 buf_len),
-	TP_ARGS(id, buf, buf_len)
+	TP_PROTO(struct wil6210_mbox_hdr_wmi *wmi, void *buf, u16 buf_len),
+	TP_ARGS(wmi, buf, buf_len)
 );
 
 DEFINE_EVENT(wil6210_wmi, wil6210_wmi_event,
-	TP_PROTO(u16 id, void *buf, u16 buf_len),
-	TP_ARGS(id, buf, buf_len)
+	TP_PROTO(struct wil6210_mbox_hdr_wmi *wmi, void *buf, u16 buf_len),
+	TP_ARGS(wmi, buf, buf_len)
 );
 
 #define WIL6210_MSG_MAX (200)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 44fdab5..129c480 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -156,11 +156,22 @@ struct wil6210_mbox_hdr {
 /* max. value for wil6210_mbox_hdr.len */
 #define MAX_MBOXITEM_SIZE   (240)
 
+/**
+ * struct wil6210_mbox_hdr_wmi - WMI header
+ *
+ * @mid: MAC ID
+ *	00 - default, created by FW
+ *	01..0f - WiFi ports, driver to create
+ *	10..fe - debug
+ *	ff - broadcast
+ * @id: command/event ID
+ * @timestamp: FW fills for events, free-running msec timer
+ */
 struct wil6210_mbox_hdr_wmi {
-	u8 reserved0[2];
+	u8 mid;
+	u8 reserved;
 	__le16 id;
-	__le16 info1; /* bits [0..3] - device_id, rest - unused */
-	u8 reserved1[2];
+	__le32 timestamp;
 } __packed;
 
 struct pending_wmi_event {
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index dc8059a..a62511a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -172,8 +172,8 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 			.len = cpu_to_le16(sizeof(cmd.wmi) + len),
 		},
 		.wmi = {
+			.mid = 0,
 			.id = cpu_to_le16(cmdid),
-			.info1 = 0,
 		},
 	};
 	struct wil6210_mbox_ring *r = &wil->mbox_ctl.tx;
@@ -248,7 +248,7 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	iowrite32(r->head = next_head, wil->csr + HOST_MBOX +
 		  offsetof(struct wil6210_mbox_ctl, tx.head));
 
-	trace_wil6210_wmi_cmd(cmdid, buf, len);
+	trace_wil6210_wmi_cmd(&cmd.wmi, buf, len);
 
 	/* interrupt to FW */
 	iowrite32(SW_INT_MBOX, wil->csr + HOST_SW_INT);
@@ -640,9 +640,13 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 			    hdr.flags);
 		if ((hdr.type == WIL_MBOX_HDR_TYPE_WMI) &&
 		    (len >= sizeof(struct wil6210_mbox_hdr_wmi))) {
-			u16 id = le16_to_cpu(evt->event.wmi.id);
-			wil_dbg_wmi(wil, "WMI event 0x%04x\n", id);
-			trace_wil6210_wmi_event(id, &evt->event.wmi, len);
+			struct wil6210_mbox_hdr_wmi *wmi = &evt->event.wmi;
+			u16 id = le16_to_cpu(wmi->id);
+			u32 tstamp = le32_to_cpu(wmi->timestamp);
+			wil_dbg_wmi(wil, "WMI event 0x%04x MID %d @%d msec\n",
+				    id, wmi->mid, tstamp);
+			trace_wil6210_wmi_event(wmi, &wmi[1],
+						len - sizeof(*wmi));
 		}
 		wil_hex_dump_wmi("evt ", DUMP_PREFIX_OFFSET, 16, 1,
 				 &evt->event.hdr, sizeof(hdr) + len, true);
-- 
1.8.1.2

