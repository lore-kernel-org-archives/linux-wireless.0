Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42109 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaK03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:26:29 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so4009908wgh.30
        for <linux-wireless@vger.kernel.org>; Wed, 31 Dec 2014 02:26:28 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	chrischavez@gmx.us, pizza@shaftnet.org, johannes@sipsolutions.net
Subject: [PATCH 3.17 2/3] p54: use mac80211 to resize outgoing frames for protected
Date: Wed, 31 Dec 2014 11:20:10 +0100
Message-ID: <8568428.idsM252yN9@debian64> (sfid-20141231_112632_832109_D7DF4732)
In-Reply-To: <c31517e669693fceff192e510891356cd9ab795e.1420019654.git.chunkeey@googlemail.com>
References: <c31517e669693fceff192e510891356cd9ab795e.1420019654.git.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: add feature flag to enable resizing of
outgoing frames for encryption"  introduced a feature  flag
which has to be set for p54 to re-enable resizing of outgoing
frames for hardware-offloaded CCMP connections.

Cc: stable@vger.kernel.org # mac80211: add feature flag to enable resizing of outgoing frames for encryption
Cc: Kalle Valo <kvalo@codeaurora.org>
Bugzilla: <https://bugzilla.kernel.org/show_bug.cgi?id=90331>
Reported-by: Christopher Chavez <chrischavez@gmx.us>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 97aeff0..b877c7f 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -751,6 +751,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_MFP_CAPABLE |
+		     IEEE80211_HW_TAILROOM_CRYPTO |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-- 
2.1.4

