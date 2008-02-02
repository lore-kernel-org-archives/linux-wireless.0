Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53793 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934258AbYBBVPc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 16:15:32 -0500
Date: Sat, 2 Feb 2008 23:16:17 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jiri Slaby <jirislaby@gmail.com>, mickflemm@gmail.com,
	mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [RFC: 2.6 patch] ath5k/phy.c: fix negative array index
Message-ID: <20080202211617.GE9375@cs181133002.pp.htv.fi> (sfid-20080202_211537_371236_64A0E7E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a negative array index spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

I'm not 100% sure whether my patch is correct, but if not this patch is 
the easiest way to show the problem.

--- linux-2.6/drivers/net/wireless/ath5k/phy.c.old	2008-02-02 21:44:58.000000000 +0200
+++ linux-2.6/drivers/net/wireless/ath5k/phy.c	2008-02-02 21:48:28.000000000 +0200
@@ -1176,10 +1176,13 @@ static int ath5k_hw_rf5112_rfregs(struct
 		obdb = channel->freq >= 5725 ? 3 :
 		    (channel->freq >= 5500 ? 2 :
 			(channel->freq >= 5260 ? 1 :
 			    (channel->freq > 4000 ? 0 : -1)));
 
+		if (obdb == -1)
+			return -EINVAL;
+
 		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 279, 0, true))
 			return -EINVAL;
 
 		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
