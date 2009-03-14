Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZCNIeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 04:34:06 -0400
Subject: [PATCH] nl80211: export supported commands
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 09:34:01 +0100
Message-Id: <1237019641.5235.63.camel@johannes.local> (sfid-20090314_093412_071498_1FE60D96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes nl80211 export the supported commands (command groups)
per wiphy so userspace has an idea what it can do -- this will be
required reading for userspace when we introduce auth/assoc /or/
connect for older hardware that cannot separate auth and assoc.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h |    6 ++++++
 net/wireless/nl80211.c  |   27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

--- wireless-testing.orig/include/linux/nl80211.h	2009-03-11 14:43:50.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2009-03-11 19:27:53.000000000 +0100
@@ -349,6 +349,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_REG_TYPE: indicates the type of the regulatory domain currently
  * 	set. This can be one of the nl80211_reg_type (%NL80211_REGDOM_TYPE_*)
  *
+ * @NL80211_ATTR_SUPPORTED_COMMANDS: wiphy attribute that specifies
+ *	an array of command numbers (i.e. a mapping index to command number)
+ *	that the driver for the given wiphy supports.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -426,6 +430,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_REG_INITIATOR,
 	NL80211_ATTR_REG_TYPE,
 
+	NL80211_ATTR_SUPPORTED_COMMANDS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/net/wireless/nl80211.c	2009-03-11 14:43:50.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-03-11 19:27:53.000000000 +0100
@@ -131,6 +131,7 @@ static int nl80211_send_wiphy(struct sk_
 	struct nlattr *nl_freqs, *nl_freq;
 	struct nlattr *nl_rates, *nl_rate;
 	struct nlattr *nl_modes;
+	struct nlattr *nl_cmds;
 	enum ieee80211_band band;
 	struct ieee80211_channel *chan;
 	struct ieee80211_rate *rate;
@@ -242,6 +243,32 @@ static int nl80211_send_wiphy(struct sk_
 	}
 	nla_nest_end(msg, nl_bands);
 
+	nl_cmds = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_COMMANDS);
+	if (!nl_cmds)
+		goto nla_put_failure;
+
+	i = 0;
+#define CMD(op, n)						\
+	 do {							\
+		if (dev->ops->op) {				\
+			i++;					\
+			NLA_PUT_U32(msg, i, NL80211_CMD_ ## n);	\
+		}						\
+	} while (0)
+
+	CMD(add_virtual_intf, NEW_INTERFACE);
+	CMD(change_virtual_intf, SET_INTERFACE);
+	CMD(add_key, NEW_KEY);
+	CMD(add_beacon, NEW_BEACON);
+	CMD(add_station, NEW_STATION);
+	CMD(add_mpath, NEW_MPATH);
+	CMD(set_mesh_params, SET_MESH_PARAMS);
+	CMD(change_bss, SET_BSS);
+	CMD(set_mgmt_extra_ie, SET_MGMT_EXTRA_IE);
+
+#undef CMD
+	nla_nest_end(msg, nl_cmds);
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:


