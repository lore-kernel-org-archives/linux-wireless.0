Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35504 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752138AbdF1PMr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 11:12:47 -0400
Received: by mail-oi0-f65.google.com with SMTP id l130so5799708oib.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jun 2017 08:12:42 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v3 07/10] rtlwifi: Uses addr1 instead DA to determine broadcast and multicast addr.
Date: Wed, 28 Jun 2017 10:12:22 -0500
Message-Id: <20170628151225.22190-8-Larry.Finger@lwfinger.net> (sfid-20170628_171353_454643_49D889AD)
In-Reply-To: <20170628151225.22190-1-Larry.Finger@lwfinger.net>
References: <20170628151225.22190-1-Larry.Finger@lwfinger.net>
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
v3 - no changes
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
