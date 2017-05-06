Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49512 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdEFAst (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 20:48:49 -0400
Date: Sat, 6 May 2017 03:48:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] p54: allocate enough space for ->used_rxkeys
Message-ID: <20170506004835.a5awr4v5rba2pmu5@mwanda> (sfid-20170506_024859_377627_EFAFFC77)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have the number of longs, but we should be calculating the number of
bytes needed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
index 4ac6764f4897..3076f646c829 100644
--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -176,8 +176,9 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		 * keeping a extra list for uploaded keys.
 		 */
 
-		priv->used_rxkeys = kzalloc(BITS_TO_LONGS(
-			priv->rx_keycache_size), GFP_KERNEL);
+		priv->used_rxkeys = kcalloc(BITS_TO_LONGS(priv->rx_keycache_size),
+					    sizeof(long),
+					    GFP_KERNEL);
 
 		if (!priv->used_rxkeys)
 			return -ENOMEM;
