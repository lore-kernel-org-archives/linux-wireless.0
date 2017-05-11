Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34634 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932376AbdEKR6D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 13:58:03 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 3/4] staging: rtl8192e: rtl92e_get_eeprom_size Fix read size of EPROM_CMD.
Date: Thu, 11 May 2017 18:57:45 +0100
Message-Id: <20170511175746.12378-3-tvboxspy@gmail.com> (sfid-20170511_195808_481983_8F7A3111)
In-Reply-To: <20170511175746.12378-1-tvboxspy@gmail.com>
References: <20170511175746.12378-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

EPROM_CMD is 2 byte aligned on PCI map so calling with rtl92e_readl
will return invalid data so use rtl92e_readw.

The device is unable to select the right eeprom type.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
v2 - Fix typo in subject line
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
index e03d0a3a6dcc..1c6ed5b2a6f9 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -625,7 +625,7 @@ void rtl92e_get_eeprom_size(struct net_device *dev)
 	struct r8192_priv *priv = rtllib_priv(dev);
 
 	RT_TRACE(COMP_INIT, "===========>%s()\n", __func__);
-	curCR = rtl92e_readl(dev, EPROM_CMD);
+	curCR = rtl92e_readw(dev, EPROM_CMD);
 	RT_TRACE(COMP_INIT, "read from Reg Cmd9346CR(%x):%x\n", EPROM_CMD,
 		 curCR);
 	priv->epromtype = (curCR & EPROM_CMD_9356SEL) ? EEPROM_93C56 :
-- 
2.11.0
