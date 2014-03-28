Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61485 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaC1RK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 13:10:57 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so4314565eek.11
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 10:10:56 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: fengguang.wu@intel.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, andrea.merello@gmail.com
Subject: [PATCH 1/2] rtl8187: fix compile warning
Date: Fri, 28 Mar 2014 18:12:08 +0100
Message-Id: <1396026728-5569-1-git-send-email-andrea.merello@gmail.com> (sfid-20140328_181101_603139_FEC35C19)
In-Reply-To: <5334b1ac.IdF9Kz2kTwX26Omj%fengguang.wu@intel.com>
References: <5334b1ac.IdF9Kz2kTwX26Omj%fengguang.wu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ANAPARAM3 register, defined in the rtl818x common register
struct, is accessed as 16bit by rtl8187se and as 8bit by rtl8187b.
Since I have no documentation about this, I can only stick to
the reference code and to what is known to work.

This issue has been addressed by a patch from Larry Finger
that introduces an "union", in the register struct.
In my last patch-set I applied it on the register struct, but
I forget to update rtl8187 driver too.
This patch does it.

Suggested-by: Larry Finger <Larry.Finger@lwfinger.net> [ Original patch ]
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8187/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index c981bcf..2c79bcc 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -592,7 +592,7 @@ static void rtl8187_set_anaparam(struct rtl8187_priv *priv, bool rfon)
 	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, anaparam);
 	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, anaparam2);
 	if (priv->is_rtl8187b)
-		rtl818x_iowrite8(priv, &priv->map->ANAPARAM3, anaparam3);
+		rtl818x_iowrite8(priv, &priv->map->ANAPARAM3A, anaparam3);
 	reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-- 
1.8.3.2

