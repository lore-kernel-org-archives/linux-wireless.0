Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35800 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752942AbdBIOhp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Feb 2017 09:37:45 -0500
Received: by mail-wm0-f65.google.com with SMTP id u63so3178014wmu.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2017 06:37:44 -0800 (PST)
From: Iain Hunter <drhunter95@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@aurora.org, Iain Hunter <i-hunter1@ti.com>
Subject: [PATCH v5] wlcore: disable multicast filter in AP mode
Date: Thu,  9 Feb 2017 14:37:28 +0000
Message-Id: <20170209143728.22831-1-i-hunter1@ti.com> (sfid-20170209_153753_855469_ABDB9CE5)
In-Reply-To: <20170131104840.10366-1-i-hunter1@ti.com>
References: <20170131104840.10366-1-i-hunter1@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable AP support for allmulticast for MDNS. It can be enabled by bringing
up the interface with ip command with argument allmulticast on

Signed-off-by: Iain Hunter <i-hunter1@ti.com>
---

PATCH v5: fixes indentation of other closing bracket and missing Signed Off

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
+			}
+		}
 	}
 
 	/*
-- 
2.11.0
