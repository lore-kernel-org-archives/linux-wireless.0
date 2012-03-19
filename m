Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42222 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2CSNoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 09:44:09 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] e1000: Silence sparse warnings by correcting type
Date: Mon, 19 Mar 2012 15:44:22 +0200
Message-Id: <1332164662-18232-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120319_144413_552387_09136DD2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Silence sparse warnings shown below:
...
drivers/net/ethernet/intel/e1000/e1000_main.c:3435:17: warning:
	cast to restricted __le64
drivers/net/ethernet/intel/e1000/e1000_main.c:3435:17: warning:
	cast to restricted __le64
...

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 6419a88..1bf73cf 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -3377,7 +3377,7 @@ static void e1000_dump(struct e1000_adapter *adapter)
 	for (i = 0; tx_ring->desc && (i < tx_ring->count); i++) {
 		struct e1000_tx_desc *tx_desc = E1000_TX_DESC(*tx_ring, i);
 		struct e1000_buffer *buffer_info = &tx_ring->buffer_info[i];
-		struct my_u { u64 a; u64 b; };
+		struct my_u { __le64 a; __le64 b; };
 		struct my_u *u = (struct my_u *)tx_desc;
 		const char *type;
 
@@ -3421,7 +3421,7 @@ rx_ring_summary:
 	for (i = 0; rx_ring->desc && (i < rx_ring->count); i++) {
 		struct e1000_rx_desc *rx_desc = E1000_RX_DESC(*rx_ring, i);
 		struct e1000_buffer *buffer_info = &rx_ring->buffer_info[i];
-		struct my_u { u64 a; u64 b; };
+		struct my_u { __le64 a; __le64 b; };
 		struct my_u *u = (struct my_u *)rx_desc;
 		const char *type;
 
-- 
1.7.9.1

