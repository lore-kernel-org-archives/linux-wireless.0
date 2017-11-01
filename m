Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:52230 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754695AbdKAP3l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 11:29:41 -0400
Received: by mail-oi0-f68.google.com with SMTP id c202so5001562oih.9
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 08:29:41 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/11] rtlwifi: rtl_pci: 8822BE puts broadcast and multicast packet to HIQ
Date: Wed,  1 Nov 2017 10:29:24 -0500
Message-Id: <20171101152926.24971-10-Larry.Finger@lwfinger.net> (sfid-20171101_162949_087419_AF3CB04E)
In-Reply-To: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
References: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

HIQ has higher priority to transmit after TBTT or beacon.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index e544f4bcfae9..0a2766385ca2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -59,6 +59,7 @@ static u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	__le16 fc = rtl_get_fc(skb);
 	u8 queue_index = skb_get_queue_mapping(skb);
+	struct ieee80211_hdr *hdr;
 
 	if (unlikely(ieee80211_is_beacon(fc)))
 		return BEACON_QUEUE;
@@ -67,6 +68,13 @@ static u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
 		if (ieee80211_is_nullfunc(fc))
 			return HIGH_QUEUE;
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8822BE) {
+		hdr = rtl_get_hdr(skb);
+
+		if (is_multicast_ether_addr(hdr->addr1) ||
+		    is_broadcast_ether_addr(hdr->addr1))
+			return HIGH_QUEUE;
+	}
 
 	return ac_to_hwq[queue_index];
 }
-- 
2.14.3
