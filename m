Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13105 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092Ab3LCHSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 02/12] mwifiex: declare snap_type as __be16 variable
Date: Mon, 2 Dec 2013 23:17:49 -0800
Message-ID: <1386055079-6623-3-git-send-email-bzhao@marvell.com> (sfid-20131203_081844_488345_8AF7E6CC)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Actually we are updating snap_type with h_proto (__be16 variable)
in ethernet frame header. Hence endianness conversion is not
required.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 6 +++---
 drivers/net/wireless/mwifiex/fw.h       | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 1214c58..63211707 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -69,9 +69,9 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 	memcpy(&tx_header->eth803_hdr, skb_src->data, dt_offset);
 
 	/* Copy SNAP header */
-	snap.snap_type =
-		le16_to_cpu(*(__le16 *) ((u8 *)skb_src->data + dt_offset));
-	dt_offset += sizeof(u16);
+	snap.snap_type = ((struct ethhdr *)skb_src->data)->h_proto;
+
+	dt_offset += sizeof(__be16);
 
 	memcpy(&tx_header->rfc1042_hdr, &snap, sizeof(struct rfc_1042_hdr));
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 6998413..8fcb500 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -30,7 +30,7 @@ struct rfc_1042_hdr {
 	u8 llc_ssap;
 	u8 llc_ctrl;
 	u8 snap_oui[3];
-	u16 snap_type;
+	__be16 snap_type;
 };
 
 struct rx_packet_hdr {
-- 
1.8.2.3

