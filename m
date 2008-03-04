Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935360AbYCDX10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 18:27:26 -0500
Message-Id: <200803042326.m24NQ8FC003269@imap1.linux-foundation.org> (sfid-20080304_232734_066361_025DF13D)
Subject: [patch 03/10] ipw2200: le*_add_cpu conversion
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	marcin.slusarz@gmail.com, yi.zhu@intel.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2008 15:26:08 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2200.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/net/wireless/ipw2200.c~ipw2200-le_add_cpu-conversion drivers/net/wireless/ipw2200.c
--- a/drivers/net/wireless/ipw2200.c~ipw2200-le_add_cpu-conversion
+++ a/drivers/net/wireless/ipw2200.c
@@ -10326,9 +10326,7 @@ static int ipw_tx_skb(struct ipw_priv *p
 					 remaining_bytes,
 					 PCI_DMA_TODEVICE));
 
-			tfd->u.data.num_chunks =
-			    cpu_to_le32(le32_to_cpu(tfd->u.data.num_chunks) +
-					1);
+			le32_add_cpu(&tfd->u.data.num_chunks, 1);
 		}
 	}
 
_
