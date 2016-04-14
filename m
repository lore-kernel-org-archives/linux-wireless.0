Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 25/26] rtl8xxxu: 8192eu Fix bug in LDPC RX hang fix
Date: Thu, 14 Apr 2016 14:59:06 -0400
Message-Id: <1460660347-26299-26-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205938_293309_06B596DF)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Write the adjusted value back to the correct register

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 5c56a4f..6febda5 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7967,7 +7967,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write8(priv, REG_8192E_LDOV12_CTRL, 0x75);
 		val32 &= 0xfff00fff;
 		val32 |= 0x0007e000;
-		rtl8xxxu_write32(priv, REG_8192E_LDOV12_CTRL, val32);
+		rtl8xxxu_write32(priv, REG_AFE_MISC, val32);
 	}
 exit:
 	return ret;
-- 
2.5.5

