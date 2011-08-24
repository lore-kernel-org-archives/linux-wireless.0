Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38185 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab1HXTPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:15:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: correct warning for uninitialized variable 'macstat'
Date: Wed, 24 Aug 2011 15:05:14 -0400
Message-Id: <1314212714-5244-1-git-send-email-linville@tuxdriver.com> (sfid-20110824_211518_286331_D16D1391)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/b43/pio.o
drivers/net/wireless/b43/pio.c: In function ‘pio_rx_frame’:
drivers/net/wireless/b43/pio.c:614:6: warning: ‘macstat’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/pio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index ce8a4bd..fcff923 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -611,7 +611,7 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 	struct b43_wldev *dev = q->dev;
 	struct b43_wl *wl = dev->wl;
 	u16 len;
-	u32 macstat;
+	u32 macstat = 0;
 	unsigned int i, padding;
 	struct sk_buff *skb;
 	const char *err_msg = NULL;
-- 
1.7.4.4

