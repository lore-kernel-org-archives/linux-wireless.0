Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63714 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1ATUbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 15:31:44 -0500
Received: by fxm20 with SMTP id 20so1007506fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 12:31:43 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/3] nl80211: allow passing SSID in nl80211_set_bss
Date: Thu, 20 Jan 2011 22:28:24 +0200
Message-Id: <1295555306-20005-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx cards require knowledge of the real SSID when operating as AP
with SSID hidden in beacon data. Allow passing the real SSID from
usermode apart from beacon data.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/cfg80211.h |    5 +++++
 net/wireless/nl80211.c |    8 ++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1322695..03b1b0c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -607,6 +607,9 @@ struct mpath_info {
  * @ap_isolate: do not forward packets between connected stations
  * @ht_opmode: HT Operation mode
  * 	(u16 = opmode, -1 = do not change)
+ * @ssid_len: length of ssid string
+ *	(>0 = ssid_len, -1 = do not change)
+ * @ssid: SSID string (for AP mode). NULL termination not required.
  */
 struct bss_parameters {
 	int use_cts_prot;
@@ -616,6 +619,8 @@ struct bss_parameters {
 	u8 basic_rates_len;
 	int ap_isolate;
 	int ht_opmode;
+	int ssid_len;
+	u8 *ssid;
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9b62710..ce5453d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2576,6 +2576,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	params.use_short_slot_time = -1;
 	params.ap_isolate = -1;
 	params.ht_opmode = -1;
+	params.ssid_len = -1;
 
 	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
 		params.use_cts_prot =
@@ -2597,6 +2598,13 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_BSS_HT_OPMODE])
 		params.ht_opmode =
 			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_OPMODE]);
+	if (info->attrs[NL80211_ATTR_SSID]) {
+		params.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+		params.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+		if (params.ssid_len == 0 ||
+		    params.ssid_len > IEEE80211_MAX_SSID_LEN)
+			return -EINVAL;
+	}
 
 	if (!rdev->ops->change_bss)
 		return -EOPNOTSUPP;
-- 
1.7.1

