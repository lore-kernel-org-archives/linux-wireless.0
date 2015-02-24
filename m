Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:48847 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbbBXPXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 10:23:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>,
	Alan Fisher <acf@unixcube.org>
Subject: [PATCH] rtlwifi: Improve handling of IPv6 packets
Date: Tue, 24 Feb 2015 09:23:01 -0600
Message-Id: <1424791381-31863-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150224_162318_341760_62B15868)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Routine rtl_is_special_data() is supposed to identify packets that need to
use a low bit rate so that the probability of successful transmission is
high. The current version has a bug that causes all IPv6 packets to be
labelled as special, with a corresponding low rate of transmission. A
complete fix will be quite intrusive, but until that is available, all
IPv6 packets are identified as regular.

This patch also removes a magic number.

Reported-and-tested-by: Alan Fisher <acf@unixcube.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> [3.18+]
Cc: Alan Fisher <acf@unixcube.org>
---
 drivers/net/wireless/rtlwifi/base.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 1d46774..074f716 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -1386,8 +1386,11 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 		}
 
 		return true;
-	} else if (0x86DD == ether_type) {
-		return true;
+	} else if (ETH_P_IPV6 == ether_type) {
+		/* TODO: Handle any IPv6 cases that need special handling.
+		 * For now, always return false
+		 */
+		goto end;
 	}
 
 end:
-- 
2.1.4

