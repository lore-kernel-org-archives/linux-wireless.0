Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48756 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab3JQHmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 04/21] rt2x00: rt2800pci: use rt2800mmio prefix for RX control handler functions
Date: Thu, 17 Oct 2013 09:42:18 +0200
Message-Id: <1381995755-16471-5-git-send-email-juhosg@openwrt.org> (sfid-20131017_094247_333853_C9F36DB7)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions are used for devices with memory
mapped I/O and contain no PCI specific code at
all. Use rt2800mmio prefix instead of rt2800pci
in the function names to reflect that.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b2e2b09..37ac888 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -630,8 +630,8 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * RX control handlers
  */
-static void rt2800pci_fill_rxdone(struct queue_entry *entry,
-				  struct rxdone_entry_desc *rxdesc)
+static void rt2800mmio_fill_rxdone(struct queue_entry *entry,
+				   struct rxdone_entry_desc *rxdesc)
 {
 	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	__le32 *rxd = entry_priv->desc;
@@ -1119,7 +1119,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
 	.clear_beacon		= rt2800_clear_beacon,
-	.fill_rxdone		= rt2800pci_fill_rxdone,
+	.fill_rxdone		= rt2800mmio_fill_rxdone,
 	.config_shared_key	= rt2800_config_shared_key,
 	.config_pairwise_key	= rt2800_config_pairwise_key,
 	.config_filter		= rt2800_config_filter,
-- 
1.7.10
