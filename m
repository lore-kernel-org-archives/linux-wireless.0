Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:60251
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZA1XMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 18:12:46 -0500
Received: from [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7] (unknown [IPv6:2001:4978:142:0:290:f5ff:fe3e:e3c7])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by s0be.servebeer.com (Postfix) with ESMTPSA id 03EC3252323
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 18:12:44 -0500 (EST)
Message-ID: <4980E66C.9090003@erley.org> (sfid-20090129_001254_076374_5E3B5DBB)
Date: Wed, 28 Jan 2009 18:12:44 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] crda: rename nl_handle to nl_sock for libnl-2.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upstream has renamed nl_handle to nl_sock.  Update iw to the new names
and add #define for libnl-1.1.

Signed-off-by: Pat Erley <pat-lkml@erley.org>
---

In the future, should I keep pushing these sorts of patches, or should
we back them out and wait for a 'release' of libnl-2.0 and push them all
in then?

diff --git a/crda.c b/crda.c
index afc5df1..f2c471f 100644
--- a/crda.c
+++ b/crda.c
@@ -43,10 +43,11 @@ static inline int __genl_ctrl_alloc_cache(struct
nl_handle *h, struct nl_cache *
 }

 #define genl_ctrl_alloc_cache __genl_ctrl_alloc_cache
+#define nl_sock nl_handle
 #endif /* CONFIG_LIBNL20 */

 struct nl80211_state {
-	struct nl_handle *nl_handle;
+	struct nl_sock *nl_sock;
 	struct nl_cache *nl_cache;
 	struct genl_family *nl80211;
 };
@@ -55,22 +56,22 @@ static int nl80211_init(struct nl80211_state *state)
 {
 	int err;

-	state->nl_handle = nl_socket_alloc();
-	if (!state->nl_handle) {
-		fprintf(stderr, "Failed to allocate netlink handle.\n");
+	state->nl_sock = nl_socket_alloc();
+	if (!state->nl_sock) {
+		fprintf(stderr, "Failed to allocate netlink sock.\n");
 		return -ENOMEM;
 	}

-	if (genl_connect(state->nl_handle)) {
+	if (genl_connect(state->nl_sock)) {
 		fprintf(stderr, "Failed to connect to generic netlink.\n");
 		err = -ENOLINK;
-		goto out_handle_destroy;
+		goto out_sock_destroy;
 	}

-	if (genl_ctrl_alloc_cache(state->nl_handle, &state->nl_cache)) {
+	if (genl_ctrl_alloc_cache(state->nl_sock, &state->nl_cache)) {
 		fprintf(stderr, "Failed to allocate generic netlink cache.\n");
 		err = -ENOMEM;
-		goto out_handle_destroy;
+		goto out_sock_destroy;
 	}

 	state->nl80211 = genl_ctrl_search_by_name(state->nl_cache, "nl80211");
@@ -84,8 +85,8 @@ static int nl80211_init(struct nl80211_state *state)

  out_cache_free:
 	nl_cache_free(state->nl_cache);
- out_handle_destroy:
-	nl_socket_free(state->nl_handle);
+ out_sock_destroy:
+	nl_socket_free(state->nl_sock);
 	return err;
 }

@@ -93,7 +94,7 @@ static void nl80211_cleanup(struct nl80211_state *state)
 {
 	genl_family_put(state->nl80211);
 	nl_cache_free(state->nl_cache);
-	nl_socket_free(state->nl_handle);
+	nl_socket_free(state->nl_sock);
 }

 static int reg_handler(struct nl_msg __attribute__((unused)) *msg,
@@ -294,7 +295,7 @@ int main(int argc, char **argv)
 	if (!cb)
 		goto cb_out;

-	r = nl_send_auto_complete(nlstate.nl_handle, msg);
+	r = nl_send_auto_complete(nlstate.nl_sock, msg);

 	if (r < 0) {
 		fprintf(stderr, "Failed to send regulatory request: %d\n", r);
@@ -306,7 +307,7 @@ int main(int argc, char **argv)
 	nl_cb_err(cb, NL_CB_CUSTOM, error_handler, NULL);

 	if (!finished) {
-		r = nl_wait_for_ack(nlstate.nl_handle);
+		r = nl_wait_for_ack(nlstate.nl_sock);
 		if (r < 0) {
 			fprintf(stderr, "Failed to set regulatory domain: "
 				"%d\n", r);

