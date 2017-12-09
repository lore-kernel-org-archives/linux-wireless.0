Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34951 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbdLIRhR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Dec 2017 12:37:17 -0500
Received: by mail-ot0-f194.google.com with SMTP id q3so11620007oth.2
        for <linux-wireless@vger.kernel.org>; Sat, 09 Dec 2017 09:37:16 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 1/3] rtlwifi: rtl_pci: 8822BE puts broadcast and multicast packet to HIQ
Date: Sat,  9 Dec 2017 11:37:08 -0600
Message-Id: <20171209173710.9879-2-Larry.Finger@lwfinger.net> (sfid-20171209_183721_943049_EEF3ECB9)
In-Reply-To: <20171209173710.9879-1-Larry.Finger@lwfinger.net>
References: <20171209173710.9879-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Making this change to HIQ, which has high priority, improves the response
time for transmission after TBTT or beacon.

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
index 3e9eb11a38f9..8ae36a263426 100644
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
2.15.1
