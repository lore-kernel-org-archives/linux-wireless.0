Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 05/26] rtl8xxxu: Do not set REG_PBP on 8192eu
Date: Thu, 14 Apr 2016 14:58:46 -0400
Message-Id: <1460660347-26299-6-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205916_491954_E579AC0E)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The vendor driver does not set REG_PBP on 8192eu. Whether this is due
to the device not supporting it or simply an oversight in the vendor
driver is not clear.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 9e9d3e3..36bd4fc 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7688,7 +7688,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	else
 		val8 = (PBP_PAGE_SIZE_128 << PBP_PAGE_SIZE_RX_SHIFT) |
 			(PBP_PAGE_SIZE_128 << PBP_PAGE_SIZE_TX_SHIFT);
-	rtl8xxxu_write8(priv, REG_PBP, val8);
+	if (priv->rtl_chip != RTL8192E)
+		rtl8xxxu_write8(priv, REG_PBP, val8);
 
 	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
 	if (!macpower) {
-- 
2.5.5

