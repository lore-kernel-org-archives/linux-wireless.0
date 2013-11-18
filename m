Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:56543 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KRRDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:03:00 -0500
Received: by mail-bk0-f51.google.com with SMTP id 6so724061bkj.38
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 09:02:58 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH 6/6] cfg80211: Fix setting channel in mgmt_tx parameters
Date: Mon, 18 Nov 2013 19:02:46 +0200
Message-Id: <1384794166-10906-6-git-send-email-egrumbach@gmail.com> (sfid-20131118_180306_080194_80AB8E7F)
In-Reply-To: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

The cfg80211_mgmt_tx_params.chan member wasn't set which
caused a bug in offchan operations.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c2627ba..73ca4fc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7505,6 +7505,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	params.buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
 	params.len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
+	params.chan = chandef.chan;
 	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, &cookie);
 	if (err)
 		goto free_msg;
-- 
1.7.9.5

