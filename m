Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:2500
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932138AbeGCXE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 19:04:29 -0400
From: peter.oh@bowerswilkins.com
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Peter Oh <peter.oh@bowerswilkins.com>, johannes.berg@intel.com
Subject: [PATCH] cfg80211: inspect off channel operation only when off channel given
Date: Tue,  3 Jul 2018 16:04:12 -0700
Message-Id: <1530659052-5834-1-git-send-email-peter.oh@bowerswilkins.com> (sfid-20180704_010433_980964_E312D5E4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peter Oh <peter.oh@bowerswilkins.com>

NL80211_ATTR_OFFCHANNEL_TX_OK does not mean given channel is always
off channel, but it means the channel given could be off channel.
Hence it should not block the given channel to be used if given
channel does not require off channel mgmt tx although regulatory
domain is non-ETSI.

Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
---
 net/wireless/nl80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4eece06..991042b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9915,7 +9915,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	wdev_lock(wdev);
-	if (params.offchan && !cfg80211_off_channel_oper_allowed(wdev)) {
+	if (params.offchan &&
+	    !cfg80211_chandef_identical(&chandef, &wdev->chandef) &&
+	    !cfg80211_off_channel_oper_allowed(wdev)) {
 		wdev_unlock(wdev);
 		return -EBUSY;
 	}
-- 
2.7.4
