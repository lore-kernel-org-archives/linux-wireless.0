Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59630 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbZJVSxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:50 -0400
Date: Thu, 22 Oct 2009 20:21:02 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 20/28] mwl8k: set ->interface_modes from the driver data
Message-ID: <20091022182102.GV1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As different chip/firmware combinations support different
interface types.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9c10c88..38d34ae 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -91,6 +91,7 @@ struct mwl8k_device_info {
 	char *helper_image;
 	char *fw_image;
 	struct rxd_ops *rxd_ops;
+	u16 modes;
 };
 
 struct mwl8k_rx_queue {
@@ -3015,6 +3016,7 @@ static struct mwl8k_device_info di_8687 = {
 	.helper_image	= "mwl8k/helper_8687.fw",
 	.fw_image	= "mwl8k/fmimage_8687.fw",
 	.rxd_ops	= &rxd_8687_ops,
+	.modes		= BIT(NL80211_IFTYPE_STATION),
 };
 
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
@@ -3121,7 +3123,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	hw->queues = MWL8K_TX_QUEUES;
 
-	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	hw->wiphy->interface_modes = priv->device_info->modes;
 
 	/* Set rssi and noise values to dBm */
 	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_NOISE_DBM;
-- 
1.5.6.4
