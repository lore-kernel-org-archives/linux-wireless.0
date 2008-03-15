Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:42247 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbYCOQCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2008 12:02:40 -0400
Date: Sat, 15 Mar 2008 17:02:36 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jgarzik@pobox.com, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 1/7] drivers/net/wireless/b43/lo.c: remove unused variable
Message-ID: <Pine.LNX.4.64.0803151702120.24178@ask.diku.dk> (sfid-20080315_160355_385538_2EAB54D5)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

The variable trsw_rx is initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/net/wireless/b43/lo.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -u -p a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
--- a/drivers/net/wireless/b43/lo.c	2008-03-12 14:13:14.000000000 +0100
+++ b/drivers/net/wireless/b43/lo.c	2008-03-15 15:56:58.000000000 +0100
@@ -493,15 +493,12 @@ static void lo_measure_gain_values(struc
 		max_rx_gain = 0;
 
 	if (has_loopback_gain(phy)) {
-		int trsw_rx = 0;
 		int trsw_rx_gain;
 
 		if (use_trsw_rx) {
 			trsw_rx_gain = phy->trsw_rx_gain / 2;
-			if (max_rx_gain >= trsw_rx_gain) {
+			if (max_rx_gain >= trsw_rx_gain)
 				trsw_rx_gain = max_rx_gain - trsw_rx_gain;
-				trsw_rx = 0x20;
-			}
 		} else
 			trsw_rx_gain = max_rx_gain;
 		if (trsw_rx_gain < 9) {
