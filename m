Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:52879 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYK1Ax2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 19:53:28 -0500
From: herton <herton@mandriva.com.br>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] rtl8187: fix retry count passed in rtl8187_tx
Date: Thu, 27 Nov 2008 22:53:24 -0200
Cc: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811272253.24604.herton@mandriva.com.br> (sfid-20081128_015331_597712_F78F9170)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I mistakenly changed retry count passed in rtl8187_tx in previous change
"rtl8187: feedback transmitted packets using tx close descriptor for
8187B". For 8187 it should represent the number of retries (retry count
limit). As explained by Johannes Berg, .count represents the number of
tries (not retries), and retries = tries - 1.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index ceebeb7..41444e2 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -238,7 +238,7 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 		hdr->flags = cpu_to_le32(flags);
 		hdr->len = 0;
 		hdr->rts_duration = rts_dur;
-		hdr->retry = cpu_to_le32(info->control.rates[0].count << 8);
+		hdr->retry = cpu_to_le32((info->control.rates[0].count - 1) << 8);
 		buf = hdr;
 
 		ep = 2;
@@ -256,7 +256,7 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 		memset(hdr, 0, sizeof(*hdr));
 		hdr->flags = cpu_to_le32(flags);
 		hdr->rts_duration = rts_dur;
-		hdr->retry = cpu_to_le32(info->control.rates[0].count << 8);
+		hdr->retry = cpu_to_le32((info->control.rates[0].count - 1) << 8);
 		hdr->tx_duration =
 			ieee80211_generic_frame_duration(dev, priv->vif,
 							 skb->len, txrate);
-- 
1.6.0.4

