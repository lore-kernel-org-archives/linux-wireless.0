Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56678 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaJVTXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 15:23:16 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 5/9] mac80211-hwsim: support creating radios with specific name
Date: Wed, 22 Oct 2014 12:23:02 -0700
Message-Id: <1414005786-27572-5-git-send-email-greearb@candelatech.com> (sfid-20141022_212336_639269_8CFDF516)
In-Reply-To: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
References: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, it can be very difficult to know which is which
if you are trying to do detailed testing.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 00c7b3c..783a9ec 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2023,7 +2023,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
 				       bool reg_strict, bool p2p_device,
 				       bool use_chanctx, bool destroy_on_close,
-				       u32 portid)
+				       u32 portid, const char *hwname)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2042,7 +2042,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 
 	if (use_chanctx)
 		ops = &mac80211_hwsim_mchan_ops;
-	hw = ieee80211_alloc_hw(sizeof(*data), ops);
+	hw = ieee80211_alloc_hw_nm(sizeof(*data), ops, hwname);
 	if (!hw) {
 		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw failed\n");
 		err = -ENOMEM;
@@ -2516,10 +2516,14 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
 	bool destroy_on_close = info->attrs[HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE];
 	bool use_chanctx;
+	const char *hwname = NULL;
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
+	if (info->attrs[HWSIM_ATTR_RADIO_NAME])
+		hwname = nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]);
+
 	if (info->attrs[HWSIM_ATTR_USE_CHANCTX])
 		use_chanctx = true;
 	else
@@ -2538,7 +2542,8 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 
 	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
 					   p2p_device, use_chanctx,
-					   destroy_on_close, info->snd_portid);
+					   destroy_on_close, info->snd_portid,
+					   hwname);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2795,7 +2800,7 @@ static int __init init_mac80211_hwsim(void)
 		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
 						  regd, reg_strict,
 						  support_p2p_device,
-						  channels > 1, false, 0);
+						  channels > 1, false, 0, NULL);
 		if (err < 0)
 			goto out_free_radios;
 	}
-- 
1.7.11.7

