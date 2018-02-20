Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:45065 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbeBTL7q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 06:59:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [4.4-stable 17/22] cw1200: fix bogus maybe-uninitialized warning
Date: Tue, 20 Feb 2018 12:55:04 +0100
Message-Id: <20180220115527.1806578-18-arnd@arndb.de> (sfid-20180220_130423_012136_6DB0A4F9)
In-Reply-To: <20180220115527.1806578-1-arnd@arndb.de>
References: <20180220115527.1806578-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 7fc1503c906f0fac62d3506a6e993e49fb996248 upstream.

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[arnd: rebased to 4.4]
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/cw1200/wsm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/cw1200/wsm.c b/drivers/net/wireless/cw1200/wsm.c
index 9e0ca3048657..3dd46c78c1cc 100644
--- a/drivers/net/wireless/cw1200/wsm.c
+++ b/drivers/net/wireless/cw1200/wsm.c
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
