Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33217 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933327AbdEKR6C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 13:58:02 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/4] staging: rtl8192e: fix 2 byte alignment of register BSSIDR.
Date: Thu, 11 May 2017 18:57:44 +0100
Message-Id: <20170511175746.12378-2-tvboxspy@gmail.com> (sfid-20170511_195815_221826_659F5B4F)
In-Reply-To: <20170511175746.12378-1-tvboxspy@gmail.com>
References: <20170511175746.12378-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BSSIDR has two byte alignment on PCI ioremap correct the write
by swapping to 16 bits first.

This fixes a problem that the device associates fail because
the filter is not set correctly.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
v2 - Fix name of register in commit message.
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
index a23628f390c9..e03d0a3a6dcc 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -97,8 +97,9 @@ void rtl92e_set_reg(struct net_device *dev, u8 variable, u8 *val)
 
 	switch (variable) {
 	case HW_VAR_BSSID:
-		rtl92e_writel(dev, BSSIDR, ((u32 *)(val))[0]);
-		rtl92e_writew(dev, BSSIDR+2, ((u16 *)(val+2))[0]);
+		/* BSSIDR 2 byte alignment */
+		rtl92e_writew(dev, BSSIDR, *(u16 *)val);
+		rtl92e_writel(dev, BSSIDR + 2, *(u32 *)(val + 2));
 		break;
 
 	case HW_VAR_MEDIA_STATUS:
@@ -961,8 +962,8 @@ static void _rtl92e_net_update(struct net_device *dev)
 	rtl92e_config_rate(dev, &rate_config);
 	priv->dot11CurrentPreambleMode = PREAMBLE_AUTO;
 	 priv->basic_rate = rate_config &= 0x15f;
-	rtl92e_writel(dev, BSSIDR, ((u32 *)net->bssid)[0]);
-	rtl92e_writew(dev, BSSIDR+4, ((u16 *)net->bssid)[2]);
+	rtl92e_writew(dev, BSSIDR, *(u16 *)net->bssid);
+	rtl92e_writel(dev, BSSIDR + 2, *(u32 *)(net->bssid + 2));
 
 	if (priv->rtllib->iw_mode == IW_MODE_ADHOC) {
 		rtl92e_writew(dev, ATIMWND, 2);
-- 
2.11.0
