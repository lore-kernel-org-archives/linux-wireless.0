Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34237 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab1HKVYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 17:24:19 -0400
Received: by fxh19 with SMTP id 19so1948045fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 14:24:18 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: include HT-PHY in some common code
Date: Fri, 12 Aug 2011 00:03:25 +0200
Message-Id: <1313100206-25922-1-git-send-email-zajec5@gmail.com> (sfid-20110811_232422_759709_43FAE71C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |    1 +
 drivers/net/wireless/b43/xmit.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 654c21e..1adadc8 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2949,6 +2949,7 @@ static void b43_rate_memory_init(struct b43_wldev *dev)
 	case B43_PHYTYPE_G:
 	case B43_PHYTYPE_N:
 	case B43_PHYTYPE_LP:
+	case B43_PHYTYPE_HT:
 		b43_rate_memory_write(dev, B43_OFDM_RATE_6MB, 1);
 		b43_rate_memory_write(dev, B43_OFDM_RATE_12MB, 1);
 		b43_rate_memory_write(dev, B43_OFDM_RATE_18MB, 1);
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 5b82409..b8de62c 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -797,6 +797,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		break;
 	case B43_PHYTYPE_N:
 	case B43_PHYTYPE_LP:
+	case B43_PHYTYPE_HT:
 		/* chanid is the SHM channel cookie. Which is the plain
 		 * channel number in b43. */
 		if (chanstat & B43_RX_CHAN_5GHZ) {
-- 
1.7.3.4

