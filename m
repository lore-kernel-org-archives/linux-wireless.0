Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35970 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426283AbdD2MEG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Apr 2017 08:04:06 -0400
Received: by mail-wr0-f195.google.com with SMTP id v42so9506296wrc.3
        for <linux-wireless@vger.kernel.org>; Sat, 29 Apr 2017 05:04:05 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4] staging: vt6656: always call vnt_update_ifs on short time change.
Date: Sat, 29 Apr 2017 13:03:43 +0100
Message-Id: <20170429120345.3782-2-tvboxspy@gmail.com> (sfid-20170429_140417_671993_201AF1A8)
In-Reply-To: <20170429120345.3782-1-tvboxspy@gmail.com>
References: <20170429120345.3782-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

short time change needs to synchronize parameters in vnt_update_ifs so
a call to the function is always necessary.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 028f54b453d0..9237930991ca 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -715,6 +715,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 			priv->short_slot_time = false;
 
 		vnt_set_short_slot_time(priv);
+		vnt_update_ifs(priv);
 		vnt_set_vga_gain_offset(priv, priv->bb_vga[0]);
 		vnt_update_pre_ed_threshold(priv, false);
 	}
-- 
2.11.0
