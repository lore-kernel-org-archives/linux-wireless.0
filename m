Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:32353 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2DUMYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 08:24:13 -0400
Date: Sat, 21 Apr 2012 15:23:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] wireless: at76c50x: allocating too much data
Message-ID: <20120421122344.GA15362@elgon.mountain> (sfid-20120421_142419_771872_DE5C9052)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87vcku9sob.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cut and paste mistake, sizeof(struct mib_local) was intended
instead of sizeof(struct mib_phy).  The call to at76_get_mib() uses
sizeof(struct mib_local) correctly, although I changed that to
sizeof(*m) for style reasons after discussion with some of the wireless
maintainers.

The current code works fine because mib_phy structs are larger than
mib_local structs.  But we may as well clean it up.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: use sizeof(*m) instead of sizeof(struct mib_local).

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index faa8bcb..3036c0b 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1122,12 +1122,12 @@ exit:
 static void at76_dump_mib_local(struct at76_priv *priv)
 {
 	int ret;
-	struct mib_local *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
+	struct mib_local *m = kmalloc(sizeof(*m), GFP_KERNEL);
 
 	if (!m)
 		return;
 
-	ret = at76_get_mib(priv->udev, MIB_LOCAL, m, sizeof(struct mib_local));
+	ret = at76_get_mib(priv->udev, MIB_LOCAL, m, sizeof(*m));
 	if (ret < 0) {
 		wiphy_err(priv->hw->wiphy,
 			  "at76_get_mib (LOCAL) failed: %d\n", ret);
