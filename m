Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:31869 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2HIG6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 02:58:19 -0400
Date: Thu, 9 Aug 2012 09:57:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: use GFP_ATOMIC under spin lock
Message-ID: <20120809065757.GB7925@elgon.mountain> (sfid-20120809_085823_111928_C24C40DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're holding the sta_list_spinlock here so we can't sleep.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 14d4f04..ca4a1f3 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -63,7 +63,7 @@ mwifiex_add_sta_entry(struct mwifiex_private *priv, u8 *mac)
 	if (node)
 		goto done;
 
-	node = kzalloc(sizeof(struct mwifiex_sta_node), GFP_KERNEL);
+	node = kzalloc(sizeof(struct mwifiex_sta_node), GFP_ATOMIC);
 	if (!node)
 		goto done;
 
