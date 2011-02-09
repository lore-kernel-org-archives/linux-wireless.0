Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41802 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab1BIMCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:02:05 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id 1D426664001
	for <linux-wireless@vger.kernel.org>; Wed,  9 Feb 2011 13:02:04 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 3/3] hostapd: integrate DFS detection
Date: Wed,  9 Feb 2011 13:01:45 +0100
Message-Id: <1297252905-29739-6-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A global DFS handler instance is allocated at startup and ready to be fed
with pulse events passed through nl80211.

Includes
 * add src/dfs into hostapd
 * enable DFS channels
 * enable syslog output (to see reported DFS pattern matches)
---
 hostapd/Makefile     |   13 +++++++++++++
 hostapd/main.c       |   19 +++++++++++++++++++
 src/Makefile         |    2 ++
 src/ap/hw_features.c |    3 +++
 4 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/hostapd/Makefile b/hostapd/Makefile
index 1331e64..b68e11e 100644
--- a/hostapd/Makefile
+++ b/hostapd/Makefile
@@ -53,6 +53,19 @@ OBJS += ../src/ap/wpa_auth_ie.o
 OBJS += ../src/ap/preauth_auth.o
 OBJS += ../src/ap/pmksa_cache_auth.o
 
+CONFIG_DFS_DETECTOR=y
+
+ifdef CONFIG_DFS_DETECTOR
+CFLAGS += -DCONFIG_DFS_DETECTOR
+OBJS += ../src/dfs/dfs_debug.o
+OBJS += ../src/dfs/dfs_handler.o
+OBJS += ../src/dfs/dfs_pattern_detector.o
+
+# enable syslog logging to see DFS pattern detector results
+CFLAGS += -DCONFIG_DEBUG_SYSLOG
+endif
+
+
 NEED_RC4=y
 NEED_AES=y
 NEED_MD5=y
diff --git a/hostapd/main.c b/hostapd/main.c
index 635698a..42749ca 100644
--- a/hostapd/main.c
+++ b/hostapd/main.c
@@ -31,6 +31,12 @@
 #include "dump_state.h"
 #include "ctrl_iface.h"
 
+#ifdef CONFIG_DFS_DETECTOR
+#include "dfs/dfs.h"
+
+/* only one global DFS handler instance enough for proof-of-concept */
+struct dfs_handler *global_dfs_handler;
+#endif
 
 extern int wpa_debug_level;
 extern int wpa_debug_show_keys;
@@ -194,6 +200,10 @@ static struct hostapd_iface * hostapd_init(const char *config_file)
 	if (hapd_iface == NULL)
 		goto fail;
 
+#ifdef CONFIG_DEBUG_SYSLOG
+	wpa_debug_open_syslog();
+#endif
+
 	hapd_iface->init_complete = hostapd_init_complete;
 	hapd_iface->reload_config = hostapd_reload_config;
 	hapd_iface->config_read_cb = hostapd_config_read;
@@ -399,6 +409,9 @@ static int hostapd_global_init(struct hapd_interfaces *interfaces)
 	openlog("hostapd", 0, LOG_DAEMON);
 #endif /* CONFIG_NATIVE_WINDOWS */
 
+#ifdef CONFIG_DFS_DETECTOR
+	global_dfs_handler = dfs_handler_init(DFS_ETSI_DOMAIN);
+#endif
 	return 0;
 }
 
@@ -415,6 +428,12 @@ static void hostapd_global_deinit(void)
 	closelog();
 #endif /* CONFIG_NATIVE_WINDOWS */
 
+#ifdef CONFIG_DFS_DETECTOR
+	if (global_dfs_handler) {
+		global_dfs_handler->exit(global_dfs_handler);
+		global_dfs_handler = NULL;
+	}
+#endif
 	eap_server_unregister_methods();
 
 	os_daemonize_terminate(pid_file);
diff --git a/src/Makefile b/src/Makefile
index d73a175..06aa85e 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -1,5 +1,7 @@
 SUBDIRS=ap common crypto drivers eapol_auth eapol_supp eap_common eap_peer eap_server l2_packet p2p radius rsn_supp tls utils wps
 
+SUBDIRS += dfs
+
 all:
 	for d in $(SUBDIRS); do [ -d $$d ] && $(MAKE) -C $$d; done
 
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index f326183..3496388 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -80,12 +80,15 @@ int hostapd_get_hw_features(struct hostapd_iface *iface)
 			 * since that (in addition to full DFS) is not yet
 			 * supported.
 			 */
+#ifndef CONFIG_DFS_DETECTOR
+			/* do not disable if we have DFS detection */
 			if (feature->channels[j].flag &
 			    (HOSTAPD_CHAN_NO_IBSS |
 			     HOSTAPD_CHAN_PASSIVE_SCAN |
 			     HOSTAPD_CHAN_RADAR))
 				feature->channels[j].flag |=
 					HOSTAPD_CHAN_DISABLED;
+#endif /* CONFIG_DFS_DETECTOR */
 			if (feature->channels[j].flag & HOSTAPD_CHAN_DISABLED)
 				continue;
 			wpa_printf(MSG_MSGDUMP, "Allowed channel: mode=%d "
-- 
1.7.1

