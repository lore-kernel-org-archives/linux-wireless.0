Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37642 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdHaKKg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 06:10:36 -0400
Received: by mail-wm0-f65.google.com with SMTP id x189so4403846wmg.4
        for <linux-wireless@vger.kernel.org>; Thu, 31 Aug 2017 03:10:36 -0700 (PDT)
From: Simon Dinkin <simondinkin@gmail.com>
To: kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Cc: Simon Dinkin <simon.dinkin@tandemg.com>
Subject: [PATCH] mac80211: fix incorrect assignment of reassoc value
Date: Thu, 31 Aug 2017 13:09:36 +0300
Message-Id: <1504174176-13419-1-git-send-email-simon.dinkin@tandemg.com> (sfid-20170831_121040_077462_AA49702B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this fix minor issue in the log message.
in ieee80211_rx_mgmt_assoc_resp function, when assigning the
reassoc value from the mgmt frame control:
ieee80211_is_reassoc_resp function need to be used, instead of
ieee80211_is_reassoc_req function.

Signed-off-by: Simon Dinkin <simon.dinkin@tandemg.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7be7917..0467f9f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3159,7 +3159,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	if (len < 24 + 6)
 		return;
 
-	reassoc = ieee80211_is_reassoc_req(mgmt->frame_control);
+	reassoc = ieee80211_is_reassoc_resp(mgmt->frame_control);
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
-- 
2.7.4
