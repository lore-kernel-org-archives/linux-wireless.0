Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57950 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729311AbeHOTOE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 15:14:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: require at least one channel
Date: Wed, 15 Aug 2018 18:19:59 +0200
Message-Id: <20180815161959.8775-1-johannes@sipsolutions.net> (sfid-20180815_182126_618306_96769BC2)
In-Reply-To: <0000000000006ebad505737b6bf4@google.com>
References: <0000000000006ebad505737b6bf4@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Syzbot continues to try to create mac80211_hwsim radios, and
manages to pass parameters that are later checked with WARN_ON
in cfg80211 - catch another one in hwsim directly.

Reported-by: syzbot+2a12f11c306afe871c1f@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 18e819d964f1..fe1b0108f06d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3194,6 +3194,11 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		param.channels = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
+	if (param.channels < 1) {
+		GENL_SET_ERR_MSG(info, "must have at least one channel");
+		return -EINVAL;
+	}
+
 	if (param.channels > CFG80211_MAX_NUM_DIFFERENT_CHANNELS) {
 		GENL_SET_ERR_MSG(info, "too many channels specified");
 		return -EINVAL;
-- 
2.14.4
