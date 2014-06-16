Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63181 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbaFPQiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:50 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 21/25] wil6210: fix for unreachable code in wmi_recv_cmd
Date: Mon, 16 Jun 2014 19:37:19 +0300
Message-ID: <1402936643-31819-22-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190457_664474_B81C9DA8)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by Dan Carpenter <dan.carpenter@oracle.com>:

The patch a715c7ddd65a: "wil6210: improve debug for WMI receive" from
May 29, 2014, leads to the following static checker warning:

        drivers/net/wireless/ath/wil6210/wmi.c:746 wmi_recv_cmd()
        info: ignoring unreachable code.

drivers/net/wireless/ath/wil6210/wmi.c
   739                  spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
   740                  {
   741                          int q = queue_work(wil->wmi_wq,
   742                                             &wil->wmi_event_worker);
   743                          wil_dbg_wmi(wil, "queue_work -> %d\n", q);
   744                  }
   745          }
   746          if (n > 1)
                ^^^^^^^^^^
We never reach this if statemtent.

   747                  wil_dbg_wmi(wil, "%s -> %d events processed\n", __func__, n);
   748  }

Exit loop with "break", not "return".

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index b92a042..a136dab 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -683,14 +683,12 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 
 	for (n = 0;; n++) {
 		u16 len;
+		bool q;
 
 		r->head = ioread32(wil->csr + HOST_MBOX +
 				   offsetof(struct wil6210_mbox_ctl, rx.head));
-		if (r->tail == r->head) {
-			if (n == 0)
-				wil_dbg_wmi(wil, "No events?\n");
-			return;
-		}
+		if (r->tail == r->head)
+			break;
 
 		wil_dbg_wmi(wil, "Mbox head %08x tail %08x\n",
 			    r->head, r->tail);
@@ -699,14 +697,14 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 				     sizeof(struct wil6210_mbox_ring_desc));
 		if (d_tail.sync == 0) {
 			wil_err(wil, "Mbox evt not owned by FW?\n");
-			return;
+			break;
 		}
 
 		/* read cmd header from descriptor */
 		if (0 != wmi_read_hdr(wil, d_tail.addr, &hdr)) {
 			wil_err(wil, "Mbox evt at 0x%08x?\n",
 				le32_to_cpu(d_tail.addr));
-			return;
+			break;
 		}
 		len = le16_to_cpu(hdr.len);
 		wil_dbg_wmi(wil, "Mbox evt %04x %04x %04x %02x\n",
@@ -720,7 +718,7 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 					     event.wmi) + len, 4),
 			      GFP_KERNEL);
 		if (!evt)
-			return;
+			break;
 
 		evt->event.hdr = hdr;
 		cmd = (void *)&evt->event.wmi;
@@ -752,14 +750,11 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 		spin_lock_irqsave(&wil->wmi_ev_lock, flags);
 		list_add_tail(&evt->list, &wil->pending_wmi_ev);
 		spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
-		{
-			int q =	queue_work(wil->wmi_wq,
-					   &wil->wmi_event_worker);
-			wil_dbg_wmi(wil, "queue_work -> %d\n", q);
-		}
+		q = queue_work(wil->wmi_wq, &wil->wmi_event_worker);
+		wil_dbg_wmi(wil, "queue_work -> %d\n", q);
 	}
-	if (n > 1)
-		wil_dbg_wmi(wil, "%s -> %d events processed\n", __func__, n);
+	/* normally, 1 event per IRQ should be processed */
+	wil_dbg_wmi(wil, "%s -> %d events queued\n", __func__, n);
 }
 
 int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
-- 
1.9.1

