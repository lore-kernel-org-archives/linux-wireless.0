Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58439 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839AbaE2PkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 11:40:01 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Joe Perches <joe@perches.com>
Subject: [PATCH 4/7 v2] wil6210: improve debug for WMI receive
Date: Thu, 29 May 2014 18:37:52 +0300
Message-ID: <1401377872-8562-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140529_174007_468853_F3486E93)
In-Reply-To: <1417278.VSQeiOskQO@lx-wigig-72>
References: <1417278.VSQeiOskQO@lx-wigig-72>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print message if no events received. This should not happen.
If it is, it points to the problem in firmware.
Track also cases when multiple events processed in one IRQ

Print information as soon as possible - mbox pointers and
event header right after reading it. This helps to identify potential
problem with memory allocation for the event buffer.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index e9a11cb..706ee52 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -658,21 +658,27 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 	u8 *cmd;
 	void __iomem *src;
 	ulong flags;
+	unsigned n;
 
 	if (!test_bit(wil_status_reset_done, &wil->status)) {
 		wil_err(wil, "Reset not completed\n");
 		return;
 	}
 
-	for (;;) {
+	for (n = 0;; n++) {
 		u16 len;
 
 		r->head = ioread32(wil->csr + HOST_MBOX +
 				   offsetof(struct wil6210_mbox_ctl, rx.head));
-		if (r->tail == r->head)
+		if (r->tail == r->head) {
+			if (n == 0)
+				wil_dbg_wmi(wil, "No events?\n");
 			return;
+		}
 
-		/* read cmd from tail */
+		wil_dbg_wmi(wil, "Mbox head %08x tail %08x\n",
+			    r->head, r->tail);
+		/* read cmd descriptor from tail */
 		wil_memcpy_fromio_32(&d_tail, wil->csr + HOSTADDR(r->tail),
 				     sizeof(struct wil6210_mbox_ring_desc));
 		if (d_tail.sync == 0) {
@@ -680,13 +686,18 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 			return;
 		}
 
+		/* read cmd header from descriptor */
 		if (0 != wmi_read_hdr(wil, d_tail.addr, &hdr)) {
 			wil_err(wil, "Mbox evt at 0x%08x?\n",
 				le32_to_cpu(d_tail.addr));
 			return;
 		}
-
 		len = le16_to_cpu(hdr.len);
+		wil_dbg_wmi(wil, "Mbox evt %04x %04x %04x %02x\n",
+			    le16_to_cpu(hdr.seq), len, le16_to_cpu(hdr.type),
+			    hdr.flags);
+
+		/* read cmd buffer from descriptor */
 		src = wmi_buffer(wil, d_tail.addr) +
 		      sizeof(struct wil6210_mbox_hdr);
 		evt = kmalloc(ALIGN(offsetof(struct pending_wmi_event,
@@ -702,9 +713,6 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 		iowrite32(0, wil->csr + HOSTADDR(r->tail) +
 			  offsetof(struct wil6210_mbox_ring_desc, sync));
 		/* indicate */
-		wil_dbg_wmi(wil, "Mbox evt %04x %04x %04x %02x\n",
-			    le16_to_cpu(hdr.seq), len, le16_to_cpu(hdr.type),
-			    hdr.flags);
 		if ((hdr.type == WIL_MBOX_HDR_TYPE_WMI) &&
 		    (len >= sizeof(struct wil6210_mbox_hdr_wmi))) {
 			struct wil6210_mbox_hdr_wmi *wmi = &evt->event.wmi;
@@ -734,6 +742,8 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 			wil_dbg_wmi(wil, "queue_work -> %d\n", q);
 		}
 	}
+	if (n > 1)
+		wil_dbg_wmi(wil, "%s -> %d events processed\n", __func__, n);
 }
 
 int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
-- 
1.9.1

