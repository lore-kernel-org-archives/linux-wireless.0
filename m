Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:60248
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZA1XLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 18:11:12 -0500
Received: from [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7] (unknown [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by s0be.servebeer.com (Postfix) with ESMTPSA id 12AB6252323
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 18:11:10 -0500 (EST)
Message-ID: <4980E60D.9060505@erley.org> (sfid-20090129_001116_800094_6F18B713)
Date: Wed, 28 Jan 2009 18:11:09 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: rename nl_handle to nl_sock for libnl-2.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upstream has renamed nl_handle to nl_sock.  Update iw to the new names
and add #define for libnl-1.1.

Signed-off-by: Pat Erley <pat-lkml@erley.org>
---

Now with the iw patch instead of the crda patch, haha...

In the future, should I keep pushing these sorts of patches, or should
we back them out and wait for a 'release' of libnl-2.0 and push them all
in then?

diff --git a/genl.c b/genl.c
index e99ea9d..6091b97 100644
--- a/genl.c
+++ b/genl.c
@@ -64,7 +64,7 @@ static int family_handler(struct nl_msg *msg, void *arg)
 	return NL_SKIP;
 }

-int nl_get_multicast_id(struct nl_handle *handle, const char *family,
const char *group)
+int nl_get_multicast_id(struct nl_sock *sock, const char *family, const
char *group)
 {
 	struct nl_msg *msg;
 	struct nl_cb *cb;
@@ -84,7 +84,7 @@ int nl_get_multicast_id(struct nl_handle *handle,
const char *family, const char
 		goto out_fail_cb;
 	}

-	ctrlid = genl_ctrl_resolve(handle, "nlctrl");
+	ctrlid = genl_ctrl_resolve(sock, "nlctrl");

         genlmsg_put(msg, 0, 0, ctrlid, 0,
 		    0, CTRL_CMD_GETFAMILY, 0);
@@ -92,7 +92,7 @@ int nl_get_multicast_id(struct nl_handle *handle,
const char *family, const char
 	ret = -ENOBUFS;
 	NLA_PUT_STRING(msg, CTRL_ATTR_FAMILY_NAME, family);

-	ret = nl_send_auto_complete(handle, msg);
+	ret = nl_send_auto_complete(sock, msg);
 	if (ret < 0)
 		goto out;

@@ -103,7 +103,7 @@ int nl_get_multicast_id(struct nl_handle *handle,
const char *family, const char
 	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, family_handler, &grp);

 	while (ret > 0)
-		nl_recvmsgs(handle, cb);
+		nl_recvmsgs(sock, cb);

 	if (ret == 0)
 		ret = grp.id;
diff --git a/iw.c b/iw.c
index 117399c..f30da43 100644
--- a/iw.c
+++ b/iw.c
@@ -31,12 +31,12 @@ static inline struct nl_handle *nl_socket_alloc(void)
 	return nl_handle_alloc();
 }

-static inline void nl_socket_free(struct nl_handle *h)
+static inline void nl_socket_free(struct nl_sock *h)
 {
 	nl_handle_destroy(h);
 }

-static inline int __genl_ctrl_alloc_cache(struct nl_handle *h, struct
nl_cache **cache)
+static inline int __genl_ctrl_alloc_cache(struct nl_sock *h, struct
nl_cache **cache)
 {
 	struct nl_cache *tmp = genl_ctrl_alloc_cache(h);
 	if (!tmp)
@@ -53,19 +53,19 @@ static int nl80211_init(struct nl80211_state *state)
 {
 	int err;

-	state->nl_handle = nl_socket_alloc();
-	if (!state->nl_handle) {
-		fprintf(stderr, "Failed to allocate netlink handle.\n");
+	state->nl_sock = nl_socket_alloc();
+	if (!state->nl_sock) {
+		fprintf(stderr, "Failed to allocate netlink socket.\n");
 		return -ENOMEM;
 	}

-	if (genl_connect(state->nl_handle)) {
+	if (genl_connect(state->nl_sock)) {
 		fprintf(stderr, "Failed to connect to generic netlink.\n");
 		err = -ENOLINK;
 		goto out_handle_destroy;
 	}

-	if (genl_ctrl_alloc_cache(state->nl_handle, &state->nl_cache)) {
+	if (genl_ctrl_alloc_cache(state->nl_sock, &state->nl_cache)) {
 		fprintf(stderr, "Failed to allocate generic netlink cache.\n");
 		err = -ENOMEM;
 		goto out_handle_destroy;
@@ -83,7 +83,7 @@ static int nl80211_init(struct nl80211_state *state)
  out_cache_free:
 	nl_cache_free(state->nl_cache);
  out_handle_destroy:
-	nl_socket_free(state->nl_handle);
+	nl_socket_free(state->nl_sock);
 	return err;
 }

@@ -91,7 +91,7 @@ static void nl80211_cleanup(struct nl80211_state *state)
 {
 	genl_family_put(state->nl80211);
 	nl_cache_free(state->nl_cache);
-	nl_socket_free(state->nl_handle);
+	nl_socket_free(state->nl_sock);
 }

 __COMMAND(NULL, NULL, NULL, 0, 0, 0, CIB_NONE, NULL);
@@ -271,7 +271,7 @@ static int handle_cmd(struct nl80211_state *state,
 	if (err)
 		goto out;

-	err = nl_send_auto_complete(state->nl_handle, msg);
+	err = nl_send_auto_complete(state->nl_sock, msg);
 	if (err < 0)
 		goto out;

@@ -282,7 +282,7 @@ static int handle_cmd(struct nl80211_state *state,
 	nl_cb_set(cb, NL_CB_ACK, NL_CB_CUSTOM, ack_handler, &err);

 	while (err > 0)
-		nl_recvmsgs(state->nl_handle, cb);
+		nl_recvmsgs(state->nl_sock, cb);
  out:
 	nl_cb_put(cb);
  out_free_msg:
@@ -331,11 +331,11 @@ static int listen_events(struct nl80211_state *state,
 		return -ENOMEM;
 	}

-	mcid = nl_get_multicast_id(state->nl_handle, "nl80211", "config");
+	mcid = nl_get_multicast_id(state->nl_sock, "nl80211", "config");
 	if (mcid < 0)
 		return mcid;

-	ret = nl_socket_add_membership(state->nl_handle, mcid);
+	ret = nl_socket_add_membership(state->nl_sock, mcid);
 	if (ret)
 		return ret;
 	
@@ -344,7 +344,7 @@ static int listen_events(struct nl80211_state *state,
 	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_event, NULL);

 	while (1)
-		nl_recvmsgs(state->nl_handle, cb);
+		nl_recvmsgs(state->nl_sock, cb);

 	nl_cb_put(cb);

diff --git a/iw.h b/iw.h
index 49788e0..7c2ab02 100644
--- a/iw.h
+++ b/iw.h
@@ -10,12 +10,12 @@

 #define ETH_ALEN 6

-struct nl80211_state {
-#ifdef CONFIG_LIBNL20
-	struct nl_sock *nl_handle;
-#else
-	struct nl_handle *nl_handle;
+#ifndef CONFIG_LIBNL20
+#  define nl_sock nl_handle
 #endif
+
+struct nl80211_state {
+	struct nl_sock *nl_sock;
 	struct nl_cache *nl_cache;
 	struct genl_family *nl80211;
 };
@@ -67,6 +67,6 @@ const char *iftype_name(enum nl80211_iftype iftype);
 int ieee80211_channel_to_frequency(int chan);
 int ieee80211_frequency_to_channel(int freq);

-int nl_get_multicast_id(struct nl_handle *handle, const char *family,
const char *group);
+int nl_get_multicast_id(struct nl_sock *sock, const char *family, const
char *group);

 #endif /* __IW_H */

