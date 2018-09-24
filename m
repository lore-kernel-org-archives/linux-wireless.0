Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE1CC43382
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F16B9204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F16B9204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbeIYETt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:19:49 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46856 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbeIYETr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:47 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOF012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 05/11] qtnfmac_pcie: pearl: rename spinlock tx0_lock to tx_lock
Date:   Mon, 24 Sep 2018 15:15:08 -0700
Message-Id: <20180924221514.4273-6-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

tx_lock name will later be reused when common pcie code is extracted to
separate files.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 4e9eb46..791a1e3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -110,7 +110,7 @@ struct qtnf_pcie_pearl_state {
 	/* lock for tx reclaim operations */
 	spinlock_t tx_reclaim_lock;
 	/* lock for tx0 operations */
-	spinlock_t tx0_lock;
+	spinlock_t tx_lock;
 	u8 msi_enabled;
 	u8 tx_stopped;
 	int mps;
@@ -794,7 +794,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	u32 info;
 	int ret = 0;
 
-	spin_lock_irqsave(&priv->tx0_lock, flags);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 
 	if (!qtnf_tx_queue_ready(priv)) {
 		if (skb->dev) {
@@ -802,7 +802,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 			priv->tx_stopped = 1;
 		}
 
-		spin_unlock_irqrestore(&priv->tx0_lock, flags);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
 		return NETDEV_TX_BUSY;
 	}
 
@@ -852,7 +852,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 	}
 
 	priv->tx_done_count++;
-	spin_unlock_irqrestore(&priv->tx0_lock, flags);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	qtnf_pcie_data_tx_reclaim(priv);
 
@@ -1404,7 +1404,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
-	spin_lock_init(&pcie_priv->tx0_lock);
+	spin_lock_init(&pcie_priv->tx_lock);
 	spin_lock_init(&pcie_priv->irq_lock);
 	spin_lock_init(&pcie_priv->tx_reclaim_lock);
 
-- 
2.9.5

