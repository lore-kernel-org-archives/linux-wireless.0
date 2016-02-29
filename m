Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 090/113] rtl8xxxu: Do not unconditionally print debug info in rtl8723bu_handle_c2h()
Date: Mon, 29 Feb 2016 17:05:28 -0500
Message-Id: <1456783551-28315-91-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232953_286858_0923AA46)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Reduce the log level in rtl8723bu_handle_c2h()

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c69a062..d137915c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7296,29 +7296,29 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 
 	len = skb->len - 2;
 
-	dev_info(dev, "C2H ID %02x seq %02x, len %02x source %02x\n",
-		 c2h->id, c2h->seq, len, c2h->bt_info.response_source);
+	dev_dbg(dev, "C2H ID %02x seq %02x, len %02x source %02x\n",
+		c2h->id, c2h->seq, len, c2h->bt_info.response_source);
 
 	switch(c2h->id) {
 	case C2H_8723B_BT_INFO:
 		if (c2h->bt_info.response_source >
 		    BT_INFO_SRC_8723B_BT_ACTIVE_SEND)
-			dev_info(dev, "C2H_BT_INFO WiFi only firmware\n");
+			dev_dbg(dev, "C2H_BT_INFO WiFi only firmware\n");
 		else
-			dev_info(dev, "C2H_BT_INFO BT/WiFi coexist firmware\n");
+			dev_dbg(dev, "C2H_BT_INFO BT/WiFi coexist firmware\n");
 
 		if (c2h->bt_info.bt_has_reset)
-			dev_info(dev, "BT has been reset\n");
+			dev_dbg(dev, "BT has been reset\n");
 		if (c2h->bt_info.tx_rx_mask)
-			dev_info(dev, "BT TRx mask\n");
+			dev_dbg(dev, "BT TRx mask\n");
 
 		break;
 	case C2H_8723B_BT_MP_INFO:
-		dev_info(dev, "C2H_MP_INFO ext ID %02x, status %02x\n",
-			 c2h->bt_mp_info.ext_id, c2h->bt_mp_info.status);
+		dev_dbg(dev, "C2H_MP_INFO ext ID %02x, status %02x\n",
+			c2h->bt_mp_info.ext_id, c2h->bt_mp_info.status);
 		break;
 	default:
-		pr_info("%s: Unhandled C2H event %02x\n", __func__, c2h->id);
+		dev_info(dev, "Unhandled C2H event %02x\n", c2h->id);
 		break;
 	}
 }
-- 
2.5.0

