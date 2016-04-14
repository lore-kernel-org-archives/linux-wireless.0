Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 06/26] rtl8xxxu: Do not init FPGA0_TX_INFO on 8192eu
Date: Thu, 14 Apr 2016 14:58:47 -0400
Message-Id: <1460660347-26299-7-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212528_859861_64810468)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Like the 8723bu, the vendor driver does not set FPGA0_TX_INFO for
8192eu in the init sequence.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 36bd4fc..ed8c594 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7641,7 +7641,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		goto exit;
 
 	/* RFSW Control - clear bit 14 ?? */
-	if (priv->rtl_chip != RTL8723B)
+	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E)
 		rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
 	/* 0x07000760 */
 	if (priv->rtl_chip == RTL8192E) {
-- 
2.5.5

