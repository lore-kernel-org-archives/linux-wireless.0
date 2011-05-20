Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556Ab1ETQFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 12:05:10 -0400
Subject: Re: [PATCH] nl80211: add testmode dump support
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1305907554.4640.5.camel@jlt3.sipsolutions.net> (sfid-20110520_180323_624266_2C1AF3B8)
References: <1305907554.4640.5.camel@jlt3.sipsolutions.net>
	 (sfid-20110520_180323_624266_2C1AF3B8)
Content-Type: multipart/mixed; boundary="=-SM4lG3NxNZxmugEjTzId"
Date: Fri, 20 May 2011 09:07:43 -0700
Message-ID: <1305907663.4640.7.camel@jlt3.sipsolutions.net> (sfid-20110520_180515_243863_8DB410AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SM4lG3NxNZxmugEjTzId
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

For testing, I used the attached patch to hwsim, and the attached
hwsim.c file as an iw module (add hwsim.o to iw's Makefile and
recompile).

As the code is nonsensical I don't want to commit it.

johannes

--=-SM4lG3NxNZxmugEjTzId
Content-Disposition: attachment; filename="hwsim-testmode-dump.patch"
Content-Type: text/x-patch; name="hwsim-testmode-dump.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

---
 drivers/net/wireless/mac80211_hwsim.c |   56 ++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/drivers/net/wireless/mac80211_hwsim.c	2011-05-20 09:06:12.000000000 -0700
+++ b/drivers/net/wireless/mac80211_hwsim.c	2011-05-20 09:06:15.000000000 -0700
@@ -882,6 +882,7 @@ enum hwsim_testmode_attr {
 	__HWSIM_TM_ATTR_INVALID	= 0,
 	HWSIM_TM_ATTR_CMD	= 1,
 	HWSIM_TM_ATTR_PS	= 2,
+	HWSIM_TM_ATTR_DUMP	= 3,
 
 	/* keep last */
 	__HWSIM_TM_ATTR_AFTER_LAST,
@@ -891,6 +892,8 @@ enum hwsim_testmode_attr {
 enum hwsim_testmode_cmd {
 	HWSIM_TM_CMD_SET_PS		= 0,
 	HWSIM_TM_CMD_GET_PS		= 1,
+	HWSIM_TM_CMD_DUMP1		= 2,
+	HWSIM_TM_CMD_DUMP2		= 3,
 };
 
 static const struct nla_policy hwsim_testmode_policy[HWSIM_TM_ATTR_MAX + 1] = {
@@ -937,6 +940,58 @@ static int mac80211_hwsim_testmode_cmd(s
 	kfree_skb(skb);
 	return -ENOBUFS;
 }
+
+static int mac80211_hwsim_testmode_dump(struct ieee80211_hw *hw,
+					struct sk_buff *skb,
+					struct netlink_callback *cb,
+					void *data, int len)
+{
+	struct nlattr *tb[HWSIM_TM_ATTR_MAX + 1];
+	int err, idx;
+	u32 cmd;
+
+	if (!data || !len)
+		return -EINVAL;
+
+	/*
+	 * Setup code -- get the type of command we want to do
+	 */
+	if (cb->args[2]) {
+		/* offset by 1 since commands start at 0 */
+		cmd = cb->args[2] - 1;
+	} else {
+		err = nla_parse(tb, HWSIM_TM_ATTR_MAX, data, len,
+				hwsim_testmode_policy);
+		if (err)
+			return err;
+		if (!tb[HWSIM_TM_ATTR_CMD])
+			return -EINVAL;
+		cmd = nla_get_u32(tb[HWSIM_TM_ATTR_CMD]);
+		switch (cmd) {
+		case HWSIM_TM_CMD_DUMP1:
+		case HWSIM_TM_CMD_DUMP2:
+			break;
+		default:
+			return -EINVAL;
+		}
+		/* offset by 1 since commands start at 0 */
+		cb->args[2] = cmd + 1;
+	}
+
+	/* Deal with the command */
+	idx = cb->args[3];
+	if (cmd == HWSIM_TM_CMD_DUMP1 && idx >= 5)
+		return -ENOENT;
+	if (cmd == HWSIM_TM_CMD_DUMP2 && idx >= 10)
+		return -ENOENT;
+	NLA_PUT_U32(skb, HWSIM_TM_ATTR_DUMP, idx * 10);
+	idx++;
+	cb->args[3] = idx;
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
 #endif
 
 static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
@@ -1059,6 +1114,7 @@ static struct ieee80211_ops mac80211_hws
 	.conf_tx = mac80211_hwsim_conf_tx,
 	.get_survey = mac80211_hwsim_get_survey,
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)
+	CFG80211_TESTMODE_DUMP(mac80211_hwsim_testmode_dump)
 	.ampdu_action = mac80211_hwsim_ampdu_action,
 	.sw_scan_start = mac80211_hwsim_sw_scan,
 	.sw_scan_complete = mac80211_hwsim_sw_scan_complete,

--=-SM4lG3NxNZxmugEjTzId
Content-Disposition: attachment; filename="hwsim.c"
Content-Type: text/x-csrc; name="hwsim.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <net/if.h>
#include <errno.h>
#include <string.h>

#include <netlink/genl/genl.h>
#include <netlink/genl/family.h>
#include <netlink/genl/ctrl.h>
#include <netlink/msg.h>
#include <netlink/attr.h>

#include "nl80211.h"
#include "iw.h"

/* These enums need to be kept in sync with the kernel */
enum hwsim_testmode_attr {
	__HWSIM_TM_ATTR_INVALID	= 0,
	HWSIM_TM_ATTR_CMD	= 1,
	HWSIM_TM_ATTR_PS	= 2,
	HWSIM_TM_ATTR_DUMP	= 3,

	/* keep last */
	__HWSIM_TM_ATTR_AFTER_LAST,
	HWSIM_TM_ATTR_MAX	= __HWSIM_TM_ATTR_AFTER_LAST - 1
};

enum hwsim_testmode_cmd {
	HWSIM_TM_CMD_SET_PS		= 0,
	HWSIM_TM_CMD_GET_PS		= 1,
	HWSIM_TM_CMD_DUMP1		= 2,
	HWSIM_TM_CMD_DUMP2		= 3,
};


SECTION(hwsim);

static int print_hwsim_ps_handler(struct nl_msg *msg, void *arg)
{
	struct nlattr *attrs[NL80211_ATTR_MAX + 1];
	struct nlattr *tb[HWSIM_TM_ATTR_MAX + 1];
	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));

	nla_parse(attrs, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
		  genlmsg_attrlen(gnlh, 0), NULL);

	if (!attrs[NL80211_ATTR_TESTDATA])
		return NL_SKIP;

	nla_parse(tb, HWSIM_TM_ATTR_MAX, nla_data(attrs[NL80211_ATTR_TESTDATA]),
		  nla_len(attrs[NL80211_ATTR_TESTDATA]), NULL);

	printf("HWSIM PS: %d\n", nla_get_u32(tb[HWSIM_TM_ATTR_PS]));

	return NL_SKIP;
}

static int handle_hwsim_getps(struct nl80211_state *state, struct nl_cb *cb,
			      struct nl_msg *msg, int argc, char **argv)
{
	struct nlattr *tmdata;

	tmdata = nla_nest_start(msg, NL80211_ATTR_TESTDATA);
	if (!tmdata)
		goto nla_put_failure;

	NLA_PUT_U32(msg, HWSIM_TM_ATTR_CMD, HWSIM_TM_CMD_GET_PS);

	nla_nest_end(msg, tmdata);

	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM,
		  print_hwsim_ps_handler, NULL);
	return 0;
 nla_put_failure:
	return -ENOBUFS;
}
COMMAND(hwsim, getps, "", NL80211_CMD_TESTMODE, 0, CIB_PHY, handle_hwsim_getps, "");

static int handle_hwsim_setps(struct nl80211_state *state, struct nl_cb *cb,
			      struct nl_msg *msg, int argc, char **argv)
{
	struct nlattr *tmdata;
	__u32 ps;
	char *end;

	if (argc != 1)
		return 1;

	ps = strtoul(argv[0], &end, 0);
	if (*end)
		return 1;

	tmdata = nla_nest_start(msg, NL80211_ATTR_TESTDATA);
	if (!tmdata)
		goto nla_put_failure;

	NLA_PUT_U32(msg, HWSIM_TM_ATTR_CMD, HWSIM_TM_CMD_SET_PS);
	NLA_PUT_U32(msg, HWSIM_TM_ATTR_PS, ps);

	nla_nest_end(msg, tmdata);

	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM,
		  print_hwsim_ps_handler, NULL);
	return 0;
 nla_put_failure:
	return -ENOBUFS;
}
COMMAND(hwsim, setps, "<value>", NL80211_CMD_TESTMODE, 0, CIB_PHY, handle_hwsim_setps, "");

