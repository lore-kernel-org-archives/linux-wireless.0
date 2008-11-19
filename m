Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbYKSAXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 19:23:52 -0500
Subject: [PATCH] iwlagn: fix DMA sync
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <43e72e890811181520r362fd0f9w33d568935d10f732@mail.gmail.com> (sfid-20081119_002251_694020_EE2729FA)
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227005557.4014.47.camel@johannes.berg>
	 <43e72e890811181520r362fd0f9w33d568935d10f732@mail.gmail.com>
	 (sfid-20081119_002251_694020_EE2729FA)
Content-Type: text/plain
Date: Wed, 19 Nov 2008 01:22:51 +0100
Message-Id: <1227054171.4014.89.camel@johannes.berg> (sfid-20081119_012357_022836_0D8AB20B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the RX DMA fix for iwlwifi ("iwlagn: fix RX skb alignment") Luis
pointed out:

> aligned_dma_addr can obviously be > real_dma_addr at this point, what
> guarantees we can use it on our own whim?

I asked around, and he's right, there may be platforms that do not allow
passing such such an address to the DMA API functions. This patch
changes it by using the proper dma_sync_single_range_for_cpu API
invented for this purpose.

Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-19 01:16:12.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-19 01:19:13.000000000 +0100
@@ -1229,9 +1229,11 @@ void iwl_rx_handle(struct iwl_priv *priv
 
 		rxq->queue[i] = NULL;
 
-		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->aligned_dma_addr,
-					    priv->hw_params.rx_buf_size,
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_range_for_cpu(
+				&priv->pci_dev->dev, rxb->real_dma_addr,
+				rxb->aligned_dma_addr - rxb->real_dma_addr,
+				priv->hw_params.rx_buf_size,
+				PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 		/* Reclaim a command buffer only if this packet is a response


