Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36369 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3GaHIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 03:08:43 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so515200pad.36
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 00:08:43 -0700 (PDT)
From: Mark Schulte <schultetwin@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Mark Schulte <schultetwin@gmail.com>
Subject: [PATCH 2/2] rtlwifi: sparse warnings: cast to restricted type
Date: Wed, 31 Jul 2013 00:08:27 -0700
Message-Id: <1375254507-26154-2-git-send-email-schultetwin@gmail.com> (sfid-20130731_090846_504239_45F85835)
In-Reply-To: <1375254507-26154-1-git-send-email-schultetwin@gmail.com>
References: <1375254507-26154-1-git-send-email-schultetwin@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding type casts to suppress sparse warnings:
 * warning: cast to restricted __le32/__le16

Signed-off-by: Mark Schulte <schultetwin@gmail.com>
---
 drivers/net/wireless/rtlwifi/ps.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 298b615..f646b75 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -688,7 +688,7 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 	find_p2p_ie = true;
 	/*to find noa ie*/
 	while (ie + 1 < end) {
-		noa_len = READEF2BYTE(&ie[1]);
+		noa_len = READEF2BYTE((__le16 *)&ie[1]);
 		if (ie + 3 + ie[1] > end)
 			return;
 
@@ -717,13 +717,13 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 						 READEF1BYTE(ie+index);
 					index += 1;
 					p2pinfo->noa_duration[i] =
-						 READEF4BYTE(ie+index);
+						 READEF4BYTE((__le32 *)ie+index);
 					index += 4;
 					p2pinfo->noa_interval[i] =
-						 READEF4BYTE(ie+index);
+						 READEF4BYTE((__le32 *)ie+index);
 					index += 4;
 					p2pinfo->noa_start_time[i] =
-						 READEF4BYTE(ie+index);
+						 READEF4BYTE((__le32 *)ie+index);
 					index += 4;
 				}
 
@@ -780,7 +780,7 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
 	RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD, "action frame find P2P IE.\n");
 	/*to find noa ie*/
 	while (ie + 1 < end) {
-		noa_len = READEF2BYTE(&ie[1]);
+		noa_len = READEF2BYTE((__le16 *)&ie[1]);
 		if (ie + 3 + ie[1] > end)
 			return;
 
@@ -809,13 +809,13 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
 							 READEF1BYTE(ie+index);
 					index += 1;
 					p2pinfo->noa_duration[i] =
-							 READEF4BYTE(ie+index);
+							 READEF4BYTE((__le32 *)ie+index);
 					index += 4;
 					p2pinfo->noa_interval[i] =
-							 READEF4BYTE(ie+index);
+							 READEF4BYTE((__le32 *)ie+index);
 					index += 4;
 					p2pinfo->noa_start_time[i] =
-							 READEF4BYTE(ie+index);
+							 READEF4BYTE((__le32 *)ie+index);
 					index += 4;
 				}
 
-- 
1.8.3.3

