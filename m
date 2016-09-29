Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755384AbcI2Tk5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 15:40:57 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 2/2] rtl8xxxu: Fix big-endian problem reporting mactime
Date: Thu, 29 Sep 2016 15:40:55 -0400
Message-Id: <1475178055-16924-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160929_214103_415933_C2C4D65F)
In-Reply-To: <1475178055-16924-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1475178055-16924-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The full RX descriptor is converted so converting tsfl again would
return it to it's original endian value.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      | 4 ++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 10166289..08d587a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -238,7 +238,7 @@ struct rtl8xxxu_rxdesc16 {
 	u32 pattern1match:1;
 	u32 pattern0match:1;
 #endif
-	__le32 tsfl;
+	u32 tsfl;
 #if 0
 	u32 bassn:12;
 	u32 bavld:1;
@@ -368,7 +368,7 @@ struct rtl8xxxu_rxdesc24 {
 	u32 ldcp:1;
 	u32 splcp:1;
 #endif
-	__le32 tsfl;
+	u32 tsfl;
 };
 
 struct rtl8xxxu_txdesc32 {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index a96ff17..a5e6ec2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5220,7 +5220,7 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 			rtl8xxxu_rx_parse_phystats(priv, rx_status, phy_stats,
 						   rx_desc->rxmcs);
 
-		rx_status->mactime = le32_to_cpu(rx_desc->tsfl);
+		rx_status->mactime = rx_desc->tsfl;
 		rx_status->flag |= RX_FLAG_MACTIME_START;
 
 		if (!rx_desc->swdec)
@@ -5290,7 +5290,7 @@ int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 		rtl8xxxu_rx_parse_phystats(priv, rx_status, phy_stats,
 					   rx_desc->rxmcs);
 
-	rx_status->mactime = le32_to_cpu(rx_desc->tsfl);
+	rx_status->mactime = rx_desc->tsfl;
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
 	if (!rx_desc->swdec)
-- 
2.7.4
