Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33887 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754730AbdFXBxW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 21:53:22 -0400
Received: by mail-ot0-f195.google.com with SMTP id p48so6525518otc.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 18:53:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/10] rtlwifi: Uses addr1 instead DA to determine broadcast and multicast addr.
Date: Fri, 23 Jun 2017 20:53:06 -0500
Message-Id: <20170624015309.28099-8-Larry.Finger@lwfinger.net> (sfid-20170624_035338_587317_574F53FB)
In-Reply-To: <20170624015309.28099-1-Larry.Finger@lwfinger.net>
References: <20170624015309.28099-1-Larry.Finger@lwfinger.net>
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
