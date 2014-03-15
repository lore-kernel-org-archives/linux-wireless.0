Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52554 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbaCOR26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 13:28:58 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so2515990eek.18
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2014 10:28:57 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	andrea.merello@gmail.com
Subject: [PATCH 1/4] rtl8180: remove too-early-added rtl8187se enum value
Date: Sat, 15 Mar 2014 18:29:35 +0100
Message-Id: <1394904578-5279-2-git-send-email-andrea.merello@gmail.com> (sfid-20140315_182900_993495_77478123)
In-Reply-To: <1394904578-5279-1-git-send-email-andrea.merello@gmail.com>
References: <1394904578-5279-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While changing board-type variable to enum, I have added enum
value for rtl8187se by mistake.
This will causes gcc warnings with unhandled switch/cases.

Remove it temporarily until I will push also rtl8187se changes.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
index b4a1c79..c2f1c9d 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
@@ -85,7 +85,6 @@ struct rtl8180_priv {
 	enum {
 		RTL818X_CHIP_FAMILY_RTL8180,
 		RTL818X_CHIP_FAMILY_RTL8185,
-		RTL818X_CHIP_FAMILY_RTL8187SE
 	} chip_family;
 	u32 anaparam;
 	u16 rfparam;
-- 
1.8.3.2

