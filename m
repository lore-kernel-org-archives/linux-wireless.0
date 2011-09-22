Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36138 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1IVIis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 04:38:48 -0400
Received: by gxk6 with SMTP id 6so1774907gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 01:38:47 -0700 (PDT)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH] NFC: protect nci_data_exchange transactions
Date: Thu, 22 Sep 2011 11:36:19 +0300
Message-Id: <1316680579-5055-1-git-send-email-ilane@ti.com> (sfid-20110922_103851_916811_05E0FA8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Protect 'cb' and 'cb_context' arguments in nci_data_exchange.
In fact, this implements a queue with max length of 1 data
exchange transactions in parallel.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci_core.h |    1 +
 net/nfc/nci/core.c         |   10 +++++++++-
 net/nfc/nci/data.c         |    2 ++
 net/nfc/nci/ntf.c          |    2 +-
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 2563f3a..b8b4bbd 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -40,6 +40,7 @@ enum {
 	NCI_UP,
 	NCI_DISCOVERY,
 	NCI_POLL_ACTIVE,
+	NCI_DATA_EXCHANGE,
 };
 
 /* NCI timeouts */
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 895e5fd..2fcbe58 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -452,6 +452,7 @@ static int nci_data_exchange(struct nfc_dev *nfc_dev, __u32 target_idx,
 						void *cb_context)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+	int rc;
 
 	nfc_dbg("entry, target_idx %d, len %d", target_idx, skb->len);
 
@@ -460,11 +461,18 @@ static int nci_data_exchange(struct nfc_dev *nfc_dev, __u32 target_idx,
 		return -EINVAL;
 	}
 
+	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+		return -EBUSY;
+
 	/* store cb and context to be used on receiving data */
 	ndev->data_exchange_cb = cb;
 	ndev->data_exchange_cb_context = cb_context;
 
-	return nci_send_data(ndev, ndev->conn_id, skb);
+	rc = nci_send_data(ndev, ndev->conn_id, skb);
+	if (rc)
+		clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
+
+	return rc;
 }
 
 static struct nfc_ops nci_nfc_ops = {
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 141790a..e5ed90f 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -54,6 +54,8 @@ void nci_data_exchange_complete(struct nci_dev *ndev,
 		/* no waiting callback, free skb */
 		kfree_skb(skb);
 	}
+
+	clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
 }
 
 /* ----------------- NCI TX Data ----------------- */
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 8dd7535..96633f5 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -215,7 +215,7 @@ static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 	}
 
 	/* complete the data exchange transaction, if exists */
-	if (ndev->data_exchange_cb)
+	if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
 		nci_data_exchange_complete(ndev, NULL, -EIO);
 }
 
-- 
1.7.0.4

