Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:32974 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbaBEVhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 16:37:52 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so512664eae.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Feb 2014 13:37:50 -0800 (PST)
From: andrea merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"andrea.merello" <andrea.merello@gmail.com>
Subject: [PATCH 4/4] Write beacon interval register when beacon interval changes
Date: Wed,  5 Feb 2014 22:38:07 +0100
Message-Id: <1391636287-17712-5-git-send-email-andrea.merello@gmail.com> (sfid-20140205_223758_243594_19F92494)
In-Reply-To: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com>
References: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "andrea.merello" <andrea.merello@gmail.com>

HW Specifications says this register has to be written whenever the NIC joins
(or creates) a network (BSS and IBSS).

I suspect that not writing the beacon interval register is probably not a
big issue (probably related to functions not used in the driver right now).
Possibly power-save and HW beaconing.
But I'm not sure it is only needed for that purposes..

On the other hand I'm sure writing it will not hurt anyway.

This patch adds register write on beacon interval changes.

Signed-off-by: andrea.merello <andrea.merello@gmail.com>
Signed-off-by: andrea merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 9645ed2..88f3afd 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -806,6 +806,10 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 
 	vif_priv = (struct rtl8180_vif *)&vif->drv_priv;
 
+	if (changed & BSS_CHANGED_BEACON_INT)
+		rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL,
+				  info->beacon_int);
+
 	if (changed & BSS_CHANGED_BSSID) {
 		for (i = 0; i < ETH_ALEN; i++)
 			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
-- 
1.8.3.2

