Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:36487 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdFYPn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 11:43:57 -0400
Received: by mail-ot0-f196.google.com with SMTP id r67so9298156ota.3
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jun 2017 08:43:56 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 07/10] rtlwifi: Uses addr1 instead DA to determine broadcast and multicast addr.
Date: Sun, 25 Jun 2017 10:43:41 -0500
Message-Id: <20170625154344.19213-8-Larry.Finger@lwfinger.net> (sfid-20170625_174413_268540_83DBB93E)
In-Reply-To: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
References: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

We should check addr1 to indicate a packet as broadcast or multicast
in tx desc. An obvious example, a STA transmit an *unicast* ARP packet
where addr1 and DA are the addresses of AP and broadcast respectively.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 7aa3c39c9c5c..464f14450f75 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1166,9 +1166,9 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 			}
 		}
 
-		if (is_multicast_ether_addr(ieee80211_get_DA(hdr)))
+		if (is_multicast_ether_addr(hdr->addr1))
 			tcb_desc->multicast = 1;
-		else if (is_broadcast_ether_addr(ieee80211_get_DA(hdr)))
+		else if (is_broadcast_ether_addr(hdr->addr1))
 			tcb_desc->broadcast = 1;
 
 		_rtl_txrate_selectmode(hw, sta, tcb_desc);
-- 
2.12.3
