Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:49565 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab3HZV6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 17:58:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Tobias Waldekranz <tobias@waldekranz.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: break a long line into two lines
Date: Mon, 26 Aug 2013 14:57:34 -0700
Message-ID: <1377554254-13519-1-git-send-email-bzhao@marvell.com> (sfid-20130826_235823_605929_B5BF114D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It exceeded 80 characters. Split it into two lines.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index f69d7e0..21c6882 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -69,7 +69,8 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 	memcpy(&tx_header->eth803_hdr, skb_src->data, dt_offset);
 
 	/* Copy SNAP header */
-	snap.snap_type = le16_to_cpu(*(__le16 *) ((u8 *)skb_src->data + dt_offset));
+	snap.snap_type =
+		le16_to_cpu(*(__le16 *) ((u8 *)skb_src->data + dt_offset));
 	dt_offset += sizeof(u16);
 
 	memcpy(&tx_header->rfc1042_hdr, &snap, sizeof(struct rfc_1042_hdr));
-- 
1.8.2.3

