Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:58148 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946137AbXBBVm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Feb 2007 16:42:58 -0500
Received: by an-out-0708.google.com with SMTP id b33so725302ana
        for <linux-wireless@vger.kernel.org>; Fri, 02 Feb 2007 13:42:58 -0800 (PST)
Message-ID: <9e4733910702021342p67df7962yc88625e991efbf2b@mail.gmail.com>
Date: Fri, 2 Feb 2007 16:42:57 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: d80211, redundant casts to iw_handler_def
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two casts are redundant.

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>

-- 
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 7353ed3..260ce9c 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -4313,8 +4313,7 @@ void ieee80211_if_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 	dev->hard_start_xmit = ieee80211_subif_start_xmit;
-	dev->wireless_handlers =
-		(struct iw_handler_def *) &ieee80211_iw_handler_def;
+	dev->wireless_handlers = &ieee80211_iw_handler_def;
 	dev->do_ioctl = ieee80211_ioctl;
 	dev->set_mac_address = ieee80211_set_mac_address;
 	dev->set_multicast_list = ieee80211_set_multicast_list;
@@ -4472,8 +4471,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t
priv_data_len,
         sta_info_init(local);

 	mdev->hard_start_xmit = ieee80211_master_start_xmit;
-	mdev->wireless_handlers =
-		(struct iw_handler_def *) &ieee80211_iw_master_handler_def;
+	mdev->wireless_handlers = &ieee80211_iw_master_handler_def;
         mdev->do_ioctl = ieee80211_ioctl;
 	mdev->change_mtu = ieee80211_change_mtu;
         mdev->tx_timeout = ieee80211_tx_timeout;
