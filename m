Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:48371 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYLQLEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 06:04:44 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: bring first generation devices back to life
Date: Wed, 17 Dec 2008 12:04:43 +0100
Cc: Artur Skawina <art.08.09@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812171204.43946.chunkeey@web.de> (sfid-20081217_120449_608016_CDD82DE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a serious regression (introduced by:
"p54: fix memory management" 872037115977dc0 )
that affected isl3886+net2280 usb devices operation.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Artur, can you please test the attached patch.
if it works, please add a tested-by/acked/signed-off (whatever you want) line.
---
John,

This patch is made against the current wireless-testing.
(so I hope you don't get any rejects if you merge put it into wireless-2.6 straight away).
Of course, I tried to apply them on top of the last patch (free after tx) and all you
get is little complaint about offsets.. e.g:

patching file p54usb.c
Hunk #1 succeeded at 301 (offset -13 lines).
Hunk #2 succeeded at 327 (offset -13 lines).
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 9c2c651..62c2ad4 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -314,6 +314,8 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
 	struct net2280_tx_hdr *hdr;
 	struct net2280_reg_write *reg;
 	int err = 0;
+	__le32 addr = ((struct p54_hdr *) skb->data)->req_id;
+	__le16 len = cpu_to_le16(skb->len);
 
 	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
 	if (!reg)
@@ -338,8 +340,8 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
 
 	hdr = (void *)skb_push(skb, sizeof(*hdr));
 	memset(hdr, 0, sizeof(*hdr));
-	hdr->device_addr = ((struct p54_hdr *)skb->data)->req_id;
-	hdr->len = cpu_to_le16(skb->len + sizeof(struct p54_hdr));
+	hdr->len = len;
+	hdr->device_addr = addr;
 
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),

