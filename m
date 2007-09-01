Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29052 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbXIAEg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:36:27 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 9C681618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:36:26 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 23/35] Simplify at76_get_mib_mdomain()
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:36:26 -0400
Message-ID: <20070901043626.2498.33153.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "error" label is not needed.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 4ad3173..0873111 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1277,15 +1277,13 @@ static int at76_get_mib_mdomain(struct at76_priv *priv, struct mib_mdomain *val)
 
 	ret = at76_get_mib(priv->udev, MIB_MDOMAIN, mdomain,
 			   sizeof(struct mib_mdomain));
-	if (ret < 0) {
+	if (ret < 0)
 		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
-		goto error;
-	}
-
-	memcpy(val, mdomain, sizeof(*val));
+	else
+		memcpy(val, mdomain, sizeof(*val));
 
-error:
 	kfree(mdomain);
+
 exit:
 	return ret;
 }
