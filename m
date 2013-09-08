Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46258 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3IHGlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 02:41:11 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so4946772pdj.12
        for <linux-wireless@vger.kernel.org>; Sat, 07 Sep 2013 23:41:10 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>,
	Colleen Twitty <colleen@cozybit.com>
Subject: [PATCH v3] mac80211: fix the setting of extended supported rate IE
Date: Sat,  7 Sep 2013 23:40:44 -0700
Message-Id: <1378622444-11247-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130908_084116_918183_3AD5A78A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: select and adjust bitrates according to
channel mode" causes regression and breaks the extended supported rate
IE setting. Since "i" is starting with 8, so this is not necessary
to introduce "skip" here.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Signed-off-by: Colleen Twitty <colleen@cozybit.com>
Reviewed-by: Jason Abele <jason@cozybit.com>
---
v2: remove skip checking (Jason)
v3: remove skip variable (Thomas)

 net/mac80211/util.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3c8283b..aa6d6cc 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2100,7 +2100,7 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	int rate, skip, shift;
+	int rate, shift;
 	u8 i, exrates, *pos;
 	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
 	u32 rate_flags;
@@ -2128,14 +2128,11 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 		pos = skb_put(skb, exrates + 2);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = exrates;
-		skip = 0;
 		for (i = 8; i < sband->n_bitrates; i++) {
 			u8 basic = 0;
 			if ((rate_flags & sband->bitrates[i].flags)
 			    != rate_flags)
 				continue;
-			if (skip++ < 8)
-				continue;
 			if (need_basic && basic_rates & BIT(i))
 				basic = 0x80;
 			rate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
-- 
1.7.9.5

