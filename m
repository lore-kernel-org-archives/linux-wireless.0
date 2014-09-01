Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19873 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbaIAHbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:31:04 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 02/17] mwifiex: avoid processing RX packets with invalid length
Date: Mon, 1 Sep 2014 18:28:50 +0530
Message-ID: <1409576345-13717-3-git-send-email-patila@marvell.com> (sfid-20140901_093110_563376_3A09891E)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index ff05458..27c2bf8 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1271,12 +1271,20 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		 */
 		pkt_len = *((__le16 *)skb_data->data);
 		rx_len = le16_to_cpu(pkt_len);
-		skb_put(skb_data, rx_len);
-		dev_dbg(adapter->dev,
-			"info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
-			card->rxbd_rdptr, wrptr, rx_len);
-		skb_pull(skb_data, INTF_HEADER_LEN);
-		mwifiex_handle_rx_packet(adapter, skb_data);
+		if (WARN_ON(rx_len <= INTF_HEADER_LEN ||
+			    rx_len > MWIFIEX_RX_DATA_BUF_SIZE)) {
+			dev_err(adapter->dev,
+				"Invalid RX len %d, Rd=%#x, Wr=%#x\n",
+				rx_len, card->rxbd_rdptr, wrptr);
+			dev_kfree_skb_any(skb_data);
+		} else {
+			skb_put(skb_data, rx_len);
+			dev_dbg(adapter->dev,
+				"info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
+				card->rxbd_rdptr, wrptr, rx_len);
+			skb_pull(skb_data, INTF_HEADER_LEN);
+			mwifiex_handle_rx_packet(adapter, skb_data);
+		}
 
 		skb_tmp = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
 		if (!skb_tmp) {
-- 
1.8.1.4

