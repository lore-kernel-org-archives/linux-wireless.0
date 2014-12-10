Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33829 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaLJJXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 04:23:31 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so2994204wgg.38
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2014 01:23:29 -0800 (PST)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Henning Rogge <hrogge@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: [PATCH] iw: Fix calculation of maximum supported 802.11n data rate
Date: Wed, 10 Dec 2014 10:23:20 +0100
Message-Id: <1418203400-6451-1-git-send-email-hrogge@gmail.com> (sfid-20141210_102335_618229_C219E8CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix typo in calculation, binary AND combination of low byte
and high byte is always zero.

Signed-off-by: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
---
 util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util.c b/util.c
index ce4b0ac..c61955c 100644
--- a/util.c
+++ b/util.c
@@ -594,7 +594,7 @@ void print_ht_mcs(const __u8 *mcs)
 	unsigned int tx_max_num_spatial_streams, max_rx_supp_data_rate;
 	bool tx_mcs_set_defined, tx_mcs_set_equal, tx_unequal_modulation;
 
-	max_rx_supp_data_rate = (mcs[10] & ((mcs[11] & 0x3) << 8));
+	max_rx_supp_data_rate = (mcs[10] | ((mcs[11] & 0x3) << 8));
 	tx_mcs_set_defined = !!(mcs[12] & (1 << 0));
 	tx_mcs_set_equal = !(mcs[12] & (1 << 1));
 	tx_max_num_spatial_streams = ((mcs[12] >> 2) & 3) + 1;
-- 
1.9.3

