Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48621 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaDDQVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 12:21:54 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so3750429wgh.7
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 09:21:53 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com, fengguang.wu@intel.com,
	julia.lawall@lip6.fr
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	andrea.merello@gmail.com
Subject: [PATCH 2/4] rtl8180: fix enabled interrupt mask for rtl8187se
Date: Fri,  4 Apr 2014 18:21:14 +0200
Message-Id: <1396628474-14461-1-git-send-email-andrea.merello@gmail.com> (sfid-20140404_182204_296048_14FCF169)
In-Reply-To: <20140403054254.GA18196@localhost>
References: <20140403054254.GA18196@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When preparing the bitfield to write to HW register, the high-priority
queue error interrupt bit is set two times, and the beacon queue
TX-OK interrupt is not enabled.

Currently this have no functional impact because the high-priority
queue is not used at all, and the beacon queue is not used yet.

This patch removes high-priority queue bits and it adds the
beacon queue missing bit.
It removes also the management queue bits because it is not used.

This was found by static code analyzer.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 98d8256f..cb8275f 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -683,9 +683,8 @@ static void rtl8180_int_enable(struct ieee80211_hw *dev)
 	struct rtl8180_priv *priv = dev->priv;
 
 	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
-		rtl818x_iowrite32(priv, &priv->map->IMR, IMR_TMGDOK |
-			  IMR_TBDER | IMR_THPDER |
-			  IMR_THPDER | IMR_THPDOK |
+		rtl818x_iowrite32(priv, &priv->map->IMR,
+			  IMR_TBDER | IMR_TBDOK |
 			  IMR_TVODER | IMR_TVODOK |
 			  IMR_TVIDER | IMR_TVIDOK |
 			  IMR_TBEDER | IMR_TBEDOK |
-- 
1.8.3.2

