Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24568 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3FFK7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 06:59:14 -0400
MIME-Version: 1.0
Message-ID: <20130606105746.GE12953@debian> (sfid-20130606_125920_380795_CDCD5275)
Date: Thu, 6 Jun 2013 03:57:46 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] cw1200: handle allocation failure in
 wsm_event_indication()
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check for allocation failures and return -ENOMEM.  The caller
already expects it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/cw1200/wsm.c b/drivers/net/wireless/cw1200/wsm.c
index f3fd9b2..3ab25f6 100644
--- a/drivers/net/wireless/cw1200/wsm.c
+++ b/drivers/net/wireless/cw1200/wsm.c
@@ -929,6 +929,8 @@ static int wsm_event_indication(struct cw1200_common *priv, struct wsm_buf *buf)
 	}
 
 	event = kzalloc(sizeof(struct cw1200_wsm_event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
 
 	event->evt.id = __le32_to_cpu(WSM_GET32(buf));
 	event->evt.data = __le32_to_cpu(WSM_GET32(buf));
