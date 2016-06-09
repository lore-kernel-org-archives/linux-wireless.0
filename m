Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbcFISiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 14:38:52 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Colin Ian King <colin.king@canonical.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 4/4] rtl8xxxu: fix typo on variable name, compare against correct variable
Date: Thu,  9 Jun 2016 14:38:50 -0400
Message-Id: <1465497530-18510-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160609_203856_938765_9CA68856)
In-Reply-To: <1465497530-18510-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1465497530-18510-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

path_b_ok is being assigned but immediately after path_a_ok is being
compared to the value 0x03.  This appears to be a typo on the
variable name, compare path_b_ok instead.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index 65c079a..5b825fa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1144,7 +1144,7 @@ static void rtl8192eu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 
 		for (i = 0; i < retry; i++) {
 			path_b_ok = rtl8192eu_rx_iqk_path_b(priv);
-			if (path_a_ok == 0x03) {
+			if (path_b_ok == 0x03) {
 				val32 = rtl8xxxu_read32(priv,
 							REG_RX_POWER_BEFORE_IQK_B_2);
 				result[t][6] = (val32 >> 16) & 0x3ff;
-- 
2.5.5

