Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321AbcDGSTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:35 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 10/18] rtl8xxxu: Provide special handling when writing RF regs on 8192eu
Date: Thu,  7 Apr 2016 14:19:25 -0400
Message-Id: <1460053173-8494-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_201951_531852_70859445)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8192eu requires clearing/restoring bit 17 in REG_FPGA0_POWER_SAVE
before/after writing RF registers.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c3d69ff..356fdf3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1896,7 +1896,7 @@ static int rtl8xxxu_write_rfreg(struct rtl8xxxu_priv *priv,
 				enum rtl8xxxu_rfpath path, u8 reg, u32 data)
 {
 	int ret, retval;
-	u32 dataaddr;
+	u32 dataaddr, val32;
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_RFREG_WRITE)
 		dev_info(&priv->udev->dev, "%s(%02x) = 0x%06x\n",
@@ -1905,6 +1905,12 @@ static int rtl8xxxu_write_rfreg(struct rtl8xxxu_priv *priv,
 	data &= FPGA0_LSSI_PARM_DATA_MASK;
 	dataaddr = (reg << FPGA0_LSSI_PARM_ADDR_SHIFT) | data;
 
+	if (priv->rtl_chip == RTL8192E) {
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_POWER_SAVE);
+		val32 &= ~0x20000;
+		rtl8xxxu_write32(priv, REG_FPGA0_POWER_SAVE, val32);
+	}
+
 	/* Use XB for path B */
 	ret = rtl8xxxu_write32(priv, rtl8xxxu_rfregs[path].lssiparm, dataaddr);
 	if (ret != sizeof(dataaddr))
@@ -1914,6 +1920,12 @@ static int rtl8xxxu_write_rfreg(struct rtl8xxxu_priv *priv,
 
 	udelay(1);
 
+	if (priv->rtl_chip == RTL8192E) {
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_POWER_SAVE);
+		val32 |= 0x20000;
+		rtl8xxxu_write32(priv, REG_FPGA0_POWER_SAVE, val32);
+	}
+
 	return retval;
 }
 
-- 
2.5.5

