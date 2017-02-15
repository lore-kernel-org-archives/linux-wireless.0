Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33784 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdBONVc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 08:21:32 -0500
Received: by mail-lf0-f65.google.com with SMTP id x1so13479815lff.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 05:21:31 -0800 (PST)
From: "=?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?=" <a.miskiewicz@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] mac80211: Print text for disassociation reason
Date: Wed, 15 Feb 2017 14:21:27 +0100
Message-Id: <20170215132127.17177-1-arekm@maven.pl> (sfid-20170215_142204_744692_FF140286)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When disassociation happens only numeric reason is printed
in ieee80211_rx_mgmt_disassoc(). Add text variant, too.

Signed-off-by: Arkadiusz Miśkiewicz <arekm@maven.pl>
---
 net/mac80211/mlme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 098ce9b179ee..fcf8d0aa66ec 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2801,8 +2801,9 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
-	sdata_info(sdata, "disassociated from %pM (Reason: %u)\n",
-		   mgmt->sa, reason_code);
+	sdata_info(sdata, "disassociated from %pM (Reason: %u=%s)\n",
+		   mgmt->sa, reason_code,
+		   ieee80211_get_reason_code_string(reason_code));
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-- 
2.11.0
