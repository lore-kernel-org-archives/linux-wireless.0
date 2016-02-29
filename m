Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 074/113] rtl8xxxu: Set WLAN_ACT_CONTROL per vendor driver setting
Date: Mon, 29 Feb 2016 17:05:12 -0500
Message-Id: <1456783551-28315-75-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230804_435606_3AA957F9)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The initial code set the wrong setting in WLAN_ACT_CONTROL for the
8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index e586f53..b4660c6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5894,7 +5894,7 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 	/*
 	 * WLAN action by PTA
 	 */
-	rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);
+	rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
 
 	/*
 	 * BT select S0/S1 controlled by WiFi
-- 
2.5.0

