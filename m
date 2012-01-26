Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:48916 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab2AZPeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 10:34:13 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: rodrigue@qca.qualcomm.com, nbd@openwrt.org, adrian.chadd@gmail.com,
	kgiori@qca.qualcomm.com, shafi.wireless@gmail.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC 2/2] ath9k/dfs_pattern_detector: add standalone testing
Date: Thu, 26 Jan 2012 16:34:04 +0100
Message-Id: <1327592044-3319-3-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120126_163420_540091_5592EAA6)
In-Reply-To: <1327592044-3319-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1327592044-3319-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch proposes a test framework to test the dfs_pattern_detector
in stand-alone mode.

It builds the DFS pattern detector as a module that exports the
interface (dfs_pattern_detector.ko). Another module creates a
detector instance and provides means to forward pulse events from
userspace to the detector (dfs_netlink_relay.ko) via netlink.
As an example, an application that sends a valid radar pattern
to the detector is built (dfs_tester).

See 'Makefile' for further instructions on how to test.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 .../net/wireless/ath/dfs_pattern_detector/Makefile |    7 ++
 .../net/wireless/ath/dfs_pattern_detector/module.c |   20 ++++
 .../ath/dfs_pattern_detector/testing/Makefile      |   44 ++++++++
 .../testing/dfs_netlink_relay.c                    |  115 ++++++++++++++++++++
 .../ath/dfs_pattern_detector/testing/dfs_tester.c  |  101 +++++++++++++++++
 5 files changed, 287 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/Makefile
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/module.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/testing/Makefile
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_netlink_relay.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_tester.c

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/Makefile b/drivers/net/wireless/ath/dfs_pattern_detector/Makefile
new file mode 100644
index 0000000..943866d
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/Makefile
@@ -0,0 +1,7 @@
+# for testing: build stand-alone DFS detector module
+
+dfs_pattern_detector-objs := pulse_queue.o pulse_sequence.o detector_elem.o
+dfs_pattern_detector-objs += pattern_detector.o radar_types.o utils.o
+dfs_pattern_detector-objs += module.o
+
+obj-$(CONFIG_DFS_PATTERN_DETECTOR) += dfs_pattern_detector.o
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/module.c b/drivers/net/wireless/ath/dfs_pattern_detector/module.c
new file mode 100644
index 0000000..07de485
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/module.c
@@ -0,0 +1,20 @@
+#include <linux/module.h>
+#include <linux/init.h>
+
+/**
+ * DOC: module glue for stand-alone DFS pattern detector
+ */
+
+static int __init dfs_init(void)
+{
+	pr_info("DFS pattern detector module loaded.\n");
+	return 0;
+}
+
+static void __exit dfs_exit(void)
+{
+	pr_info("DFS pattern detector module unloaded.\n");
+}
+module_init(dfs_init);
+module_exit(dfs_exit);
+
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/testing/Makefile b/drivers/net/wireless/ath/dfs_pattern_detector/testing/Makefile
new file mode 100644
index 0000000..d37d8b2
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/testing/Makefile
@@ -0,0 +1,44 @@
+# For testing DFS pattern detection stand-alone
+#
+# Generates
+#  * stand-alone DFS pattern detector module
+#  * netlink relay module that instantiates a detector and feeds it
+#    with pulse events sent over netlink, returns detector result
+#  * test application that connects to netlink relay and sends pulses
+#
+# Usage
+#  * make
+#  * sudo insmod ../dfs_pattern_detector.ko
+#  * sudo insmod ./dfs_netlink_relay.ko
+#  * ./dfs_tester
+#
+
+obj-m += dfs_netlink_relay.o
+
+all: dfs_pattern_detector.module dfs_netlink_relay.module dfs_tester.app
+
+clean: dfs_pattern_detector.clean dfs_netlink_relay.clean dfs_tester.clean
+
+
+dfs_tester.app: dfs_tester.c
+	gcc dfs_tester.c -lnl -Wall -o dfs_tester
+
+dfs_tester.clean:
+	rm -f dfs_tester
+
+
+dfs_netlink_relay.module:
+	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
+
+dfs_netlink_relay.clean:
+	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
+
+DPD_BUILD_FLAGS=M=$(shell pwd)/.. CONFIG_DFS_PATTERN_DETECTOR=m EXTRA_CFLAGS=-g
+dfs_pattern_detector.module:
+	make -C /lib/modules/$(shell uname -r)/build $(DPD_BUILD_FLAGS) modules
+	# we need the symbols to load the relay
+	cp ../Module.symvers .
+
+dfs_pattern_detector.clean:
+	make -C /lib/modules/$(shell uname -r)/build $(DPD_BUILD_FLAGS) clean
+
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_netlink_relay.c b/drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_netlink_relay.c
new file mode 100644
index 0000000..fa949ac
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_netlink_relay.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/netlink.h>
+#include <net/netlink.h>
+#include <net/net_namespace.h>
+
+#include "../dfs_pattern_detector.h"
+
+/**
+ * DOC: netlink relay to DFS pattern detector
+ */
+
+static struct dfs_pattern_detector *g_dpd;
+static struct sock *nl_sk;
+
+#define DFS_MSG (0xdf5)
+
+static int send_result(int val, int dst_pid)
+{
+	struct sk_buff *skb = NULL;
+	struct nlmsghdr *nlh = NULL;
+
+	skb = dev_alloc_skb(NLMSG_SPACE(sizeof(val)));
+	if (skb == NULL)
+		return -1;
+	nlh = NLMSG_PUT(skb, dst_pid, 0, DFS_MSG, sizeof(val));
+	memcpy(NLMSG_DATA(nlh), &val, sizeof(val));
+
+	NETLINK_CB(skb).pid = 0;
+	NETLINK_CB(skb).dst_group = 0;
+	pr_info("sending result=%d", val);
+	return netlink_unicast(nl_sk, skb, dst_pid, MSG_DONTWAIT);
+
+nlmsg_failure:
+	kfree_skb(skb);
+	return -EINVAL;
+}
+
+static int nl_data_ready(struct sk_buff *skb, struct nlmsghdr *nlh)
+{
+	struct pulse_event *pe;
+	int detector_result;
+
+	if (nlh == NULL) {
+		pr_err("nlh == NULL\n");
+		return 0;
+	}
+	if (nlh->nlmsg_type != DFS_MSG) {
+		pr_info("dropping non-DFS message\n");
+		return 0;
+	}
+	pe = NLMSG_DATA(nlh);
+	pr_info("DFS pulse event: freq=%d, width=%d, rssi=%d ts=%llu\n",
+			pe->freq, pe->width, pe->rssi, pe->ts);
+
+	detector_result = g_dpd->add_pulse(g_dpd, pe);
+	if (detector_result != 0)
+		pr_info("pulse detected\n");
+
+	send_result(detector_result, nlh->nlmsg_pid);
+	return 0;
+}
+
+DEFINE_MUTEX(my_mutex);
+static void nl_skb_rcv(struct sk_buff *skb)
+{
+	mutex_lock(&my_mutex);
+	netlink_rcv_skb(skb, &nl_data_ready);
+	mutex_unlock(&my_mutex);
+}
+
+static int __init NLdfs_init(void)
+{
+	g_dpd = dfs_pattern_detector_init(DFS_DOMAIN_ETSI);
+	if (g_dpd == NULL)
+		return -1;
+
+	nl_sk = netlink_kernel_create(
+			&init_net, NETLINK_USERSOCK, 0,
+			nl_skb_rcv, NULL, THIS_MODULE);
+	if (nl_sk == NULL) {
+		pr_err("failed to create netlink socket\n");
+		g_dpd->exit(g_dpd);
+		return -1;
+	}
+	pr_info("DFS detector netlink relay loaded.\n");
+	return 0;
+}
+
+static void __exit NLdfs_exit(void)
+{
+	netlink_kernel_release(nl_sk);
+	g_dpd->exit(g_dpd);
+	pr_info("DFS detector netlink relay unloaded.\n");
+}
+
+module_init(NLdfs_init);
+module_exit(NLdfs_exit);
+
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_tester.c b/drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_tester.c
new file mode 100644
index 0000000..22c1a09
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/testing/dfs_tester.c
@@ -0,0 +1,101 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <netlink/netlink.h>
+#include <netlink/msg.h>
+
+#include "../dfs_pattern_detector.h"
+
+#define DFS_MSG (0xdf5)
+static struct nl_sock *nls;
+
+int open_nl(void)
+{
+	nls = nl_socket_alloc();
+	if (!nls) {
+		printf("bad nl_socket_alloc\n");
+		return -1;
+	}
+	int ret = nl_connect(nls, NETLINK_USERSOCK);
+	if (ret < 0) {
+		nl_perror(ret, "nl_connect");
+		nl_socket_free(nls);
+		return -1;
+	}
+	return 0;
+}
+
+int send_pulse_event(struct pulse_event *pe)
+{
+	struct sockaddr_nl peer;
+	unsigned char *msg;
+	struct ucred *creds;
+	int detector_result = 0;
+
+	int ret = nl_send_simple(nls, DFS_MSG, 0, pe, sizeof(*pe));
+	if (ret < 0) {
+		nl_perror(ret, "nl_send_simple");
+		return -1;
+	}
+	if (nl_wait_for_ack(nls) != 0)
+		return -1;
+	int bytes_recv = nl_recv(nls, &peer, &msg, &creds);
+	if (bytes_recv > 0) {
+		struct nlmsghdr *hdr = (struct nlmsghdr *)msg;
+		if (nlmsg_len(hdr) == sizeof(int))
+			detector_result = *((int *)nlmsg_data(hdr));
+		free(msg);
+	}
+	return detector_result;
+}
+
+/* throw some ETSI pattern 1 at detector */
+static int pattern0[] = { 1000, 2000, 3000, 4000, 5000, 6000 };
+static int pattern0_pulses = sizeof(pattern0) / sizeof(pattern0[0]);
+
+int main(int argc, char *argv[])
+{
+	struct pulse_event pe;
+	int i;
+	int ret;
+
+	nls = nl_socket_alloc();
+	if (!nls) {
+		printf("bad nl_socket_alloc\n");
+		exit(-1);
+	}
+	ret = nl_connect(nls, NETLINK_USERSOCK);
+	if (ret < 0) {
+		nl_perror(ret, "nl_connect");
+		nl_socket_free(nls);
+		exit(-1);
+	}
+
+	pe.freq = 5500;
+	pe.rssi = 25;
+	pe.width = 1;
+	for (i = 0; i < pattern0_pulses; i++) {
+		pe.ts = pattern0[i];
+		if (send_pulse_event(&pe) == RADAR_DETECTED)
+			printf("***** Radar detected at pulse %d.\n", i);
+	}
+
+	nl_close(nls);
+	nl_socket_free(nls);
+	return 0;
+}
-- 
1.7.4.1

