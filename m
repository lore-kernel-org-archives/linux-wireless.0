Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22059 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3FFKxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 06:53:09 -0400
MIME-Version: 1.0
Message-ID: <20130606105145.GC12953@debian> (sfid-20130606_125315_241213_CD2920A7)
Date: Thu, 6 Jun 2013 03:51:45 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] cw1200: remove an unreachable goto
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "return" is correct and the unreachable "goto" line is wrong.
I have deleted it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/cw1200/hwio.c b/drivers/net/wireless/cw1200/hwio.c
index 1af7b3d..f6b5efd 100644
--- a/drivers/net/wireless/cw1200/hwio.c
+++ b/drivers/net/wireless/cw1200/hwio.c
@@ -178,7 +178,6 @@ int cw1200_indirect_read(struct cw1200_common *priv, u32 addr, void *buf,
 	if ((buf_len / 2) >= 0x1000) {
 		pr_err("Can't read more than 0xfff words.\n");
 		return -EINVAL;
-		goto out;
 	}
 
 	priv->sbus_ops->lock(priv->sbus_priv);
