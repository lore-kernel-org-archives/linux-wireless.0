Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 14/18] rtl8xxxu: Fix LDPC RX hang issue on 8192eu
Date: Thu,  7 Apr 2016 14:19:29 -0400
Message-Id: <1460053173-8494-15-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_202528_545350_9353813C)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Implement workaround for LDPC RX hands on 8192eu. This was inspired by
workaround found in the 8192eu vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index e06b25e..c800882 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7234,6 +7234,16 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/* ack for xmit mgmt frames. */
 	rtl8xxxu_write32(priv, REG_FWHW_TXQ_CTRL, val32);
 
+	if (priv->rtl_chip == RTL8192E) {
+		/*
+		 * Fix LDPC rx hang issue.
+		 */
+		val32 = rtl8xxxu_read32(priv, REG_AFE_MISC);
+		rtl8xxxu_write8(priv, REG_8192E_LDOV12_CTRL, 0x75);
+		val32 &= 0xfff00fff;
+		val32 |= 0x0007e000;
+		rtl8xxxu_write32(priv, REG_8192E_LDOV12_CTRL, val32);
+	}
 exit:
 	return ret;
 }
-- 
2.5.5

