Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 11/18] rtl8xxxu: Handle XTAL value setting on 8192eu
Date: Thu,  7 Apr 2016 14:19:26 -0400
Message-Id: <1460053173-8494-12-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_202008_108793_03DC9466)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Set REG_AFE_XTAL_CTRL on 8192eu to the vendor driver value, and do not
skip setting REG_MAX_AGGR_NUM on 8192eu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 356fdf3..3c732ed 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3608,7 +3608,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
 		}
 	}
 
-	if (priv->rtl_chip != RTL8723B)
+	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E)
 		rtl8xxxu_write8(priv, REG_MAX_AGGR_NUM, 0x0a);
 
 	return 0;
@@ -3813,6 +3813,9 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_LDOA15_CTRL, val32);
 	}
 
+	if (priv->rtl_chip == RTL8192E)
+		rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x000f81fb);
+
 	return 0;
 }
 
-- 
2.5.5

