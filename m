Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65219 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0KSLkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 06:40:42 -0500
Received: by bwz15 with SMTP id 15so3773153bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 03:40:41 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/2] cfg80211: Add new BSS attribute ht_opmode
Date: Fri, 19 Nov 2010 12:40:25 +0100
Message-Id: <1290166826-27063-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new BSS attribute to allow hostapd to set the current HT opmode.
Otherwise drivers won't be able to set up protection for HT rates in
AP mode.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Not sure if we also want to pass in some other parts of the HT Operation
IE or maybe the whole IE?

At the moment the HT opmode is sufficient but in the future we might
want to support STBC beaconing and so on. Passing the whole IE would
not require any new interfaces later but also makes the interface less
nice IMO :)

I'll send a patch for hostapd as soon as the interface is agreed on.

Thanks,
Helmut

 include/linux/nl80211.h |    4 ++++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |    5 +++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 037b4e4..edac2ef 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -828,6 +828,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_MCAST_RATE: Multicast tx rate (in 100 kbps) for IBSS
  *
+ * @NL80211_ATTR_BSS_HTOPMODE: HT operation mode (u16)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1002,6 +1004,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MCAST_RATE,
 
+ 	NL80211_ATTR_BSS_HT_OPMODE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 91f0995..a2be9e6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -605,6 +605,8 @@ struct mpath_info {
  *	(or NULL for no change)
  * @basic_rates_len: number of basic rates
  * @ap_isolate: do not forward packets between connected stations
+ * @ht_opmode: HT Operation mode
+ * 	(u16 = opmode, -1 = do not change)
  */
 struct bss_parameters {
 	int use_cts_prot;
@@ -613,6 +615,7 @@ struct bss_parameters {
 	u8 *basic_rates;
 	u8 basic_rates_len;
 	int ap_isolate;
+	int ht_opmode;
 };
 
 struct mesh_config {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b15eb77..d692570 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -121,6 +121,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_BSS_SHORT_SLOT_TIME] = { .type = NLA_U8 },
 	[NL80211_ATTR_BSS_BASIC_RATES] = { .type = NLA_BINARY,
 					   .len = NL80211_MAX_SUPP_RATES },
+	[NL80211_ATTR_BSS_HT_OPMODE] = { .type = NLA_U16 },
 
 	[NL80211_ATTR_MESH_PARAMS] = { .type = NLA_NESTED },
 
@@ -2435,6 +2436,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	params.use_short_preamble = -1;
 	params.use_short_slot_time = -1;
 	params.ap_isolate = -1;
+	params.ht_opmode = -1;
 
 	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
 		params.use_cts_prot =
@@ -2453,6 +2455,9 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	}
 	if (info->attrs[NL80211_ATTR_AP_ISOLATE])
 		params.ap_isolate = !!nla_get_u8(info->attrs[NL80211_ATTR_AP_ISOLATE]);
+	if (info->attrs[NL80211_ATTR_BSS_HT_OPMODE])
+		params.ht_opmode =
+			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_OPMODE]);
 
 	if (!rdev->ops->change_bss)
 		return -EOPNOTSUPP;
-- 
1.7.1

