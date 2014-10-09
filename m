Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16710 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJIKAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 06:00:09 -0400
Date: Thu, 9 Oct 2014 12:59:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] ipw2x00: clean up a condition
Message-ID: <20141009095939.GB20875@mwanda> (sfid-20141009_120014_104500_7BEDB42C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original condition was "(PAGE_SIZE - len)" when "(len < PAGE_SIZE)"
is intended.

This condition is not really sufficient, but also not really needed...
If "len > PAGE_SIZE" then it we will print a warning message in dmesg
but there are no other effects.  Maybe we should just remove the
condition?

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index edc3443..67cad9b 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -1363,7 +1363,7 @@ static ssize_t show_cmd_log(struct device *d,
 	if (!priv->cmdlog)
 		return 0;
 	for (i = (priv->cmdlog_pos + 1) % priv->cmdlog_len;
-	     (i != priv->cmdlog_pos) && (PAGE_SIZE - len);
+	     (i != priv->cmdlog_pos) && (len < PAGE_SIZE);
 	     i = (i + 1) % priv->cmdlog_len) {
 		len +=
 		    snprintf(buf + len, PAGE_SIZE - len,
