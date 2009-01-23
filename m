Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45108 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754551AbZAWEdj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 23:33:39 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 23 Jan 2009 05:33:37 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090123043337.270720@gmx.net> (sfid-20090123_053344_719360_EF0306AB)
MIME-Version: 1.0
Subject: [PATCH v2] mac80211: Read the TSF via debugfs
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds an low-level driver independent entry to read the TSF v=
alue into the debugfs of mac80211. This makes debugging the IBSS handli=
ng of wifi drivers easier.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN compat-wireless-2009-01-22.orig/net/mac80211/debugfs.c compat=
-wireless-2009-01-22/net/mac80211/debugfs.c
--- compat-wireless-2009-01-22.orig/net/mac80211/debugfs.c	2009-01-22 2=
0:51:46.000000000 +0100
+++ compat-wireless-2009-01-22/net/mac80211/debugfs.c	2009-01-23 03:49:=
45.000000000 +0100
@@ -61,6 +61,8 @@
 		      local->wep_iv & 0xffffff);
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100, "%s",
 		      local->rate_ctrl ? local->rate_ctrl->ops->name : "<unset>");
+DEBUGFS_READONLY_FILE(tsf, 20, "%#018llx",
+                      (unsigned long long) (local->ops->get_tsf ? loca=
l->ops->get_tsf(local_to_hw(local)) : 0));
=20
 /* statistics stuff */
=20
@@ -202,6 +204,7 @@
 	DEBUGFS_ADD(long_retry_limit);
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
+	DEBUGFS_ADD(tsf);
=20
 	statsd =3D debugfs_create_dir("statistics", phyd);
 	local->debugfs.statistics =3D statsd;
@@ -255,6 +258,7 @@
 	DEBUGFS_DEL(long_retry_limit);
 	DEBUGFS_DEL(total_ps_buffered);
 	DEBUGFS_DEL(wep_iv);
+	DEBUGFS_DEL(tsf);
=20
 	DEBUGFS_STATS_DEL(transmitted_fragment_count);
 	DEBUGFS_STATS_DEL(multicast_transmitted_frame_count);
diff -urN compat-wireless-2009-01-22.orig/net/mac80211/ieee80211_i.h co=
mpat-wireless-2009-01-22/net/mac80211/ieee80211_i.h
--- compat-wireless-2009-01-22.orig/net/mac80211/ieee80211_i.h	2009-01-=
22 20:51:46.000000000 +0100
+++ compat-wireless-2009-01-22/net/mac80211/ieee80211_i.h	2009-01-23 03=
:55:44.000000000 +0100
@@ -744,6 +744,7 @@
 		struct dentry *long_retry_limit;
 		struct dentry *total_ps_buffered;
 		struct dentry *wep_iv;
+		struct dentry *tsf;
 		struct dentry *statistics;
 		struct local_debugfsdentries_statsdentries {
 			struct dentry *transmitted_fragment_count;

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
