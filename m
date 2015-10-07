Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:17439 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbbJGJdj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 05:33:39 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] nfc: netlink: avoid NULL pointer dereference on error
Date: Wed,  7 Oct 2015 11:33:19 +0200
Message-Id: <1444210399-3913-1-git-send-email-vincent.stehle@laposte.net> (sfid-20151007_113358_084443_A22591C4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function nfc_genl_llc_sdreq() can dereference the dev pointer while
it is NULL on its error path. Create a new error handling label to avoid
that.

This fixes the following coccinelle error:

  ./net/nfc/netlink.c:1175:21-24: ERROR: dev is NULL but dereferenced.

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Thierry Escande <thierry.escande@linux.intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 853172c..51c48f0 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1111,7 +1111,7 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 	dev = nfc_get_device(idx);
 	if (!dev) {
 		rc = -ENODEV;
-		goto exit;
+		goto exit_nodev;
 	}
 
 	device_lock(&dev->dev);
@@ -1176,6 +1176,7 @@ exit:
 
 	nfc_put_device(dev);
 
+exit_nodev:
 	return rc;
 }
 
-- 
2.5.1

