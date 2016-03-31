Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbcCaVIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 17:08:44 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 08/10] rtl8xxxu: Identify 8192eu rev A/B parts correctly
Date: Thu, 31 Mar 2016 17:08:40 -0400
Message-Id: <1459458522-28686-9-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160331_230903_353761_CC246A89)
In-Reply-To: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

8192eu A/B cut parts were incorrectly identified as 8192cu devices.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3857669..201f6cf 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2221,7 +2221,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	} else if (val32 & SYS_CFG_TYPE_ID) {
 		bonding = rtl8xxxu_read32(priv, REG_HPON_FSM);
 		bonding &= HPON_FSM_BONDING_MASK;
-		if (priv->chip_cut >= 3) {
+		if (priv->fops->has_s0s1) {
 			if (bonding == HPON_FSM_BONDING_1T2R) {
 				sprintf(priv->chip_name, "8191EU");
 				priv->rf_paths = 2;
-- 
2.5.5

