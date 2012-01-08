Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56065 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2AHJTx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 04:19:53 -0500
Received: by yhnn56 with SMTP id n56so1158408yhn.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 01:19:52 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH] NFC: Complete NCI deactivate in deactivate_ntf
Date: Sun,  8 Jan 2012 11:21:53 +0200
Message-Id: <1326014513-29958-1-git-send-email-ilane@ti.com> (sfid-20120108_102023_374366_3F3CA368)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

If a target was active, complete the NCI deactivate request
only in deactivate_ntf. Otherwise, complete it at deactivate_rsp.
Deactivate_ntf represents the actual disconnection event (sent from
the NCI controller).

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 net/nfc/nci/ntf.c |    2 ++
 net/nfc/nci/rsp.c |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 5b2b013..a88be91 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -365,6 +365,8 @@ static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 	/* complete the data exchange transaction, if exists */
 	if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
 		nci_data_exchange_complete(ndev, NULL, -EIO);
+
+	nci_req_complete(ndev, NCI_STATUS_OK);
 }
 
 void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index 2840ae2..3c73e92 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -151,7 +151,10 @@ static void nci_rf_deactivate_rsp_packet(struct nci_dev *ndev,
 
 	clear_bit(NCI_DISCOVERY, &ndev->flags);
 
-	nci_req_complete(ndev, status);
+	/* If target was active, complete the request only in deactivate_ntf */
+	if ((status != NCI_STATUS_OK) ||
+		(!test_bit(NCI_POLL_ACTIVE, &ndev->flags)))
+		nci_req_complete(ndev, status);
 }
 
 void nci_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
-- 
1.7.0.4

