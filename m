Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30801 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2IWQdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2012 12:33:18 -0400
Date: Sun, 23 Sep 2012 19:33:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>, Avinash Patil <patila@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: potential corruption in
 mwifiex_update_uap_custom_ie()
Message-ID: <20120923163300.GB21396@elgon.mountain> (sfid-20120923_183324_682642_2F07C96E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ap_custom_ie is a struct mwifiex_ie_list which is quite different and
also larger than struct mwifiex_ie.  It's a difference between 4196
bytes and 262.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is a static checker fix and I don't have the hardware to test it.
Please review it carefully.

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 1d8dd00..fa3a80f 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -160,7 +160,7 @@ mwifiex_update_uap_custom_ie(struct mwifiex_private *priv,
 	u16 len;
 	int ret;
 
-	ap_custom_ie = kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+	ap_custom_ie = kzalloc(sizeof(*ap_custom_ie), GFP_KERNEL);
 	if (!ap_custom_ie)
 		return -ENOMEM;
 