static int print_hwsim_dump_handler(struct nl_msg *msg, void *arg)
{
	struct nlattr *attrs[NL80211_ATTR_MAX + 1];
	struct nlattr *tb[HWSIM_TM_ATTR_MAX + 1];
	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));

	nla_parse(attrs, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
		  genlmsg_attrlen(gnlh, 0), NULL);

	if (!attrs[NL80211_ATTR_TESTDATA])
		return NL_SKIP;

	nla_parse(tb, HWSIM_TM_ATTR_MAX, nla_data(attrs[NL80211_ATTR_TESTDATA]),
		  nla_len(attrs[NL80211_ATTR_TESTDATA]), NULL);

	printf("HWSIM dump data: %d\n", nla_get_u32(tb[HWSIM_TM_ATTR_DUMP]));

	return NL_SKIP;
}

static int handle_hwsim_dump1(struct nl80211_state *state, struct nl_cb *cb,
			      struct nl_msg *msg, int argc, char **argv)
{
	struct nlattr *tmdata;

	tmdata = nla_nest_start(msg, NL80211_ATTR_TESTDATA);
	if (!tmdata)
		goto nla_put_failure;

	NLA_PUT_U32(msg, HWSIM_TM_ATTR_CMD, HWSIM_TM_CMD_DUMP1);

	nla_nest_end(msg, tmdata);

	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM,
		  print_hwsim_dump_handler, NULL);
	return 0;
 nla_put_failure:
	return -ENOBUFS;
}
COMMAND(hwsim, dump1, "", NL80211_CMD_TESTMODE, NLM_F_DUMP, CIB_PHY, handle_hwsim_dump1, "");

static int handle_hwsim_dump2(struct nl80211_state *state, struct nl_cb *cb,
			      struct nl_msg *msg, int argc, char **argv)
{
	struct nlattr *tmdata;

	tmdata = nla_nest_start(msg, NL80211_ATTR_TESTDATA);
	if (!tmdata)
		goto nla_put_failure;

	NLA_PUT_U32(msg, HWSIM_TM_ATTR_CMD, HWSIM_TM_CMD_DUMP2);

	nla_nest_end(msg, tmdata);

	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM,
		  print_hwsim_dump_handler, NULL);
	return 0;
 nla_put_failure:
	return -ENOBUFS;
}
COMMAND(hwsim, dump2, "", NL80211_CMD_TESTMODE, NLM_F_DUMP, CIB_PHY, handle_hwsim_dump2, "");

--=-SM4lG3NxNZxmugEjTzId--

