Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38862 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab2IZDbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:31:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 14/15] mwifiex: set txpd when send a mgmt frame for AP and GO mode
Date: Tue, 25 Sep 2012 20:23:44 -0700
Message-Id: <1348629825-12001-15-git-send-email-bzhao@marvell.com> (sfid-20120926_053136_310789_FD09A950)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Set packet type and packet offset in txpd when send a mgmt frame
in AP and GO mode.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Kevin Gan <ganhy@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_txrx.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 012c143..0966ac2 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -284,6 +284,7 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 	struct uap_txpd *txpd;
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
 	int pad, len;
+	u16 pkt_type;
 
 	if (!skb->len) {
 		dev_err(adapter->dev, "Tx: bad packet length: %d\n", skb->len);
@@ -291,6 +292,8 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 		return skb->data;
 	}
 
+	pkt_type = mwifiex_is_skb_mgmt_frame(skb) ? PKT_TYPE_MGMT : 0;
+
 	/* If skb->data is not aligned, add padding */
 	pad = (4 - (((void *)skb->data - NULL) & 0x3)) % 4;
 
@@ -318,6 +321,12 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 		    cpu_to_le32(priv->wmm.user_pri_pkt_tx_ctrl[txpd->priority]);
 
 	/* Offset of actual data */
+	if (pkt_type == PKT_TYPE_MGMT) {
+		/* Set the packet type and add header for management frame */
+		txpd->tx_pkt_type = cpu_to_le16(pkt_type);
+		len += MWIFIEX_MGMT_FRAME_HEADER_SIZE;
+	}
+
 	txpd->tx_pkt_offset = cpu_to_le16(len);
 
 	/* make space for INTF_HEADER_LEN */
-- 
1.7.0.2

