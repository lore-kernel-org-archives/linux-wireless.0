Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:36295 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752175AbdAaMom (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 07:44:42 -0500
Received: by mail-wj0-f194.google.com with SMTP id kq3so10582354wjc.3
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2017 04:44:41 -0800 (PST)
From: Iain Hunter <drhunter95@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@aurora.org, Iain Hunter <i-hunter1@ti.com>
Subject: [PATCH v3] wlcore: disable multicast filter in AP mode
Date: Tue, 31 Jan 2017 12:44:31 +0000
Message-Id: <20170131124431.11675-1-i-hunter1@ti.com> (sfid-20170131_134717_698759_C561821E)
In-Reply-To: <20170131104840.10366-1-i-hunter1@ti.com>
References: <20170131104840.10366-1-i-hunter1@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable AP support for allmulticast for MDNS. It can be enabled by bringing
up the interface with ip command with argument allmulticast on

Signed-off-by:Iain Hunter <i-hunter1@ti.com>
---

PATCH v3: fixes tabbing

 drivers/net/wireless/ti/wlcore/main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3241e9eba73..7d3f15d5d5c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3281,6 +3281,21 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 			if (ret < 0)
 				goto out_sleep;
 		}
+
+        /*
+         * If interface in AP mode and created with allmulticast then disable
+         * the firmware filters so that all multicast packets are passed
+         * This is mandatory for MDNS based discovery protocols 
+         */
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
