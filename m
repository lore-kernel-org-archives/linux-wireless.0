Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33915 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754065AbdBHOQ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 09:16:58 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so33460384wmi.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2017 06:16:37 -0800 (PST)
From: Iain Hunter <drhunter95@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@aurora.org, Iain Hunter <i-hunter1@ti.com>
Subject: [PATCH v4] wlcore: disable multicast filter in AP mode
Date: Wed,  8 Feb 2017 14:09:40 +0000
Message-Id: <20170208140940.5638-1-i-hunter1@ti.com> (sfid-20170208_151853_269860_38F7C6CF)
In-Reply-To: <20170131104840.10366-1-i-hunter1@ti.com>
References: <20170131104840.10366-1-i-hunter1@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable AP support for allmulticast for MDNS. It can be enabled by bringing
up the interface with ip command with argument allmulticast on

---

PATCH v4: fixes space in signed-off, tabbing for comment and indentation of closing bracket

 drivers/net/wireless/ti/wlcore/main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3241e9eba73..242111cd016 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3281,6 +3281,21 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 			if (ret < 0)
 				goto out_sleep;
 		}
+
+		/*
+		 * If interface in AP mode and created with allmulticast then disable
+		 * the firmware filters so that all multicast packets are passed
+		 * This is mandatory for MDNS based discovery protocols 
+		 */
+ 		if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
+ 			if (*total & FIF_ALLMULTI) {
+				ret = wl1271_acx_group_address_tbl(wl, wlvif,
+							false,
+							NULL, 0);
+				if (ret < 0)
+					goto out_sleep;
+				}
+		}
 	}
 
 	/*
-- 
2.11.0
