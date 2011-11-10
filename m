Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44083 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab1KJJ3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 04:29:07 -0500
Received: by wwi18 with SMTP id 18so386206wwi.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2011 01:29:06 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v5 2/3] nl80211: Pass probe response data to drivers
Date: Thu, 10 Nov 2011 11:28:56 +0200
Message-Id: <1320917337-30561-2-git-send-email-arik@wizery.com> (sfid-20111110_102913_312697_1A7FA1E5)
In-Reply-To: <1320917337-30561-1-git-send-email-arik@wizery.com>
References: <1320917337-30561-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass probe-response data from usermode via beacon parameters.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/linux/nl80211.h |    6 ++++++
 include/net/cfg80211.h  |    4 ++++
 net/wireless/nl80211.c  |    9 +++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index be92333..f9261c2 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1166,6 +1166,10 @@ enum nl80211_commands {
  *	This attribute holds a bitmap of the supported protocols for
  *	offloading (see &enum nl80211_probe_resp_offload_support_attr).
  *
+ * @NL80211_ATTR_PROBE_RESP: Probe Response template data. Contains the entire
+ *	probe-response frame. The DA field in the 802.11 header is zero-ed out,
+ *	to be filled by the FW.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1402,6 +1406,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PROBE_RESP_OFFLOAD,
 
+	NL80211_ATTR_PROBE_RESP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 243bf23..13ce855 100644
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
index 0349f48..3ae83cb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -197,6 +197,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
 	[NL80211_ATTR_DONT_WAIT_FOR_ACK] = { .type = NLA_FLAG },
+	[NL80211_ATTR_PROBE_RESP] = { .type = NLA_BINARY,
+				      .len = IEEE80211_MAX_DATA_LEN },
 };
 
 /* policy for the key attributes */
@@ -2171,6 +2173,13 @@ static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
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

