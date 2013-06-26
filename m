Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41135 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZPPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 11:15:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iw: fix incorrect bit shifting in print_ht_mcs
Date: Wed, 26 Jun 2013 11:07:40 -0400
Message-Id: <1372259260-7061-1-git-send-email-linville@tuxdriver.com> (sfid-20130626_171517_427761_C5668667)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

>From a Coverity run on version 3.10:

iw-3.10/util.c:569:result_independent_of_operands –
	"mcs[10] >> 8" is 0 regardless of the values of its operands. This occurs as the bitwise first operand of '&'.

This seems more like what was intended...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util.c b/util.c
index d8b76ee..e3d0c27 100644
--- a/util.c
+++ b/util.c
@@ -574,7 +574,7 @@ void print_ht_mcs(const __u8 *mcs)
 	unsigned int tx_max_num_spatial_streams, max_rx_supp_data_rate;
 	bool tx_mcs_set_defined, tx_mcs_set_equal, tx_unequal_modulation;
 
-	max_rx_supp_data_rate = ((mcs[10] >> 8) & ((mcs[11] & 0x3) << 8));
+	max_rx_supp_data_rate = (mcs[10] & ((mcs[11] & 0x3) << 8));
 	tx_mcs_set_defined = !!(mcs[12] & (1 << 0));
 	tx_mcs_set_equal = !(mcs[12] & (1 << 1));
 	tx_max_num_spatial_streams = ((mcs[12] >> 2) & 3) + 1;
-- 
1.8.1.4

