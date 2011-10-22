Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46128 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab1JVNNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 09:13:44 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so4522662eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 06:13:44 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] nl80211: Pass probe response data to drivers
Date: Sat, 22 Oct 2011 15:11:51 +0200
Message-Id: <1319289112-21896-3-git-send-email-guy@wizery.com> (sfid-20111022_151349_173417_D0A42AEF)
In-Reply-To: <1319289112-21896-1-git-send-email-guy@wizery.com>
References: <1319289112-21896-1-git-send-email-guy@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow usermode to pass probe-response data. This data can be used as a
template probe-response offloading.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 include/linux/nl80211.h |    4 ++++
 include/net/cfg80211.h  |    4 ++++
 net/wireless/nl80211.c  |   11 +++++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a436f74..6369631 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1114,6 +1114,8 @@ enum nl80211_commands {
  *	In addition this attribute holds a bitmap of the supported protocols
  *	for offloading using &enum nl80211_probe_resp_offload_support_attr.
  *
+ * @NL80211_ATTR_PROBE_RESP: Probe Response template data
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1344,6 +1346,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT,
 
+	NL80211_ATTR_PROBE_RESP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b5ddd62..eb8b8c5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -737,6 +737,8 @@ struct mpath_info {
  * @ap_isolate: do not forward packets between connected stations
  * @ht_opmode: HT Operation mode
  * 	(u16 = opmode, -1 = do not change)
+ * @probe_resp_len: length of probe response template (@probe_resp)
+ * @probe_resp: probe response template (AP mode only)
  */
 struct bss_parameters {
 	int use_cts_prot;
@@ -746,6 +748,8 @@ struct bss_parameters {
 	u8 basic_rates_len;
 	int ap_isolate;
 	int ht_opmode;
+	int probe_resp_len;
+	u8 *probe_resp;
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ad90ec4..aadca02 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -197,6 +197,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
 	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_PROBE_RESP] = { .type = NLA_BINARY,
+				      .len = IEEE80211_MAX_DATA_LEN },
 };
 
 /* policy for the key attributes */
@@ -2978,6 +2980,15 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_BSS_HT_OPMODE])
 		params.ht_opmode =
 			nla_get_u16(info->attrs[NL80211_ATTR_BSS_HT_OPMODE]);
+	if (info->attrs[NL80211_ATTR_PROBE_RESP]) {
+		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP)
+			return -EOPNOTSUPP;
+
+		params.probe_resp =
+			nla_data(info->attrs[NL80211_ATTR_PROBE_RESP]);
+		params.probe_resp_len =
+			nla_len(info->attrs[NL80211_ATTR_PROBE_RESP]);
+	}
 
 	if (!rdev->ops->change_bss)
 		return -EOPNOTSUPP;
-- 
1.7.4.1

