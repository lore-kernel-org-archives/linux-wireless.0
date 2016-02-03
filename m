Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933807AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 26/28] rtl8xxxu: Do not mask RF registers to 6 bits
Date: Wed,  3 Feb 2016 13:40:00 -0500
Message-Id: <1454524802-26763-27-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194132_012447_0D66005C)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Newer chips have RF registers beyond the original 0x3f address.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a6c8dab..af17ae7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2536,8 +2536,6 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_priv *priv,
 			continue;
 		}
 
-		reg &= 0x3f;
-
 		ret = rtl8xxxu_write_rfreg(priv, path, reg, val);
 		if (ret) {
 			dev_warn(&priv->udev->dev,
-- 
2.5.0

