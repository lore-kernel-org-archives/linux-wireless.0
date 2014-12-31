Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49163 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaKU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:20:29 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so25254289wiw.2
        for <linux-wireless@vger.kernel.org>; Wed, 31 Dec 2014 02:20:28 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, pizza@shaftnet.org
Subject: [RFT 3/3] cw1200: use mac80211 to resize outgoing frames for protected
Date: Wed, 31 Dec 2014 11:20:25 +0100
Message-ID: <52607462.yl7ixH72Rq@debian64> (sfid-20141231_112049_763510_29D47268)
In-Reply-To: <c31517e669693fceff192e510891356cd9ab795e.1420019654.git.chunkeey@googlemail.com>
References: <c31517e669693fceff192e510891356cd9ab795e.1420019654.git.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: add feature flag to enable resizing of
outgoing frames for encryption"  introduced a feature  flag
which has to be set for cw1200 to re-enable resizing of
outgoing frames for hardware-offloaded CCMP connections.

Cc: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/cw1200/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index 3e78cc3..69c1f51 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
@@ -281,6 +281,7 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_SUPPORTS_PS |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
+		    IEEE80211_HW_TAILROOM_CRYPTO |
 		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		    IEEE80211_HW_SUPPORTS_UAPSD |
 		    IEEE80211_HW_CONNECTION_MONITOR |
-- 
2.1.4

