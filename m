Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:59168 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaHSIXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 04:23:05 -0400
Subject: [PATCH v7 3/8] ath10k: save firmware debug log messages
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Aug 2014 11:23:00 +0300
Message-ID: <20140819082300.16842.40769.stgit@potku.adurom.net> (sfid-20140819_102309_290085_CD8802AE)
In-Reply-To: <20140819082038.16842.46876.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

They may be dumped through the firmware dump debugfs
file.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 23acbadeb8fa..eafc565240f1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1290,6 +1290,16 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 
 	trace_ath10k_wmi_dbglog(skb->data, skb->len);
 
+	spin_lock_bh(&ar->data_lock);
+
+	/* First 4 bytes are a messages-dropped-due-to-overflow counter,
+	 * and should not be recorded in the dbglog buffer, so we skip
+	 * them.
+	 */
+	ath10k_debug_dbglog_add(ar, skb->data + 4, skb->len - 4);
+
+	spin_unlock_bh(&ar->data_lock);
+
 	return 0;
 }
 

