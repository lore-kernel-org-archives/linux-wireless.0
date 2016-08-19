Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755205AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 09/20] rtl8xxxu: Simplify code setting TX buffer boundary
Date: Fri, 19 Aug 2016 17:46:31 -0400
Message-Id: <1471643202-26250-10-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234840_201587_0D50A723)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

With all devices now offering fops->total_page_num, get rid of the
if mess for setting the TX buffer boundary.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index efe24a6..7a697c0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3968,13 +3968,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		/*
 		 * Set TX buffer boundary
 		 */
-		if (priv->rtl_chip == RTL8192E)
-			val8 = TX_TOTAL_PAGE_NUM_8192E + 1;
-		else
-			val8 = TX_TOTAL_PAGE_NUM + 1;
-
-		if (priv->rtl_chip == RTL8723B)
-			val8 -= 1;
+		val8 = priv->fops->total_page_num + 1;
 
 		rtl8xxxu_write8(priv, REG_TXPKTBUF_BCNQ_BDNY, val8);
 		rtl8xxxu_write8(priv, REG_TXPKTBUF_MGQ_BDNY, val8);
-- 
2.7.4
