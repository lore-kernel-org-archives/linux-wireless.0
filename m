Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51951 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJXIQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 04:16:13 -0400
Date: Fri, 24 Oct 2014 11:15:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ipw2x00: shift wrap bugs setting ->rt_tsf
Message-ID: <20141024081534.GA11140@mwanda> (sfid-20141024_101621_084506_4460186C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ->parent_tsf[] array holds u8 values.  It type promoted to int for
the shift operation so the "<< 24" shift operation can wrap.  The cast
needs to be done before the shift instead of after.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker work.  Untested.

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index edc3443..7e1f2af 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -7819,10 +7819,10 @@ static void ipw_handle_data_packet_monitor(struct ipw_priv *priv,
 
 	/* Zero the flags, we'll add to them as we go */
 	ipw_rt->rt_flags = 0;
-	ipw_rt->rt_tsf = (u64)(frame->parent_tsf[3] << 24 |
-			       frame->parent_tsf[2] << 16 |
-			       frame->parent_tsf[1] << 8  |
-			       frame->parent_tsf[0]);
+	ipw_rt->rt_tsf = (u64)frame->parent_tsf[3] << 24 |
+			      frame->parent_tsf[2] << 16 |
+			      frame->parent_tsf[1] << 8  |
+			      frame->parent_tsf[0];
 
 	/* Convert signal to DBM */
 	ipw_rt->rt_dbmsignal = antsignal;
@@ -8028,10 +8028,10 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
 
 	/* Zero the flags, we'll add to them as we go */
 	ipw_rt->rt_flags = 0;
-	ipw_rt->rt_tsf = (u64)(frame->parent_tsf[3] << 24 |
-			       frame->parent_tsf[2] << 16 |
-			       frame->parent_tsf[1] << 8  |
-			       frame->parent_tsf[0]);
+	ipw_rt->rt_tsf = (u64)frame->parent_tsf[3] << 24 |
+			      frame->parent_tsf[2] << 16 |
+			      frame->parent_tsf[1] << 8  |
+			      frame->parent_tsf[0];
 
 	/* Convert to DBM */
 	ipw_rt->rt_dbmsignal = signal;
