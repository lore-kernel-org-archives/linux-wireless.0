Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imap1.codethink.co.uk ([176.9.8.82]:55947 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753589AbdKJSs4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Nov 2017 13:48:56 -0500
Date: Fri, 10 Nov 2017 18:48:50 +0000
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Fix memory leak in hwsim_new_radio_nl()
Message-ID: <20171110184850.znghmn7ggw5rwxj6@xylophone.i.decadent.org.uk> (sfid-20171110_194859_620731_ED50E8B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hwsim_new_radio_nl() now copies the name attribute in order to add a
null-terminator.  mac80211_hwsim_new_radio() (indirectly) copies it
again into the net_device structure, so the first copy is not used or
freed later.  Free the first copy before returning.

Fixes: ff4dd73dd2b4 ("mac80211_hwsim: check HWSIM_ATTR_RADIO_NAME length")
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 07a49f58070a..a84b0bffc27d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3108,6 +3108,7 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct hwsim_new_radio_params param = { 0 };
 	const char *hwname = NULL;
+	int ret;
 
 	param.reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
 	param.p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
@@ -3147,7 +3148,9 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.regd = hwsim_world_regdom_custom[idx];
 	}
 
-	return mac80211_hwsim_new_radio(info, &param);
+	ret = mac80211_hwsim_new_radio(info, &param);
+	kfree(hwname);
+	return ret;
 }
 
 static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
-- 
2.15.0.rc0
