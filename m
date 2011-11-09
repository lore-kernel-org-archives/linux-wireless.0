Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52596 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1KIKJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 05:09:58 -0500
Received: by mail-yx0-f174.google.com with SMTP id r9so505566yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 02:09:58 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v4 3/3] NFC: Check if NCI data flow control is used
Date: Wed,  9 Nov 2011 12:09:16 +0200
Message-Id: <1320833356-19132-4-git-send-email-ilane@ti.com> (sfid-20111109_111001_985928_A201012C)
In-Reply-To: <1320833356-19132-1-git-send-email-ilane@ti.com>
References: <1320833356-19132-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Check if NCI data flow control is used in nci_tx_work.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci.h |    3 +++
 net/nfc/nci/core.c    |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 0b34fde..cdbe671 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -108,6 +108,9 @@
 /* NCI Static RF connection ID */
 #define NCI_STATIC_RF_CONN_ID					0x00
 
+/* NCI Data Flow Control */
+#define NCI_DATA_FLOW_CONTROL_NOT_USED				0xff
+
 /* NCI RF_DISCOVER_MAP_CMD modes */
 #define NCI_DISC_MAP_MODE_POLL					0x01
 #define NCI_DISC_MAP_MODE_LISTEN				0x02
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 803f6d1..fe5ca89 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -723,7 +723,10 @@ static void nci_tx_work(struct work_struct *work)
 		if (!skb)
 			return;
 
-		atomic_dec(&ndev->credits_cnt);
+		/* Check if data flow control is used */
+		if (atomic_read(&ndev->credits_cnt) !=
+				NCI_DATA_FLOW_CONTROL_NOT_USED)
+			atomic_dec(&ndev->credits_cnt);
 
 		nfc_dbg("NCI TX: MT=data, PBF=%d, conn_id=%d, plen=%d",
 				nci_pbf(skb->data),
-- 
1.7.0.4

