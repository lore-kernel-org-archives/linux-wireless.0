Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-155-244.gdrpmi.dsl-w.verizon.net ([71.115.155.244]:35914
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYLLFFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 00:05:55 -0500
Message-ID: <4941EF69.5040108@erley.org> (sfid-20081212_060605_072932_84AE3C16)
Date: Thu, 11 Dec 2008 23:58:17 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Userspace tools: Roadmap?
References: <1228692546.8826.1288759933@webmail.messagingengine.com>	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>	 <1228778295.10662.1288975589@webmail.messagingengine.com>	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org> <1228780960.22164.162.camel@johannes.berg>
In-Reply-To: <1228780960.22164.162.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Attached is a newer 'better' version based off of how hostapd is
handling this.  This patch adds an option, CONFIG_LIBNL20, which enables
LIBNL20 compatibility.  I haven't ever been able to get iw to build with
libnl-1.0 or libnl-1.1 on my system, so I haven't been able to test
that, but it should work.

Signed-off-by: Pat Erley <pat-lkml@erley.org>

---
diff --git a/Makefile b/Makefile
index df59b51..a10f72f 100644
--- a/Makefile
+++ b/Makefile
@@ -10,14 +10,25 @@ MKDIR ?= mkdir -p
 INSTALL ?= install
 CC ?= "gcc"

-CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
`pkg-config --cflags libnl-1`
+CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
 CFLAGS += -O2 -g
-LDFLAGS += `pkg-config --libs libnl-1`
-NLVERSION = 1.0
+NLVERSION = 2.0

 OBJS = iw.o info.o phy.o interface.o station.o util.o mpath.o reg.o
mesh.o genl.o
 ALL = iw

+ifeq ($(NLVERSION), 2.0)
+CFLAGS += `pkg-config --cflags libnl-2.0` -DCONFIG_LIBNL20
+LDFLAGS += `pkg-config --libs libnl-2.0`
+LIBS += -lnl -lnl-genl -lnl-nf -lnl-route
+NLTESTVERSION = 2.0
+else
+CFLAGS += `pkg-config --cflags libnl-1`
+LDFLAGS += `pkg-config --libs libnl-1.0`
+LIBS += -lnl
+NLTESTVERSION = 1
+endif
+
 ifeq ($(V),1)
 Q=
 NQ=true
@@ -29,7 +40,7 @@ endif
 all: version_check $(ALL)

 version_check:
-	@if ! pkg-config --atleast-version=$(NLVERSION) libnl-1; then echo
"You need at least libnl version $(NLVERSION)"; exit 1; fi
+	@if ! pkg-config --atleast-version=$(NLVERSION)
libnl-$(NLTESTVERSION); then echo "You need at least libnl version
$(NLVERSION)"; exit 1; fi


 version.h: version.sh
@@ -42,7 +53,7 @@ version.h: version.sh

 iw:	$(OBJS)
 	@$(NQ) ' CC  ' iw
-	$(Q)$(CC) $(LDFLAGS) $(OBJS) -o iw
+	$(Q)$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o iw

 check:
 	$(Q)$(MAKE) all CC="REAL_CC=$(CC) CHECK=\"sparse -Wall\" cgcc"
diff --git a/iw.c b/iw.c
index afae643..7038973 100644
--- a/iw.c
+++ b/iw.c
@@ -23,6 +23,13 @@
 #include "iw.h"
 #include "version.h"

+#ifdef CONFIG_LIBNL20
+/* libnl 2.0 compatibility code */
+#define nl_handle_alloc_cb nl_socket_alloc_cb
+#define nl_handle_alloc nl_socket_alloc
+#define nl_handle_destroy nl_socket_free
+#endif /* CONFIG_LIBNL20 */
+
 static int debug = 0;

 static int nl80211_init(struct nl80211_state *state)
@@ -40,9 +47,12 @@ static int nl80211_init(struct nl80211_state *state)
 		err = -ENOLINK;
 		goto out_handle_destroy;
 	}
-
+#ifdef CONFIG_LIBNL20
+	if (genl_ctrl_alloc_cache(state->nl_handle, &(state->nl_cache))) {
+#else
 	state->nl_cache = genl_ctrl_alloc_cache(state->nl_handle);
 	if (!state->nl_cache) {
+#endif
 		fprintf(stderr, "Failed to allocate generic netlink cache.\n");
 		err = -ENOMEM;
 		goto out_handle_destroy;

