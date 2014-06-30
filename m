Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64627 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbaF3QSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 12:18:22 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so8104344wgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 09:18:20 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 1/7] rtl818x_pci: Fix BSSID register written incorrectly
Date: Mon, 30 Jun 2014 18:17:48 +0200
Message-Id: <1404145068-15903-1-git-send-email-andrea.merello@gmail.com> (sfid-20140630_181836_049077_370FD6A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BSSID register was written with six byte-writes.
It seems that, similarly to what happens with MAC registers, they needs to be
written with one 16-bit and one 32-bit writes, otherwise the write does not work.

The byte write didn't work only on my rtl8185, while it worked on rtl8180 and
rtl8187se, BTW since there are probably a number of different ASIC revisions out
of there, I let the change to affect all cards.
It shouldn't hurt anyway.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 1e25929..e2dcede 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1461,9 +1461,10 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 	vif_priv = (struct rtl8180_vif *)&vif->drv_priv;
 
 	if (changed & BSS_CHANGED_BSSID) {
-		for (i = 0; i < ETH_ALEN; i++)
-			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
-					 info->bssid[i]);
+		rtl818x_iowrite16(priv, (__le16 __iomem *)&priv->map->BSSID[0],
+				  le16_to_cpu(*(__le16 *)info->bssid));
+		rtl818x_iowrite32(priv, (__le32 __iomem *)&priv->map->BSSID[2],
+				  le32_to_cpu(*(__le32 *)(info->bssid + 2)));
 
 		if (is_valid_ether_addr(info->bssid)) {
 			if (vif->type == NL80211_IFTYPE_ADHOC)
-- 
1.9.1

