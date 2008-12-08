Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-133-90.gdrpmi.dsl-w.verizon.net ([71.115.133.90]:44693
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbYLHXwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 18:52:54 -0500
Message-ID: <493DB351.6000103@erley.org> (sfid-20081209_005259_453921_4B076CCD)
Date: Mon, 08 Dec 2008 18:52:49 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan E <trg_info@mailhaven.com>, linux-wireless@vger.kernel.org
Subject: Re: Userspace tools: Roadmap?
References: <1228692546.8826.1288759933@webmail.messagingengine.com>	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>	 <1228778295.10662.1288975589@webmail.messagingengine.com> <1228778801.22164.156.camel@johannes.berg>
In-Reply-To: <1228778801.22164.156.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2008-12-08 at 18:18 -0500, Dan E wrote:
> There's libnl 1.2 and 2.0? That's news to me! Patches welcome. Sorry, I
> guess it needs 1.0 or 1.1, will fix the page.
> 
following is a patch that gets iw working with the development versions
of libnl.  I keep it uptodate at: http://wireless.erley.org/

The Makefile changes may not be the 'best' way to do it, but it works
for me.

Pat Erley

---

diff --git a/Makefile b/Makefile
index df59b51..1bc8310 100644
--- a/Makefile
+++ b/Makefile
@@ -10,10 +10,11 @@ MKDIR ?= mkdir -p
 INSTALL ?= install
 CC ?= "gcc"

-CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
`pkg-config --cflags libnl-1`
+NLVERSION = 2.0
+CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
`pkg-config --cflags libnl-$(NLVERSION)`
 CFLAGS += -O2 -g
-LDFLAGS += `pkg-config --libs libnl-1`
-NLVERSION = 1.0
+LDFLAGS += `pkg-config --libs libnl-$(NLVERSION)`
+LIBS += -lnl -lnl-genl -lnl-nf -lnl-route

 OBJS = iw.o info.o phy.o interface.o station.o util.o mpath.o reg.o
mesh.o genl.o
 ALL = iw
@@ -29,7 +30,7 @@ endif
 all: version_check $(ALL)

 version_check:
-	@if ! pkg-config --atleast-version=$(NLVERSION) libnl-1; then echo
"You need at least libnl version $(NLVERSION)"; exit 1; fi
+	@if ! pkg-config --atleast-version=$(NLVERSION) libnl-$(NLVERSION);
then echo "You need at least libnl version $(NLVERSION)"; exit 1; fi


 version.h: version.sh
@@ -42,7 +43,7 @@ version.h: version.sh

 iw:	$(OBJS)
 	@$(NQ) ' CC  ' iw
-	$(Q)$(CC) $(LDFLAGS) $(OBJS) -o iw
+	$(Q)$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o iw

 check:
 	$(Q)$(MAKE) all CC="REAL_CC=$(CC) CHECK=\"sparse -Wall\" cgcc"
diff --git a/iw.c b/iw.c
index 5859180..11af7d6 100644
--- a/iw.c
+++ b/iw.c
@@ -29,7 +29,7 @@ static int nl80211_init(struct nl80211_state *state)
 {
 	int err;

-	state->nl_handle = nl_handle_alloc();
+	state->nl_handle = nl_socket_alloc();
 	if (!state->nl_handle) {
 		fprintf(stderr, "Failed to allocate netlink handle.\n");
 		return -ENOMEM;
@@ -41,8 +41,7 @@ static int nl80211_init(struct nl80211_state *state)
 		goto out_handle_destroy;
 	}

-	state->nl_cache = genl_ctrl_alloc_cache(state->nl_handle);
-	if (!state->nl_cache) {
+	if (genl_ctrl_alloc_cache(state->nl_handle, &(state->nl_cache))) {
 		fprintf(stderr, "Failed to allocate generic netlink cache.\n");
 		err = -ENOMEM;
 		goto out_handle_destroy;
@@ -60,7 +59,7 @@ static int nl80211_init(struct nl80211_state *state)
  out_cache_free:
 	nl_cache_free(state->nl_cache);
  out_handle_destroy:
-	nl_handle_destroy(state->nl_handle);
+	nl_socket_free(state->nl_handle);
 	return err;
 }

@@ -68,7 +67,7 @@ static void nl80211_cleanup(struct nl80211_state *state)
 {
 	genl_family_put(state->nl80211);
 	nl_cache_free(state->nl_cache);
-	nl_handle_destroy(state->nl_handle);
+	nl_socket_free(state->nl_handle);
 }

 __COMMAND(NULL, NULL, NULL, 0, 0, 0, CIB_NONE, NULL);
