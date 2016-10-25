Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:57241 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965501AbcJYUVq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 16:21:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] cw1200: fix bogus maybe-uninitialized warning
Date: Tue, 25 Oct 2016 22:21:04 +0200
Message-Id: <20161025202121.1070879-1-arnd@arndb.de> (sfid-20161025_222213_712206_14DE4C10)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On x86, the cw1200 driver produces a rather silly warning about the
possible use of the 'ret' variable without an initialization
presumably after being confused by the architecture specific definition
of WARN_ON:

drivers/net/wireless/st/cw1200/wsm.c: In function ‘wsm_handle_rx’:
drivers/net/wireless/st/cw1200/wsm.c:1457:9: error: ‘ret’ may be used uninitialized in this function [-Werror=maybe-uninitialized]

We have already checked that 'count' is larger than 0 here, so
we know that 'ret' is initialized. Changing the 'for' loop
into do/while also makes this clear to the compiler.

Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/st/cw1200/wsm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

v2: rewrite based on David Laight's suggestion, the first version
    was completely wrong.

diff --git a/drivers/net/wireless/st/cw1200/wsm.c b/drivers/net/wireless/st/cw1200/wsm.c
index 680d60eabc75..ed93bf3474ec 100644
--- a/drivers/net/wireless/st/cw1200/wsm.c
+++ b/drivers/net/wireless/st/cw1200/wsm.c
@@ -379,7 +379,6 @@ static int wsm_multi_tx_confirm(struct cw1200_common *priv,
 {
 	int ret;
 	int count;
-	int i;
 
 	count = WSM_GET32(buf);
 	if (WARN_ON(count <= 0))
@@ -395,11 +394,10 @@ static int wsm_multi_tx_confirm(struct cw1200_common *priv,
 	}
 
 	cw1200_debug_txed_multi(priv, count);
-	for (i = 0; i < count; ++i) {
+	do {
 		ret = wsm_tx_confirm(priv, buf, link_id);
-		if (ret)
-			return ret;
-	}
+	} while (!ret && --count);
+
 	return ret;
 
 underflow:
-- 
2.9.0
