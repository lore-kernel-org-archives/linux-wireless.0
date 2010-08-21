Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0HUA3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 20:29:18 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, geoclue@lists.freedesktop.org,
	David.Quan@atheros.com, kevin@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] iw: add GeoClue support for automatically determining location
Date: Fri, 20 Aug 2010 20:29:16 -0400
Message-Id: <1282350556-16523-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
References: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds GeoClue support to iw through a new command,
georeg. The command can be used to both query what GeoClue
knows about our location and also to send it to the kernel.

georeg support will only be compiled if you have geoclue
libraries available. The current GeoClue implementation uses
the hostip provider from GeoClue (http://hostip.info).

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 COPYING  |    2 +-
 Makefile |    7 +++
 georeg.c |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 180 insertions(+), 1 deletions(-)
 create mode 100644 georeg.c

diff --git a/COPYING b/COPYING
index 73e19ac..3782eca 100644
--- a/COPYING
+++ b/COPYING
@@ -1,7 +1,7 @@
 Copyright (c) 2007, 2008	Johannes Berg
 Copyright (c) 2007		Andy Lutomirski
 Copyright (c) 2007		Mike Kershaw
-Copyright (c) 2008-2009		Luis R. Rodriguez
+Copyright (c) 2008-2010		Luis R. Rodriguez
 
 Permission to use, copy, modify, and/or distribute this software for any
 purpose with or without fee is hereby granted, provided that the above
diff --git a/Makefile b/Makefile
index bd6ca15..75e105a 100644
--- a/Makefile
+++ b/Makefile
@@ -24,6 +24,13 @@ ALL = iw
 
 NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
 NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
+GEO_FOUND := $(shell $(PKG_CONFIG) --exists geoclue && echo Y)
+
+ifeq ($(GEO_FOUND),Y)
+OBJS += georeg.o
+LIBS += $(shell $(PKG_CONFIG) --libs geoclue)
+CFLAGS += $(shell $(PKG_CONFIG) --cflags geoclue)
+endif
 
 ifeq ($(NL1FOUND),Y)
 NLLIBNAME = libnl-1
diff --git a/georeg.c b/georeg.c
new file mode 100644
index 0000000..65acf31
--- /dev/null
+++ b/georeg.c
@@ -0,0 +1,172 @@
+/*
+ * Copyright 2010 Luis R. Rodriguez <lrodriguez@atheros.com>
+ *
+ * If your Linux distribution supports GeoClue you can use this
+ * 'iw georeg set' to notify the kernel of your country based
+ * on your Operating System's geolocation hints it can obtain.
+ * Since the hostip provider does not currently provide asynchronous
+ * signals you should first check for network connectvity before
+ * using this.
+ *
+ * To test what GeoClue is using prior to sending to the kernel you
+ * can use 'iw georeg get'.
+ */
+
+#include <net/if.h>
+#include <errno.h>
+#include <string.h>
+#include <stdbool.h>
+
+#include <geoclue/geoclue-address.h>
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
+SECTION(georeg);
+
+/*
+ * This uses the hostip provider from GeoClue (http://hostip.info).
+ *
+ * TODO:
+ *
+ * - The hostip provider should be extended to listen to signals for
+ *   network connetions, and once one becomes availble we can enable
+ *   asynchronous notifications back to the kernel.
+ *
+ * - Extend this to try first the GeoClue gypsy provider, gpsd.
+ *
+ * - Consider writing a GeoClue provider for https://wigle.net/
+ *   which the supplicant can use to inform GeoClue of location.
+ *
+ * - Consider writing our own GeoClue provider based on timezones
+ *   as a last resort.
+ *
+ * - Consider whether or not the kernel may want accuracy
+ *   information as well to make more interesting decisions.
+ */
+static int get_geoclue_alpha2(char *alpha2)
+{
+	GeoclueAddress *address = NULL;
+	GHashTable *details = NULL;
+	int timestamp;
+	double acc_hor, acc_vert;
+	GError *error = NULL;
+	GeoclueAccuracy *accuracy = NULL;
+	GeoclueAccuracyLevel acc_level;
+	gchar *country;
+	int r = 0;
+
+	g_type_init();
+
+	address = geoclue_address_new("org.freedesktop.Geoclue.Providers.Hostip",
+				      "/org/freedesktop/Geoclue/Providers/Hostip");
+
+	if (!address)
+		return -EINVAL;
+
+        if (!geoclue_address_get_address(address, &timestamp,
+					 &details, &accuracy,
+					 &error)) {
+		g_object_unref(address);
+		return -EINVAL;
+	}
+
+	if (error) {
+		g_printerr("%s\n", error->message);
+		g_error_free(error);
+		g_object_unref(address);
+		return -EINVAL;
+	}
+
+	geoclue_accuracy_get_details(accuracy, &acc_level, &acc_hor, &acc_vert);
+
+	if (acc_level < GEOCLUE_ACCURACY_LEVEL_COUNTRY) {
+		fprintf(stderr, "Accuracy level is not country specific\n");
+		fprintf(stderr, "Hostip does not have a valid location available."
+			"\nVisit http://www.hostip.info/ to correct this");
+		r = -EINVAL;
+		goto out;
+	}
+
+	country = g_hash_table_lookup(details, GEOCLUE_ADDRESS_KEY_COUNTRYCODE);
+	if (!country) {
+		r = -EINVAL;
+		goto out;
+	}
+
+	/* At this point we know we are sure of the country */
+
+	alpha2[0] = country[0];
+	alpha2[1] = country[1];
+	alpha2[2] = '\0';
+
+out:
+	g_hash_table_destroy (details);
+	geoclue_accuracy_free(accuracy);
+	g_object_unref(address);
+
+	return r;
+}
+
+static int handle_geo_reg_set(struct nl80211_state *state,
+			      struct nl_cb *cb,
+			      struct nl_msg *msg,
+			      int argc, char **argv)
+{
+	char alpha2[3];
+	int r;
+
+	r = get_geoclue_alpha2(alpha2);
+	if (r) {
+		fprintf(stderr, "Could not get an alpha2 from GeoClue\n");
+		return -EINVAL;
+	}
+
+	if (!is_alpha2(alpha2)) {
+		fprintf(stderr, "not a valid ISO/IEC 3166-1 alpha2\n");
+		return -EINVAL;
+	}
+
+	printf("GeoClue sent: %c%c\n", alpha2[0], alpha2[1]);
+
+	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, alpha2);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(georeg, set, NULL, NL80211_CMD_SET_REG, 0, CIB_NONE, handle_geo_reg_set,
+        "Use GeoClue to send your location information to the kernel.");
+
+static int handle_geo_reg_get(struct nl80211_state *state,
+			      struct nl_cb *cb,
+			      struct nl_msg *msg,
+			      int argc, char **argv)
+{
+	char alpha2[3];
+	int r;
+
+	r = get_geoclue_alpha2(alpha2);
+	if (r) {
+		fprintf(stderr, "Could not get an alpha2 from GeoClue\n");
+		return -EINVAL;
+	}
+
+	if (!is_alpha2(alpha2)) {
+		fprintf(stderr, "not a valid ISO/IEC 3166-1 alpha2\n");
+		return -EINVAL;
+	}
+
+	fprintf(stdout, "GeoClue: %c%c - Via http://hostip.info\n",
+		alpha2[0], alpha2[1]);
+
+	return 0;
+}
+COMMAND(georeg, get, NULL, 0, 0, CIB_NONE, handle_geo_reg_get,
+        "Use GeoClue to get your location information prior to sending it to the kernel.");
-- 
1.7.0.4

