Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19604 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbbLDNT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 08:19:58 -0500
Date: Fri, 4 Dec 2015 16:19:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] prism54: off by one BUG_ON() test
Message-ID: <20151204131949.GF12792@mwanda> (sfid-20151204_142010_665052_5C1FFCFA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code was supposed to trigger a BUG() if we truncate the output but
it's off by one so it allows one character to be truncated.  Really
drivers shouldn't call BUG_ON() and especially for something minor like
this so I've changed it to a WARN_ON().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/intersil/prism54/isl_ioctl.c b/drivers/net/wireless/intersil/prism54/isl_ioctl.c
index ecbb054..48e8a97 100644
--- a/drivers/net/wireless/intersil/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/intersil/prism54/isl_ioctl.c
@@ -2036,7 +2036,7 @@ format_event(islpci_private *priv, char *dest, const char *str,
 			 mlme->address,
 			 (error ? (mlme->code ? " : REJECTED " : " : ACCEPTED ")
 			  : ""), mlme->code);
-	BUG_ON(n > IW_CUSTOM_MAX);
+	WARN_ON(n >= IW_CUSTOM_MAX);
 	*length = n;
 }
 
