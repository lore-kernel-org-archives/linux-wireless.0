Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:42572 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab2C0OvV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 10:51:21 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH 4/4] rt2x00: zero registers of unused TX rings
Date: Tue, 27 Mar 2012 16:51:07 +0200
Message-Id: <1332859867-27921-5-git-send-email-kubakici@wp.pl> (sfid-20120327_165127_324513_CF46CD41)
In-Reply-To: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed if we take over after drivers which use those.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index f39587b..1d24124 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -394,6 +394,16 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX3, 0);
 	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX3, 0);
 
+	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR4, 0);
+	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT4, 0);
+	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX4, 0);
+	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX4, 0);
+
+	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR5, 0);
+	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT5, 0);
+	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX5, 0);
+	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX5, 0);
+
 	entry_priv = rt2x00dev->rx->entries[0].priv_data;
 	rt2x00pci_register_write(rt2x00dev, RX_BASE_PTR, entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, RX_MAX_CNT,
-- 
1.7.7.6

