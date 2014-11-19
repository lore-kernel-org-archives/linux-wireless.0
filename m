Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39930 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280AbaKSRaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:30:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH] cfg80211: add wowlan net-detect support
Date: Wed, 19 Nov 2014 18:30:00 +0100
Message-Id: <1416418200-5934-1-git-send-email-johannes@sipsolutions.net> (sfid-20141119_183015_307804_7739D178)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add a new WoWLAN API to enable net-detect as a wake up trigger.
Net-detect allows the device to scan in the background while the
host is asleep to wake up the host system when a matching network
is found.

Reuse the scheduled scan attributes to specify how the scan is
performed while suspended and the matches that will trigger a
wake event.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  41 ++++++++++++++++
 include/uapi/linux/nl80211.h |  23 +++++++++
 net/wireless/core.h          |   1 +
 net/wireless/nl80211.c       | 111 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 175 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4f64f3c52bf8..34535508a006 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1940,6 +1940,7 @@ struct cfg80211_wowlan_tcp {
  * @rfkill_release: wake up when rfkill is released
  * @tcp: TCP connection establishment/wakeup parameters, see nl80211.h.
  *	NULL if not configured.
+ * @nd_config: configuration for the scan to be used for net detect wake.
  */
 struct cfg80211_wowlan {
 	bool any, disconnect, magic_pkt, gtk_rekey_failure,
@@ -1948,6 +1949,7 @@ struct cfg80211_wowlan {
 	struct cfg80211_pkt_pattern *patterns;
 	struct cfg80211_wowlan_tcp *tcp;
 	int n_patterns;
+	struct cfg80211_sched_scan_request *nd_config;
 };
 
 /**
@@ -1980,6 +1982,35 @@ struct cfg80211_coalesce {
 };
 
 /**
+ * struct cfg80211_wowlan_nd_match - information about the match
+ *
+ * @ssid: SSID of the match that triggered the wake up
+ * @n_channels: Number of channels where the match occurred.  This
+ *	value may be zero if the driver can't report the channels.
+ * @channels: center frequencies of the channels where a match
+ *	occurred (in MHz)
+ */
+struct cfg80211_wowlan_nd_match {
+	struct cfg80211_ssid ssid;
+	int n_channels;
+	u32 channels[];
+};
+
+/**
+ * struct cfg80211_wowlan_nd_info - net detect wake up information
+ *
+ * @n_matches: Number of match information instances provided in
+ *	@matches.  This value may be zero if the driver can't provide
+ *	match information.
+ * @matches: Array of pointers to matches containing information about
+ *	the matches that triggered the wake up.
+ */
+struct cfg80211_wowlan_nd_info {
+	int n_matches;
+	struct cfg80211_wowlan_nd_match *matches[];
+};
+
+/**
  * struct cfg80211_wowlan_wakeup - wakeup report
  * @disconnect: woke up by getting disconnected
  * @magic_pkt: woke up by receiving magic packet
@@ -1998,6 +2029,7 @@ struct cfg80211_coalesce {
  * @tcp_match: TCP wakeup packet received
  * @tcp_connlost: TCP connection lost or failed to establish
  * @tcp_nomoretokens: TCP data ran out of tokens
+ * @net_detect: if not %NULL, woke up because of net detect
  */
 struct cfg80211_wowlan_wakeup {
 	bool disconnect, magic_pkt, gtk_rekey_failure,
@@ -2007,6 +2039,7 @@ struct cfg80211_wowlan_wakeup {
 	s32 pattern_idx;
 	u32 packet_present_len, packet_len;
 	const void *packet;
+	struct cfg80211_wowlan_nd_info *net_detect;
 };
 
 /**
@@ -2810,6 +2843,7 @@ struct ieee80211_txrx_stypes {
  * @WIPHY_WOWLAN_EAP_IDENTITY_REQ: supports wakeup on EAP identity request
  * @WIPHY_WOWLAN_4WAY_HANDSHAKE: supports wakeup on 4-way handshake failure
  * @WIPHY_WOWLAN_RFKILL_RELEASE: supports wakeup on RF-kill release
+ * @WIPHY_WOWLAN_NET_DETECT: supports wakeup on network detection
  */
 enum wiphy_wowlan_support_flags {
 	WIPHY_WOWLAN_ANY		= BIT(0),
@@ -2820,6 +2854,7 @@ enum wiphy_wowlan_support_flags {
 	WIPHY_WOWLAN_EAP_IDENTITY_REQ	= BIT(5),
 	WIPHY_WOWLAN_4WAY_HANDSHAKE	= BIT(6),
 	WIPHY_WOWLAN_RFKILL_RELEASE	= BIT(7),
+	WIPHY_WOWLAN_NET_DETECT		= BIT(8),
 };
 
 struct wiphy_wowlan_tcp_support {
@@ -2838,6 +2873,11 @@ struct wiphy_wowlan_tcp_support {
  * @pattern_max_len: maximum length of each pattern
  * @pattern_min_len: minimum length of each pattern
  * @max_pkt_offset: maximum Rx packet offset
+ * @max_nd_match_sets: maximum number of matchsets for net-detect,
+ *	similar, but not necessarily identical, to max_match_sets for
+ *	scheduled scans.
+ *	See &struct cfg80211_sched_scan_request.@match_sets for more
+ *	details.
  * @tcp: TCP wakeup support information
  */
 struct wiphy_wowlan_support {
@@ -2846,6 +2886,7 @@ struct wiphy_wowlan_support {
 	int pattern_max_len;
 	int pattern_min_len;
 	int max_pkt_offset;
+	int max_nd_match_sets;
 	const struct wiphy_wowlan_tcp_support *tcp;
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 38756f699f2d..142546ec36d6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1686,6 +1686,7 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_OPER_CLASS: operating class
  *
+ * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -2043,6 +2044,7 @@ enum nl80211_attrs {
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
+	NUM_NL80211_ATTR = __NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
 
@@ -3617,6 +3619,25 @@ struct nl80211_pattern_support {
  * @NL80211_WOWLAN_TRIG_WAKEUP_TCP_NOMORETOKENS: For wakeup reporting only,
  *	the TCP connection ran out of tokens to use for data to send to the
  *	service
+ * @NL80211_WOWLAN_TRIG_NET_DETECT: wake up when a configured network
+ *	is detected.  This is a nested attribute that contains the
+ *	same attributes used with @NL80211_CMD_START_SCHED_SCAN.  It
+ *	specifies how the scan is performed (e.g. the interval and the
+ *	channels to scan) as well as the scan results that will
+ *	trigger a wake (i.e. the matchsets).
+ * @NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS: nested attribute
+ *	containing an array with information about what triggered the
+ *	wake up.  If no elements are present in the array, it means
+ *	that the information is not available.  If more than one
+ *	element is present, it means that more than one match
+ *	occurred.
+ *	Each element in the array is a nested attribute that contains
+ *	one optional %NL80211_ATTR_SSID attribute and one optional
+ *	%NL80211_ATTR_SCAN_FREQUENCIES attribute.  At least one of
+ *	these attributes must be present.  If
+ *	%NL80211_ATTR_SCAN_FREQUENCIES contains more than one
+ *	frequency, it means that the match occurred in more than one
+ *	channel.
  * @NUM_NL80211_WOWLAN_TRIG: number of wake on wireless triggers
  * @MAX_NL80211_WOWLAN_TRIG: highest wowlan trigger attribute number
  *
@@ -3642,6 +3663,8 @@ enum nl80211_wowlan_triggers {
 	NL80211_WOWLAN_TRIG_WAKEUP_TCP_MATCH,
 	NL80211_WOWLAN_TRIG_WAKEUP_TCP_CONNLOST,
 	NL80211_WOWLAN_TRIG_WAKEUP_TCP_NOMORETOKENS,
+	NL80211_WOWLAN_TRIG_NET_DETECT,
+	NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS,
 
 	/* keep last */
 	NUM_NL80211_WOWLAN_TRIG,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 61ee664cf2bd..faa5b1609aae 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -111,6 +111,7 @@ cfg80211_rdev_free_wowlan(struct cfg80211_registered_device *rdev)
 	    rdev->wiphy.wowlan_config->tcp->sock)
 		sock_release(rdev->wiphy.wowlan_config->tcp->sock);
 	kfree(rdev->wiphy.wowlan_config->tcp);
+	kfree(rdev->wiphy.wowlan_config->nd_config);
 	kfree(rdev->wiphy.wowlan_config);
 #endif
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f8c1b30ec048..610ee49fb655 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -209,7 +209,7 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
 }
 
 /* policy for the attributes */
-static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
+static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = 20-1 },
@@ -428,6 +428,7 @@ nl80211_wowlan_policy[NUM_NL80211_WOWLAN_TRIG] = {
 	[NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE] = { .type = NLA_FLAG },
 	[NL80211_WOWLAN_TRIG_RFKILL_RELEASE] = { .type = NLA_FLAG },
 	[NL80211_WOWLAN_TRIG_TCP_CONNECTION] = { .type = NLA_NESTED },
+	[NL80211_WOWLAN_TRIG_NET_DETECT] = { .type = NLA_NESTED },
 };
 
 static const struct nla_policy
@@ -1088,6 +1089,8 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 	if (large && nl80211_send_wowlan_tcp_caps(rdev, msg))
 		return -ENOBUFS;
 
+	/* TODO: send wowlan net detect */
+
 	nla_nest_end(msg, nl_wowlan);
 
 	return 0;
@@ -8695,6 +8698,39 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+static int nl80211_parse_wowlan_nd(struct cfg80211_registered_device *rdev,
+				   const struct wiphy_wowlan_support *wowlan,
+				   struct nlattr *attr,
+				   struct cfg80211_wowlan *trig)
+{
+	struct nlattr **tb;
+	int err;
+
+	tb = kzalloc(NUM_NL80211_ATTR * sizeof(*tb), GFP_KERNEL);
+	if (!tb)
+		return -ENOMEM;
+
+	if (!(wowlan->flags & WIPHY_WOWLAN_NET_DETECT)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = nla_parse(tb, NL80211_ATTR_MAX,
+			nla_data(attr), nla_len(attr),
+			nl80211_policy);
+	if (err)
+		goto out;
+
+	trig->nd_config = nl80211_parse_sched_scan(&rdev->wiphy, tb);
+	err = PTR_ERR_OR_ZERO(trig->nd_config);
+	if (err)
+		trig->nd_config = NULL;
+
+out:
+	kfree(tb);
+	return err;
+}
+
 static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -8840,6 +8876,14 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 			goto error;
 	}
 
+	if (tb[NL80211_WOWLAN_TRIG_NET_DETECT]) {
+		err = nl80211_parse_wowlan_nd(
+			rdev, wowlan, tb[NL80211_WOWLAN_TRIG_NET_DETECT],
+			&new_triggers);
+		if (err)
+			goto error;
+	}
+
 	ntrig = kmemdup(&new_triggers, sizeof(new_triggers), GFP_KERNEL);
 	if (!ntrig) {
 		err = -ENOMEM;
@@ -12082,6 +12126,67 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 EXPORT_SYMBOL(cfg80211_report_obss_beacon);
 
 #ifdef CONFIG_PM
+static int cfg80211_net_detect_results(struct sk_buff *msg,
+				       struct cfg80211_wowlan_wakeup *wakeup)
+{
+	struct cfg80211_wowlan_nd_info *nd = wakeup->net_detect;
+	struct nlattr *nl_results, *nl_match, *nl_freqs;
+	int i, j;
+
+	nl_results = nla_nest_start(
+		msg, NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS);
+	if (!nl_results)
+		return -EMSGSIZE;
+
+	for (i = 0; i < nd->n_matches; i++) {
+		struct cfg80211_wowlan_nd_match *match = nd->matches[i];
+
+		nl_match = nla_nest_start(msg, i);
+		if (!nl_match)
+			break;
+
+		/* The SSID attribute is optional in nl80211, but for
+		 * simplicity reasons it's always present in the
+		 * cfg80211 structure.  If a driver can't pass the
+		 * SSID, that needs to be changed.  A zero length SSID
+		 * is still a valid SSID (wildcard), so it cannot be
+		 * used for this purpose.
+		 */
+		if (nla_put(msg, NL80211_ATTR_SSID, match->ssid.ssid_len,
+			    match->ssid.ssid)) {
+			nla_nest_cancel(msg, nl_match);
+			goto out;
+		}
+
+		if (match->n_channels) {
+			nl_freqs = nla_nest_start(
+				msg, NL80211_ATTR_SCAN_FREQUENCIES);
+			if (!nl_freqs) {
+				nla_nest_cancel(msg, nl_match);
+				goto out;
+			}
+
+			for (j = 0; j < match->n_channels; j++) {
+				if (nla_put_u32(msg,
+						NL80211_ATTR_WIPHY_FREQ,
+						match->channels[j])) {
+					nla_nest_cancel(msg, nl_freqs);
+					nla_nest_cancel(msg, nl_match);
+					goto out;
+				}
+			}
+
+			nla_nest_end(msg, nl_freqs);
+		}
+
+		nla_nest_end(msg, nl_match);
+	}
+
+out:
+	nla_nest_end(msg, nl_results);
+	return 0;
+}
+
 void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 				   struct cfg80211_wowlan_wakeup *wakeup,
 				   gfp_t gfp)
@@ -12176,6 +12281,10 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 				goto free_msg;
 		}
 
+		if (wakeup->net_detect &&
+		    cfg80211_net_detect_results(msg, wakeup))
+				goto free_msg;
+
 		nla_nest_end(msg, reasons);
 	}
 
-- 
2.1.1

