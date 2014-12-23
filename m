Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaLWHsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:02 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 06/22] wil6210: improve debugfs for VRING
Date: Tue, 23 Dec 2014 09:47:08 +0200
Message-Id: <1419320844-23989-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_084809_248864_40AEDCB9)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When printing VRING on debugfs (file "vrings"),
software head & tail indexes were printed in decimal format
while hardware tail in hexadecimal only.

It is not comfortable to compare indexes in different formats;
on the other hand, hexadecimal output useful to see hardware
glitches.

To serve all purposes, print hardware tail in both decimal and
hexadecimal formats.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 5117a02..fedfa64 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -50,6 +50,7 @@ static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 			    char _s, char _h)
 {
 	void __iomem *x = wmi_addr(wil, vring->hwtail);
+	u32 v;
 
 	seq_printf(s, "VRING %s = {\n", name);
 	seq_printf(s, "  pa     = %pad\n", &vring->pa);
@@ -58,10 +59,12 @@ static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 	seq_printf(s, "  swtail = %d\n", vring->swtail);
 	seq_printf(s, "  swhead = %d\n", vring->swhead);
 	seq_printf(s, "  hwtail = [0x%08x] -> ", vring->hwtail);
-	if (x)
-		seq_printf(s, "0x%08x\n", ioread32(x));
-	else
+	if (x) {
+		v = ioread32(x);
+		seq_printf(s, "0x%08x = %d\n", v, v);
+	} else {
 		seq_puts(s, "???\n");
+	}
 
 	if (vring->va && (vring->size < 1025)) {
 		uint i;
-- 
2.1.0

