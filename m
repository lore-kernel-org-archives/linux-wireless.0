Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755407AbcIUBTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 21:19:31 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 1/4] rtl8xxxu: Fix off by one error calculating pubq
Date: Tue, 20 Sep 2016 21:19:26 -0400
Message-Id: <1474420769-20086-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160921_031936_037042_C683C7DE)
In-Reply-To: <1474420769-20086-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1474420769-20086-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This was detected tracing the 8188eu driver, but doesn't seem to make
any difference when using it.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index ca92022..98fcd7b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3869,7 +3869,7 @@ static void rtl8xxxu_init_queue_reserved_page(struct rtl8xxxu_priv *priv)
 	val32 = (nq << RQPN_NPQ_SHIFT) | (eq << RQPN_EPQ_SHIFT);
 	rtl8xxxu_write32(priv, REG_RQPN_NPQ, val32);
 
-	pubq = fops->total_page_num - hq - lq - nq;
+	pubq = fops->total_page_num - hq - lq - nq - 1;
 
 	val32 = RQPN_LOAD;
 	val32 |= (hq << RQPN_HI_PQ_SHIFT);
-- 
2.7.4
