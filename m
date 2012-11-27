Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33982 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2K0TBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 14:01:51 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC 1/3] nl80211: add spec scan flag
Date: Tue, 27 Nov 2012 20:01:22 +0100
Message-Id: <1354042885-32688-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121127_200154_630455_74F2378F)
In-Reply-To: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag indicates that a spectrum scan is requested, if supported.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |    5 +++++
 net/wireless/nl80211.c       |    3 +++
 3 files changed, 10 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8a1aec5..ce19e59 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1009,6 +1009,7 @@ struct cfg80211_ssid {
  * @wdev: the wireless device to scan for
  * @aborted: (internal) scan request was notified as aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
+ * @spec_scan: indicates that spectral scan is requested while scanning.
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1027,6 +1028,7 @@ struct cfg80211_scan_request {
 	unsigned long scan_start;
 	bool aborted;
 	bool no_cck;
+	bool spec_scan;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1a9a819..7da847f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1292,6 +1292,9 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
  *
+ * @NL80211_ATTR_TX_SPEC_SCAN: Indicates whether a spectrum scan should be
+ *	performed while scanning. Used with %NL80211_CMD_TRIGGER_SCAN command.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1555,6 +1558,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCAN_FLAGS,
 
+	NL80211_ATTR_TX_SPEC_SCAN,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4c427fa..2524509 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -337,6 +337,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_ROAM_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_SCHED_SCAN_MATCH] = { .type = NLA_NESTED },
 	[NL80211_ATTR_TX_NO_CCK_RATE] = { .type = NLA_FLAG },
+	[NL80211_ATTR_TX_SPEC_SCAN] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TDLS_ACTION] = { .type = NLA_U8 },
 	[NL80211_ATTR_TDLS_DIALOG_TOKEN] = { .type = NLA_U8 },
 	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
@@ -4396,6 +4397,8 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
+	request->spec_scan =
+		nla_get_flag(info->attrs[NL80211_ATTR_TX_SPEC_SCAN]);
 
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
-- 
1.7.10.4

