Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52658 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbaHRJJr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 05:09:47 -0400
From: Avinash Patil <patila@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Marc Yang <yangyang@marvell.com>
Date: Mon, 18 Aug 2014 02:07:10 -0700
Subject: [PATCH 1/4] mwifiex: avoid processing RX packets with invalid length
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147C21@SC-VEXCH2.marvell.com> (sfid-20140818_110950_727852_0621DDEA)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If rx_len received in interface header from FW is more than
RX buffer size, skb_put for such length results into skb_panic.
Avoid this by not processing such packets. We just print a warning
for such packets and free skb.

Reviewed-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index c16dd2c..fbb0550 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1271,12 +1271,20 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
                 */
                pkt_len = *((__le16 *)skb_data->data);
                rx_len = le16_to_cpu(pkt_len);
-               skb_put(skb_data, rx_len);
-               dev_dbg(adapter->dev,
-                       "info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
-                       card->rxbd_rdptr, wrptr, rx_len);
-               skb_pull(skb_data, INTF_HEADER_LEN);
-               mwifiex_handle_rx_packet(adapter, skb_data);
+               if (WARN_ON(rx_len <= INTF_HEADER_LEN ||
+                           rx_len > MWIFIEX_RX_DATA_BUF_SIZE)) {
+                       dev_err(adapter->dev,
+                               "Invalid RX len %d, Rd=%#x, Wr=%#x\n",
+                               rx_len, card->rxbd_rdptr, wrptr);
+                       dev_kfree_skb_any(skb_data);
+               } else {
+                       skb_put(skb_data, rx_len);
+                       dev_dbg(adapter->dev,
+                               "info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
+                               card->rxbd_rdptr, wrptr, rx_len);
+                       skb_pull(skb_data, INTF_HEADER_LEN);
+                       mwifiex_handle_rx_packet(adapter, skb_data);
+               }

                skb_tmp = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
                if (!skb_tmp) {
-- 
1.8.1.4
