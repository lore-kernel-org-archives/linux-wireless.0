Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:54581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab0HKUeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 16:34:23 -0400
Date: Wed, 11 Aug 2010 20:32:16 +0000
From: Denis Kirjanov <dkirjanov@kernel.org>
To: linville@tuxdriver.com
Cc: proski@gnu.org, hermes@gibson.dropbear.id.au, davem@davemloft.net,
	linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH] orinoco: Fix walking past the end of the buffer
Message-ID: <20100811203216.GA25168@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix walking past the end of the bitrate_table array
in the case when the loop counter == BITRATE_TABLE_SIZE.
Mark bitrate as invalid in this case for the orinoco_ioctl_setrate()

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 077baa8..191bc03 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -765,9 +765,12 @@ int orinoco_hw_get_act_bitrate(struct orinoco_private *priv, int *bitrate)
 			if (bitrate_table[i].intersil_txratectrl == val)
 				break;
 
-		if (i >= BITRATE_TABLE_SIZE)
+		if (i >= BITRATE_TABLE_SIZE) {
 			printk(KERN_INFO "%s: Unable to determine current bitrate (0x%04hx)\n",
 			       priv->ndev->name, val);
+			*bitrate = 100001; /* Mark as invalid */
+			break;
+		}
 
 		*bitrate = bitrate_table[i].bitrate * 100000;
 		break;
