Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36223 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaCQSwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 14:52:11 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so4429246eek.6
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2014 11:52:10 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH] rtl818x: remove unused conf_erp callback from RF ops struct
Date: Mon, 17 Mar 2014 19:52:42 +0100
Message-Id: <1395082362-12673-1-git-send-email-andrea.merello@gmail.com> (sfid-20140317_195215_570648_5F612513)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ERP configuration is now done outside RF code in both rtl8180
and rtl8187 drivers.

The conf_erp callback in common RF ops struct is now useless.
Remove it.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl818x.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl818x.h b/drivers/net/wireless/rtl818x/rtl818x.h
index fa7f7f6..1815b15 100644
--- a/drivers/net/wireless/rtl818x/rtl818x.h
+++ b/drivers/net/wireless/rtl818x/rtl818x.h
@@ -192,7 +192,6 @@ struct rtl818x_rf_ops {
 	void (*init)(struct ieee80211_hw *);
 	void (*stop)(struct ieee80211_hw *);
 	void (*set_chan)(struct ieee80211_hw *, struct ieee80211_conf *);
-	void (*conf_erp)(struct ieee80211_hw *, struct ieee80211_bss_conf *);
 	u8 (*calc_rssi)(u8 agc, u8 sq);
 };
 
-- 
1.8.3.2

