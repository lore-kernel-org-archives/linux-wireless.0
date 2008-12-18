Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-147-71.gdrpmi.dsl-w.verizon.net ([71.115.147.71]:35935
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYLRXvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 18:51:46 -0500
Message-ID: <494AE20D.2010709@erley.org> (sfid-20081219_005151_648805_11D62814)
Date: Thu, 18 Dec 2008 18:51:41 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [patch] Allow CRDA to use new libnl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates CRDA to use the new libnl-2 interface, and adds
backwards compatability with libnl-1.  It follows the same pattern that
the patch included into iw uses.

Signed-off-by: Pat Erley <pat-lkml@erley.org>
---
diff --git a/Makefile b/Makefile
index ab1de94..f0d3925 100644
--- a/Makefile
+++ b/Makefile
@@ -25,6 +25,22 @@ endif
 MKDIR ?= mkdir -p
 INSTALL ?= install

+NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
+NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
+
+ifeq ($(NL1FOUND),Y)
+NLLIBNAME = libnl-1
+endif
+
+ifeq ($(NL2FOUND),Y)
+CFLAGS += -DCONFIG_LIBNL20
+LIBS += -lnl-genl
+NLLIBNAME = libnl-2.0
+endif
+
+LIBS += `pkg-config --libs $(NLLIBNAME)`
+CFLAGS += `pkg-config --cflags $(NLLIBNAME)`
+
 ifeq ($(V),1)
 Q=
 NQ=@true
@@ -43,7 +59,7 @@ keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)

 crda: reglib.o crda.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ `pkg-config --libs libnl-1`
$(LDLIBS)
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(LIBS) -o $@ $^ $(LDLIBS)

 regdbdump: reglib.o regdbdump.o print-regdom.o
 	$(NQ) '  LD  ' $@
diff --git a/crda.c b/crda.c
index 52b8ca1..afc5df1 100644
--- a/crda.c
+++ b/crda.c
@@ -21,6 +21,30 @@
 #include "regdb.h"
 #include "reglib.h"

+#ifndef CONFIG_LIBNL20
+/* libnl 2.0 compatibility code */
+static inline struct nl_handle *nl_socket_alloc(void)
+{
+       return nl_handle_alloc();
+}
+
+static inline void nl_socket_free(struct nl_handle *h)
+{
+       nl_handle_destroy(h);
+}
+
+static inline int __genl_ctrl_alloc_cache(struct nl_handle *h, struct
nl_cache **cache)
+{
+       struct nl_cache *tmp = genl_ctrl_alloc_cache(h);
+       if (!tmp)
+               return -ENOMEM;
+       *cache = tmp;
+       return 0;
+}
+
+#define genl_ctrl_alloc_cache __genl_ctrl_alloc_cache
+#endif /* CONFIG_LIBNL20 */
+
 struct nl80211_state {
 	struct nl_handle *nl_handle;
 	struct nl_cache *nl_cache;
@@ -31,7 +55,7 @@ static int nl80211_init(struct nl80211_state *state)
 {
 	int err;

-	state->nl_handle = nl_handle_alloc();
+	state->nl_handle = nl_socket_alloc();
 	if (!state->nl_handle) {
 		fprintf(stderr, "Failed to allocate netlink handle.\n");
 		return -ENOMEM;
@@ -43,8 +67,7 @@ static int nl80211_init(struct nl80211_state *state)
 		goto out_handle_destroy;
 	}

-	state->nl_cache = genl_ctrl_alloc_cache(state->nl_handle);
-	if (!state->nl_cache) {
+	if (genl_ctrl_alloc_cache(state->nl_handle, &state->nl_cache)) {
 		fprintf(stderr, "Failed to allocate generic netlink cache.\n");
 		err = -ENOMEM;
 		goto out_handle_destroy;
@@ -62,7 +85,7 @@ static int nl80211_init(struct nl80211_state *state)
  out_cache_free:
 	nl_cache_free(state->nl_cache);
  out_handle_destroy:
-	nl_handle_destroy(state->nl_handle);
+	nl_socket_free(state->nl_handle);
 	return err;
 }

@@ -70,7 +93,7 @@ static void nl80211_cleanup(struct nl80211_state *state)
 {
 	genl_family_put(state->nl80211);
 	nl_cache_free(state->nl_cache);
-	nl_handle_destroy(state->nl_handle);
+	nl_socket_free(state->nl_handle);
 }

 static int reg_handler(struct nl_msg __attribute__((unused)) *msg,
