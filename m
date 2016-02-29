Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 059/113] rtl8xxxu: Another 8723bu magic register set during init
Date: Mon, 29 Feb 2016 17:04:57 -0500
Message-Id: <1456783551-28315-60-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231021_587904_E4A0B4CE)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

No indication of what register 0xa3 does anywhere in the vendor source.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 473c910..cd5c61b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5996,6 +5996,11 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL + 1, 0x02);
 			/* TX report Timer. Unit: 32us */
 			rtl8xxxu_write16(priv, REG_TX_REPORT_TIME, 0xcdf0);
+
+			/* tmp ps ? */
+			val8 = rtl8xxxu_read8(priv, 0xa3);
+			val8 &= 0xf8;
+			rtl8xxxu_write8(priv, 0xa3, val8);
 		}
 
 		if (priv->ep_tx_normal_queue)
-- 
2.5.0

