Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55420 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbdDMNwD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 09:52:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 1/3] bpf/wireless: add wifimon program type
Date: Thu, 13 Apr 2017 15:51:53 +0200
Message-Id: <20170413135155.27265-1-johannes@sipsolutions.net> (sfid-20170413_155229_677667_64E406D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add a new program type for wifi monitor interfaces. This program
type can
 * access __sk_buff, but only skb->len
 * call bpf_skb_load_bytes()

The program type is only enabled when something selects the new
Kconfig symbol WANT_BPF_WIFIMON, which will be done by mac80211
in a follow-up patch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/bpf_types.h |  3 +++
 include/uapi/linux/bpf.h  |  1 +
 net/core/filter.c         | 41 +++++++++++++++++++++++++++++++++++++++++
 net/wireless/Kconfig      |  8 ++++++++
 4 files changed, 53 insertions(+)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 03bf223f18be..fcaba84128dd 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -16,6 +16,9 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_KPROBE, kprobe_prog_ops)
 BPF_PROG_TYPE(BPF_PROG_TYPE_TRACEPOINT, tracepoint_prog_ops)
 BPF_PROG_TYPE(BPF_PROG_TYPE_PERF_EVENT, perf_event_prog_ops)
 #endif
+#ifdef CONFIG_BPF_WIFIMON
+BPF_PROG_TYPE(BPF_PROG_TYPE_WIFIMON, wifimon_prog_ops)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1e062bb54eec..b0dfe8a79b3f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -115,6 +115,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LWT_IN,
 	BPF_PROG_TYPE_LWT_OUT,
 	BPF_PROG_TYPE_LWT_XMIT,
+	BPF_PROG_TYPE_WIFIMON,
 };
 
 enum bpf_attach_type {
diff --git a/net/core/filter.c b/net/core/filter.c
index ce2a19da8aa4..c20624c81f6b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3415,3 +3415,44 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
 	release_sock(sk);
 	return ret;
 }
+
+#ifdef CONFIG_BPF_WIFIMON
+static const struct bpf_func_proto *
+wifimon_func_proto(enum bpf_func_id func_id)
+{
+	switch (func_id) {
+	case BPF_FUNC_skb_load_bytes:
+		return &bpf_skb_load_bytes_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
+}
+
+static bool wifimon_is_valid_access(int off, int size,
+				    enum bpf_access_type type,
+				    enum bpf_reg_type *reg_type)
+{
+	if (type == BPF_WRITE)
+		return false;
+
+	switch (off) {
+	case offsetof(struct __sk_buff, len):
+		break;
+	default:
+		return false;
+	}
+	/* The verifier guarantees that size > 0. */
+	if (off % size != 0)
+		return false;
+	if (size != sizeof(__u32))
+		return false;
+
+	return true;
+}
+
+const struct bpf_verifier_ops wifimon_prog_ops = {
+	.get_func_proto		= wifimon_func_proto,
+	.is_valid_access	= wifimon_is_valid_access,
+	.convert_ctx_access	= bpf_convert_ctx_access,
+};
+#endif
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 6c606120abfe..50ffebafce46 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -214,3 +214,11 @@ config LIB80211_DEBUG
 	  from lib80211.
 
 	  If unsure, say N.
+
+config WANT_BPF_WIFIMON
+	bool
+
+config BPF_WIFIMON
+	bool
+	default y
+	depends on WANT_BPF_WIFIMON && BPF_SYSCALL
-- 
2.11.0
