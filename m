Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:62050 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZFVNlq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 09:41:46 -0400
Received: by ewy6 with SMTP id 6so4707761ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 06:41:48 -0700 (PDT)
Message-ID: <4A3FA65D.5030107@gmail.com>
Date: Mon, 22 Jun 2009 17:42:21 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: proski@gnu.org, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] wireless: remove redundant tests on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bufsize and remainder are unsigned. When negative they are wrapped and caught by
the other test.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/orinoco/hermes.c      |    2 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hermes.c b/drivers/net/wireless/orinoco/hermes.c
index f2c918c..1a2fca7 100644
--- a/drivers/net/wireless/orinoco/hermes.c
+++ b/drivers/net/wireless/orinoco/hermes.c
@@ -469,7 +469,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
 	u16 rlength, rtype;
 	unsigned nwords;
 
-	if ((bufsize < 0) || (bufsize % 2))
+	if (bufsize % 2)
 		return -EINVAL;
 
 	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS, rid, NULL);
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 7e65d7c..870fb98 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -280,7 +280,7 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 				(ieee80211_get_tx_rate(dev, info)->bitrate * 2) / 10);
 		remainder = (16 * (skb->len + 4)) %
 			    ((ieee80211_get_tx_rate(dev, info)->bitrate * 2) / 10);
-		if (remainder > 0 && remainder <= 6)
+		if (remainder <= 6)
 			plcp_len |= 1 << 15;
 	}
 
