Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:53239 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaANR3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 12:29:50 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so4126074eaj.4
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 09:29:48 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 4/5] nl80211: add DFS CAC time option
Date: Tue, 14 Jan 2014 18:29:29 +0100
Message-Id: <1389720570-2430-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182958_347783_30D048C5)
In-Reply-To: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass DFS CAC time to user mode (mainly
for iw reg get/iw list/iw info).
Allow setting DFS CAC time via CRDA.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/uapi/linux/nl80211.h |    5 +++++
 net/wireless/nl80211.c       |   13 ++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 91054fd..65081e8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2304,6 +2304,7 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
  *	using this channel as the primary or any of the secondary channels
  *	isn't possible
+ * @NL80211_FREQUENCY_ATTR_DFS_CAC_TIME: DFS CAC time in sec
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2322,6 +2323,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_DFS_CAC_TIME,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -2418,6 +2420,7 @@ enum nl80211_reg_type {
  * 	If you don't have one then don't send this.
  * @NL80211_ATTR_POWER_RULE_MAX_EIRP: the maximum allowed EIRP for
  * 	a given frequency range. The value is in mBm (100 * dBm).
+ * @NL80211_ATTR_DFS_CAC_TIME: DFS CAC time in seconds.
  * @NL80211_REG_RULE_ATTR_MAX: highest regulatory rule attribute number
  *	currently defined
  * @__NL80211_REG_RULE_ATTR_AFTER_LAST: internal use
@@ -2433,6 +2436,8 @@ enum nl80211_reg_rule_attr {
 	NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,
 	NL80211_ATTR_POWER_RULE_MAX_EIRP,
 
+	NL80211_ATTR_DFS_CAC_TIME,
+
 	/* keep last */
 	__NL80211_REG_RULE_ATTR_AFTER_LAST,
 	NL80211_REG_RULE_ATTR_MAX = __NL80211_REG_RULE_ATTR_AFTER_LAST - 1
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0afd82..2d2dbe0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -592,6 +592,10 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 			if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_TIME,
 					time))
 				goto nla_put_failure;
+			if (nla_put_u32(msg,
+					NL80211_FREQUENCY_ATTR_DFS_CAC_TIME,
+					chan->dfs_cac_ms/1000))
+				goto nla_put_failure;
 		}
 	}
 
@@ -4617,6 +4621,7 @@ static const struct nla_policy reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] =
 	[NL80211_ATTR_FREQ_RANGE_MAX_BW]	= { .type = NLA_U32 },
 	[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]	= { .type = NLA_U32 },
 	[NL80211_ATTR_POWER_RULE_MAX_EIRP]	= { .type = NLA_U32 },
+	[NL80211_ATTR_DFS_CAC_TIME]		= { .type = NLA_U32 },
 };
 
 static int parse_reg_rule(struct nlattr *tb[],
@@ -4652,6 +4657,10 @@ static int parse_reg_rule(struct nlattr *tb[],
 		power_rule->max_antenna_gain =
 			nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]);
 
+	if (tb[NL80211_ATTR_DFS_CAC_TIME])
+		reg_rule->dfs_cac_time =
+			nla_get_u32(tb[NL80211_ATTR_DFS_CAC_TIME]);
+
 	return 0;
 }
 
@@ -5133,7 +5142,9 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 		    nla_put_u32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,
 				power_rule->max_antenna_gain) ||
 		    nla_put_u32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,
-				power_rule->max_eirp))
+				power_rule->max_eirp) ||
+		    nla_put_u32(msg, NL80211_ATTR_DFS_CAC_TIME,
+				reg_rule->dfs_cac_time))
 			goto nla_put_failure_rcu;
 
 		nla_nest_end(msg, nl_reg_rule);
-- 
1.7.9.5

