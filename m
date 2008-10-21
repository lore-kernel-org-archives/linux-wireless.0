Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:50819 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYJUTWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 15:22:31 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2641331wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 12:22:30 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: colin@cozybit.com
Date: Tue, 21 Oct 2008 10:53:31 -0700
Subject: [PATCH] iw: Add commands to get and set o11s mesh networking parameters
Message-ID: <48fe2bf4.060ec00a.0af3.0576@mx.google.com> (sfid-20081021_212236_474865_ED140733)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two new top-level commands: iw dev <devname> get mesh_param <param>, and
iw dev <devname> set mesh_param <param> <value>.
These can be used to configure the 802.11s mesh networking stack.
These use the new %NL80211_CMD_GET_MESH_PARAMS and
%NL80211_CMD_SET_MESH_PARAMS netlink commands.

We check the user input to make sure that the values given fall in the valid
range for each parameter.
Signed-off-by: Colin McCabe <colin@cozybit.com>
---
 Makefile  |    2 +-
 mesh.c    |  297 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 nl80211.h |   86 ++++++++++++++++++
 3 files changed, 384 insertions(+), 1 deletions(-)
 create mode 100644 mesh.c

diff --git a/Makefile b/Makefile
index 18e89ae..6a9010e 100644
--- a/Makefile
+++ b/Makefile
@@ -11,7 +11,7 @@ CFLAGS += -O2 -g
 LDFLAGS += `pkg-config --libs libnl-1`
 NLVERSION = 1.0
 
-OBJS = iw.o info.o phy.o interface.o station.o util.o mpath.o reg.o
+OBJS = iw.o info.o phy.o interface.o station.o util.o mpath.o reg.o mesh.o
 ALL = iw
 
 ifeq ($(V),1)
