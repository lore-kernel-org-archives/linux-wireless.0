Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750988AbdILWWB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 18:22:01 -0400
From: Vladis Dronov <vdronov@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Vladis Dronov <vdronov@redhat.com>,
        "# v3 . 1-rc1" <stable@vger.kernel.org>
Subject: [PATCH] nl80211: check for the required netlink attributes presence
Date: Wed, 13 Sep 2017 00:21:21 +0200
Message-Id: <20170912222121.5032-1-vdronov@redhat.com> (sfid-20170913_002218_399530_F8E75DF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211_set_rekey_data() does not check if the required attributes
NL80211_REKEY_DATA_{REPLAY_CTR,KEK,KCK} are present when processing
NL80211_CMD_SET_REKEY_OFFLOAD request. This request can be issued by
users with CAP_NET_ADMIN privilege and may result in NULL dereference
and a system crash. Add a check for the required attributes presence.
This patch is based on the patch by bo Zhang.

This fixes CVE-2017-12153.

References: https://bugzilla.redhat.com/show_bug.cgi?id=1491046
Fixes: e5497d766ad ("cfg80211/nl80211: support GTK rekey offload")
Cc: <stable@vger.kernel.org> # v3.1-rc1
Reported-by: bo Zhang <zhangbo5891001@gmail.com>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0df8023..fbd5593 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10903,6 +10903,9 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (!tb[NL80211_REKEY_DATA_REPLAY_CTR] || !tb[NL80211_REKEY_DATA_KEK] ||
+	    !tb[NL80211_REKEY_DATA_KCK])
+		return -EINVAL;
 	if (nla_len(tb[NL80211_REKEY_DATA_REPLAY_CTR]) != NL80211_REPLAY_CTR_LEN)
 		return -ERANGE;
 	if (nla_len(tb[NL80211_REKEY_DATA_KEK]) != NL80211_KEK_LEN)
-- 
2.9.5
