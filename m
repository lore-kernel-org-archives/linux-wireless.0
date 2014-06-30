Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57697 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbaF3QTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 12:19:21 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so8500681wes.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 09:19:20 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 5/7] rtl8180: disable buggy rate fallback mechanism
Date: Mon, 30 Jun 2014 18:19:10 +0200
Message-Id: <1404145150-16127-1-git-send-email-andrea.merello@gmail.com> (sfid-20140630_181938_271323_3EE6B1C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the driver configures mac80211 to provide two rates for each TX frame:
One initial rate and one alternate fallback rate, each one with its retry count.

HW does not support fully this: rtl8180 doesn't have support for rate scaling at
all, and rtl8185/rtl8187SE supports it in a way that does not fit with mac80211:
The HW does automatically fall back to the next lower rate, and only a lower
limit can be specified, so the HW may TX also on rates in between the two rates
specified by mac80211.  Furthermore only the total TX retry count can be
specified for each packet, while the number of TX attempts before scaling rate
can be configured only globally (not per each packet).

Currently the driver sets the HW auto rate fallback mechanism to quickly scale
rate after a couple of retries, and it uses the alternate rate requested by
mac80211 as fallback limit rate (and it does this even wrongly).

The HW indeed will behave differently than what mac80211 mandates, that is
probably undesirable, and the reported TX retry count may not refer to what
mac80211 thinks, and this could fool mac80211.

This patch makes the driver to declare to mac80211 to support only one rate
configuration for each packet, and it does disable the HW auto rate fallback
mechanism, relying only on SW and letting mac80211 to do all by itself.

This should ensure correct operation and fairness respect to mac80211.
Indeed here tests with iperf do not show significant performance differences.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 4f4fcf8..5303b8f 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -348,7 +348,6 @@ static void rtl8180_handle_tx(struct ieee80211_hw *dev, unsigned int prio)
 			info->flags |= IEEE80211_TX_STAT_ACK;
 
 		info->status.rates[0].count = (flags & 0xFF) + 1;
-		info->status.rates[1].idx = -1;
 
 		ieee80211_tx_status_irqsafe(dev, skb);
 		if (ring->entries - skb_queue_len(&ring->queue) == 2)
@@ -540,8 +539,6 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	entry->plcp_len = cpu_to_le16(plcp_len);
 	entry->tx_buf = cpu_to_le32(mapping);
 
-	entry->flags2 = info->control.rates[1].idx >= 0 ?
-		ieee80211_get_alt_retry_rate(dev, info, 0)->bitrate << 4 : 0;
 	entry->retry_limit = info->control.rates[0].count - 1;
 
 	/* We must be sure that tx_flags is written last because the HW
@@ -864,7 +861,7 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 
 	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
 		rtl818x_iowrite8(priv, &priv->map->WPA_CONF, 0);
-		rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, 0x81);
+		rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, 0);
 	} else {
 		rtl818x_iowrite8(priv, &priv->map->SECURITY, 0);
 
@@ -1738,7 +1735,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	priv = dev->priv;
 	priv->pdev = pdev;
 
-	dev->max_rates = 2;
+	dev->max_rates = 1;
 	SET_IEEE80211_DEV(dev, &pdev->dev);
 	pci_set_drvdata(pdev, dev);
 
-- 
1.9.1

