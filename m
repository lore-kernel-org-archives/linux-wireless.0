Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:59580 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab2DIJBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 05:01:17 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net/wireless/wext-core.c: add missing kfree
Date: Mon,  9 Apr 2012 11:01:09 +0200
Message-Id: <1333962069-20801-1-git-send-email-Julia.Lawall@lip6.fr> (sfid-20120409_110134_766958_4ED14609)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Free extra as done in the error-handling code just above.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 net/wireless/wext-core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 9f544c9..22adfeb 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -781,8 +781,10 @@ static int ioctl_standard_iw_point(struct iw_point *iwp, unsigned int cmd,
 		if (cmd == SIOCSIWENCODEEXT) {
 			struct iw_encode_ext *ee = (void *) extra;
 
-			if (iwp->length < sizeof(*ee) + ee->key_len)
-				return -EFAULT;
+			if (iwp->length < sizeof(*ee) + ee->key_len) {
+				err = -EFAULT;
+				goto out;
+			}
 		}
 	}
 

