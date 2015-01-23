Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:39410 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbbAWRKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:10:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 1/6] rtlwifi: Change logging level for key change
Date: Fri, 23 Jan 2015 11:10:39 -0600
Message-Id: <1422033044-7461-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150123_181120_499664_7C037FD2)
In-Reply-To: <1422033044-7461-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1422033044-7461-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent change in key handling included logging of these changes for
all debug levels. Such key changes should only be logged when a high
level of debugging is enabled.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/cam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
index 3ef870d..6e64792 100644
--- a/drivers/net/wireless/rtlwifi/cam.c
+++ b/drivers/net/wireless/rtlwifi/cam.c
@@ -406,7 +406,7 @@ u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		}
 	}
 	if (found) {
-		RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
 			 "key_index=%d,cam_bitmap: 0x%x entry_idx=%d\n",
 			  key_index, rtlpriv->sec.cam_bitmap, entry_idx);
 		return entry_idx;
-- 
2.1.2

