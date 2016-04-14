Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 12/26] rtl8xxxu: Remove misleading warning from rtl8192eu_phy_iqcalibrate()
Date: Thu, 14 Apr 2016 14:58:53 -0400
Message-Id: <1460660347-26299-13-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212530_387031_F4856AD3)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

No actual code flow change, but no need to warn about something that
isn't a prioblem.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 4b309a6..71d375c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5897,8 +5897,6 @@ static void rtl8192eu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 		dev_dbg(dev, "%s: Path A RX IQK failed!\n", __func__);
 
 	if (priv->rf_paths > 1) {
-		dev_warn(dev, "%s: Path B ongoing\n", __func__);
-
 		/* Path A into standby */
 		rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
 		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_AC, 0x10000);
-- 
2.5.5

