Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59695 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab1KHOfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:35:38 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so395520eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:35:37 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 2/3] nl80211: Pass probe response data to drivers
Date: Tue,  8 Nov 2011 16:35:27 +0200
Message-Id: <1320762928-6782-2-git-send-email-arik@wizery.com> (sfid-20111108_153542_033103_7643452E)
In-Reply-To: <1320762928-6782-1-git-send-email-arik@wizery.com>
References: <1320762928-6782-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass probe-response data from usermode via beacon parameters.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->3:
Set the probe response data as part of the addset_beacon function, instead
of set_bss. This makes more sense since the probe response is always
updated with the beacon.

include/linux/nl80211.h |    4 ++++
 include/net/cfg80211.h  |    4 ++++
 net/wireless/nl80211.c  |    9 +++++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e74afc4..3fa03b3 100644
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
index 7939495..97f3e85 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -391,6 +391,8 @@ struct cfg80211_crypto_settings {
  * @assocresp_ies: extra information element(s) to add into (Re)Association
  *	Response frames or %NULL
  * @assocresp_ies_len: length of assocresp_ies in octets
+ * @probe_resp_len: length of probe response template (@probe_resp)
+ * @probe_resp: probe response template (AP mode only)
  */
 struct beacon_parameters {
 	u8 *head, *tail;
@@ -408,6 +410,8 @@ struct beacon_parameters {
 	size_t proberesp_ies_len;
 	const u8 *assocresp_ies;
 	size_t assocresp_ies_len;
+	int probe_resp_len;
+	u8 *probe_resp;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9800f8d..10d5b1f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -196,6 +196,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
 	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_PROBE_RESP] = { .type = NLA_BINARY,
+				      .len = IEEE80211_MAX_DATA_LEN },
 };
 
 /* policy for the key attributes */
@@ -2160,6 +2162,13 @@ static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
 			nla_len(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]);
 	}
 
+	if (info->attrs[NL80211_ATTR_PROBE_RESP]) {
+		params.probe_resp =
+			nla_data(info->attrs[NL80211_ATTR_PROBE_RESP]);
+		params.probe_resp_len =
+			nla_len(info->attrs[NL80211_ATTR_PROBE_RESP]);
+	}
+
 	err = call(&rdev->wiphy, dev, &params);
 	if (!err && params.interval)
 		wdev->beacon_interval = params.interval;
-- 
1.7.5.4