diff --git a/mesh.c b/mesh.c
new file mode 100644
index 0000000..741a662
--- /dev/null
+++ b/mesh.c
@@ -0,0 +1,297 @@
+#include <net/if.h>
+#include <errno.h>
+#include <string.h>
+
+#include <netlink/genl/genl.h>
+#include <netlink/genl/family.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+
+#include "nl80211.h"
+#include "iw.h"
+
+typedef struct _any_t {
+	union {
+		uint32_t as_32;
+		uint16_t as_16;
+		uint8_t as_8;
+	} u;
+} _any;
+
+/* describes a mesh parameter */
+struct mesh_param_descr {
+	const char *name;
+	enum nl80211_meshconf_params mesh_param_num;
+	int (*nla_put_fn)(struct nl_msg*, int, _any*);
+	uint32_t (*parse_fn)(const char*, _any*);
+	void (*nla_print_fn)(struct nlattr *);
+};
+
+/* utility functions for manipulating and printing u8/u16/u32 values and
+ * timesouts. */
+static int _my_nla_put_u8(struct nl_msg *n, int mesh_param_num, _any *value)
+{
+	return nla_put(n, mesh_param_num, sizeof(uint8_t), &value->u.as_8);
+}
+
+static int _my_nla_put_u16(struct nl_msg *n, int mesh_param_num, _any *value)
+{
+	return nla_put(n, mesh_param_num, sizeof(uint16_t), &value->u.as_16);
+}
+
+static int _my_nla_put_u32(struct nl_msg *n, int mesh_param_num, _any *value)
+{
+	return nla_put(n, mesh_param_num, sizeof(uint32_t), &value->u.as_32);
+}
+
+static uint32_t _parse_u8(const char *str, _any *ret)
+{
+	char *endptr = NULL;
+	unsigned long int v = strtoul(str, &endptr, 10);
+	if (*endptr != '\0')
+		return 0xff;
+	if (v > 0xff)
+		return 0xff;
+	ret->u.as_8 = (uint8_t)v;
+	return 0;
+}
+
+static uint32_t _parse_u8_as_bool(const char *str, _any *ret)
+{
+	char *endptr = NULL;
+	unsigned long int v = strtoul(str, &endptr, 10);
+	if (*endptr != '\0')
+		return 0x1;
+	if (v > 0x1)
+		return 0x1;
+	ret->u.as_8 = (uint8_t)v;
+	return 0;
+}
+
+static uint32_t _parse_u16(const char *str, _any *ret)
+{
+	char *endptr = NULL;
+	long int v = strtol(str, &endptr, 10);
+	if (*endptr != '\0')
+		return 0xffff;
+	if ((v < 0) || (v > 0xffff))
+		return 0xffff;
+	ret->u.as_16 = (uint16_t)v;
+	return 0;
+}
+
+static uint32_t _parse_u32(const char *str, _any *ret)
+{
+	char *endptr = NULL;
+	long long int v = strtoll(str, &endptr, 10);
+	if (*endptr != '\0')
+		return 0xffffffff;
+	if ((v < 0) || (v > 0xffffffff))
+		return 0xffffffff;
+	ret->u.as_32 = (uint32_t)v;
+	return 0;
+}
+
+void _print_u8(struct nlattr *a)
+{
+	printf("%d", nla_get_u8(a));
+}
+
+void _print_u16(struct nlattr *a)
+{
+	printf("%d", nla_get_u16(a));
+}
+
+void _print_u16_timeout(struct nlattr *a)
+{
+	printf("%d milliseconds", nla_get_u16(a));
+}
+
+void _print_u16_in_TUs(struct nlattr *a)
+{
+	printf("%d TUs", nla_get_u16(a));
+}
+
+void _print_u32_timeout(struct nlattr *a)
+{
+	printf("%u milliseconds", nla_get_u32(a));
+}
+
+void _print_u32_in_TUs(struct nlattr *a)
+{
+	printf("%d TUs", nla_get_u32(a));
+}
+
+/* The current mesh parameters */
+const static struct mesh_param_descr _mesh_param_descrs[] =
+{
+	{"mesh_retry_timeout",
+	NL80211_MESHCONF_RETRY_TIMEOUT,
+	_my_nla_put_u16, _parse_u16, _print_u16_timeout},
+	{"mesh_confirm_timeout",
+	NL80211_MESHCONF_CONFIRM_TIMEOUT,
+	_my_nla_put_u16, _parse_u16, _print_u16_timeout},
+	{"mesh_holding_timeout",
+	NL80211_MESHCONF_HOLDING_TIMEOUT,
+	_my_nla_put_u16, _parse_u16, _print_u16_timeout},
+	{"mesh_max_peer_links",
+	NL80211_MESHCONF_MAX_PEER_LINKS,
+	_my_nla_put_u16, _parse_u16, _print_u16},
+	{"mesh_max_retries",
+	NL80211_MESHCONF_MAX_RETRIES,
+	_my_nla_put_u8, _parse_u8, _print_u8},
+	{"mesh_ttl",
+	NL80211_MESHCONF_TTL,
+	_my_nla_put_u8, _parse_u8, _print_u8},
+	{"mesh_auto_open_plinks",
+	NL80211_MESHCONF_AUTO_OPEN_PLINKS,
+	_my_nla_put_u8, _parse_u8_as_bool, _print_u8},
+	{"mesh_hwmp_max_preq_retries",
+	NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
+	_my_nla_put_u8, _parse_u8, _print_u8},
+	{"mesh_path_refresh_time",
+	NL80211_MESHCONF_PATH_REFRESH_TIME,
+	_my_nla_put_u32, _parse_u32, _print_u32_timeout},
+	{"mesh_min_discovery_timeout",
+	NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
+	_my_nla_put_u16, _parse_u16, _print_u16_timeout},
+	{"mesh_hwmp_active_path_timeout",
+	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
+	_my_nla_put_u32, _parse_u32, _print_u32_in_TUs},
+	{"mesh_hwmp_preq_min_interval",
+	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
+	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+	{"mesh_hwmp_net_diameter_traversal_time",
+	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+};
+
+static void print_all_mesh_param_descr(void)
+{
+	int i;
+	const char *comma = "";
+
+	for (i = 0;
+	     i < sizeof(_mesh_param_descrs)/sizeof(_mesh_param_descrs[0]);
+	     ++i) {
+		printf("%s%s", comma, _mesh_param_descrs[i].name);
+		comma = ", ";
+	}
+}
+
+static const struct mesh_param_descr* find_mesh_param(int argc, char **argv,
+						const char *action_name)
+{
+	int i;
+	const struct mesh_param_descr *mdescr;
+
+	if (argc < 1) {
+		printf("You must specify which mesh parameter to %s.\n",
+		       action_name);
+		return NULL;
+	}
+
+	/* Find out what mesh parameter we want to change. */
+	mdescr = NULL;
+	for (i = 0;
+	     i < sizeof(_mesh_param_descrs)/sizeof(_mesh_param_descrs[0]);
+	     ++i) {
+		if (!strcmp(_mesh_param_descrs[i].name, argv[0]))
+			return _mesh_param_descrs + i;
+	}
+
+	if (!mdescr) {
+		printf("Mesh_param must be one of: ");
+		print_all_mesh_param_descr();
+		printf("\n");
+		return NULL;
+	}
+	return mdescr;
+}
+
+/* Setter */
+static int set_interface_meshparam(struct nl_cb *cb,
+				struct nl_msg *msg,
+				int argc, char **argv)
+{
+	int err;
+	uint32_t ret;
+	const struct mesh_param_descr *mdescr;
+	_any any;
+
+	mdescr = find_mesh_param(argc, argv, "change");
+	if (!mdescr)
+		return 2;
+	if (argc != 2) {
+		printf("Must specify a value for %s.\n", mdescr->name);
+		return 2;
+	}
+
+	/* Parse the new value */
+	memset(&any, 0, sizeof(_any));
+	ret = mdescr->parse_fn(argv[1], &any);
+	if (ret != 0) {
+		printf("%s must be set to a number "
+		       "between 0 and %u\n", mdescr->name, ret);
+		return 2;
+	}
+
+	/* Construct a netlink message */
+	struct nlattr *container =
+		nla_nest_start(msg, NL80211_ATTR_MESH_PARAMS);
+	if (!container)
+		return -ENOBUFS;
+	err = mdescr->nla_put_fn(msg, mdescr->mesh_param_num, &any);
+	nla_nest_end(msg, container);
+
+	return err;
+}
+
+COMMAND(set, mesh_param, "<param> <value>",
+	NL80211_CMD_SET_MESH_PARAMS, 0, CIB_NETDEV, set_interface_meshparam);
+
+/* Getter */
+static int print_mesh_param_handler(struct nl_msg *msg, void *arg)
+{
+	const struct mesh_param_descr *mdescr = arg;
+	struct nlattr *attrs[NL80211_ATTR_MAX + 1];
+	struct nlattr *parent_attr;
+	struct nlattr *mesh_params[NL80211_MESHCONF_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+
+	/* locate NL80211_ATTR_MESH_PARAMS */
+	nla_parse(attrs, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+	parent_attr = attrs[NL80211_ATTR_MESH_PARAMS];
+	if (!parent_attr)
+		return -EINVAL;
+
+	/* unpack the mesh parameters */
+	if (nla_parse_nested(mesh_params, NL80211_MESHCONF_ATTR_MAX,
+				parent_attr, NULL))
+		return -EINVAL;
+
+	/* print out the mesh parameter */
+	mdescr->nla_print_fn(mesh_params[mdescr->mesh_param_num]);
+	printf("\n");
+	return NL_SKIP;
+}
+
+static int get_interface_meshparam(struct nl_cb *cb,
+				struct nl_msg *msg,
+				int argc, char **argv)
+{
+	const struct mesh_param_descr *mdescr;
+
+	mdescr = find_mesh_param(argc, argv, "get");
+	if (!mdescr)
+		return 2;
+
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM,
+		  print_mesh_param_handler, (void *)mdescr);
+	return 0;
+}
+
+COMMAND(get, mesh_param, "<param>",
+	NL80211_CMD_GET_MESH_PARAMS, 0, CIB_NETDEV, get_interface_meshparam);
diff --git a/nl80211.h b/nl80211.h
index 9bad654..40d7b27 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -106,6 +106,12 @@
  * 	to the the specified ISO/IEC 3166-1 alpha2 country code. The core will
  * 	store this as a valid request and then query userspace for it.
  *
+ * @NL80211_CMD_GET_MESH_PARAMS: Get mesh networking properties for the
+ *	interface identified by %NL80211_ATTR_IFINDEX
+ *
+ * @NL80211_CMD_SET_MESH_PARAMS: Set mesh networking properties for the
+ *      interface identified by %NL80211_ATTR_IFINDEX
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -148,6 +154,9 @@ enum nl80211_commands {
 	NL80211_CMD_SET_REG,
 	NL80211_CMD_REQ_SET_REG,
 
+	NL80211_CMD_GET_MESH_PARAMS,
+	NL80211_CMD_SET_MESH_PARAMS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -296,6 +305,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_REG_ALPHA2,
 	NL80211_ATTR_REG_RULES,
 
+	NL80211_ATTR_MESH_PARAMS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -594,4 +605,79 @@ enum nl80211_mntr_flags {
 	NL80211_MNTR_FLAG_MAX = __NL80211_MNTR_FLAG_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_meshconf_params - mesh configuration parameters
+ *
+ * Mesh configuration parameters
+ *
+ * @__NL80211_MESHCONF_INVALID: internal use
+ *
+ * @NL80211_MESHCONF_RETRY_TIMEOUT: specifies the initial retry timeout in
+ * millisecond units, used by the Peer Link Open message
+ *
+ * @NL80211_MESHCONF_CONFIRM_TIMEOUT: specifies the inital confirm timeout, in
+ * millisecond units, used by the peer link management to close a peer link
+ *
+ * @NL80211_MESHCONF_HOLDING_TIMEOUT: specifies the holding timeout, in
+ * millisecond units
+ *
+ * @NL80211_MESHCONF_MAX_PEER_LINKS: maximum number of peer links allowed
+ * on this mesh interface
+ *
+ * @NL80211_MESHCONF_MAX_RETRIES: specifies the maximum number of peer link
+ * open retries that can be sent to establish a new peer link instance in a
+ * mesh
+ *
+ * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
+ * point.
+ *
+ * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
+ * open peer links when we detect compatible mesh peers.
+ *
+ * @NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES: the number of action frames
+ * containing a PREQ that an MP can send to a particular destination (path
+ * target)
+ *
+ * @NL80211_MESHCONF_PATH_REFRESH_TIME: how frequently to refresh mesh paths
+ * (in milliseconds)
+ *
+ * @NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT: minimum length of time to wait
+ * until giving up on a path discovery (in milliseconds)
+ *
+ * @NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT: The time (in TUs) for which mesh
+ * points receiving a PREQ shall consider the forwarding information from the
+ * root to be valid. (TU = time unit)
+ *
+ * @NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL: The minimum interval of time (in
+ * TUs) during which an MP can send only one action frame containing a PREQ
+ * reference element
+ *
+ * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
+ * that it takes for an HWMP information element to propagate across the mesh
+ *
+ * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
+ *
+ * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_meshconf_params {
+	__NL80211_MESHCONF_INVALID,
+	NL80211_MESHCONF_RETRY_TIMEOUT,
+	NL80211_MESHCONF_CONFIRM_TIMEOUT,
+	NL80211_MESHCONF_HOLDING_TIMEOUT,
+	NL80211_MESHCONF_MAX_PEER_LINKS,
+	NL80211_MESHCONF_MAX_RETRIES,
+	NL80211_MESHCONF_TTL,
+	NL80211_MESHCONF_AUTO_OPEN_PLINKS,
+	NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
+	NL80211_MESHCONF_PATH_REFRESH_TIME,
+	NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
+	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
+	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
+	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+
+	/* keep last */
+	__NL80211_MESHCONF_ATTR_AFTER_LAST,
+	NL80211_MESHCONF_ATTR_MAX = __NL80211_MESHCONF_ATTR_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
-- 
1.5.4.3



