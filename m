Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZKASZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 13:25:44 -0500
Subject: [PATCH] mac80211: check interface is down before type change
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Nov 2009 19:25:40 +0100
Message-ID: <1257099940.3555.159.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some strange reason the netif_running() check
ended up after the actual type change instead of
before, potentially causing all kinds of problems
if the interface is up while changing the type;
one of the problems manifests itself as a warning:

WARNING: at net/mac80211/iface.c:651 ieee80211_teardown_sdata+0xda/0x1a0 [mac80211]()
Hardware name: Aspire one      
Pid: 2596, comm: wpa_supplicant Tainted: G        W  2.6.31-10-generic #32-Ubuntu
Call Trace:
 [] warn_slowpath_common+0x6d/0xa0
 [] warn_slowpath_null+0x15/0x20
 [] ieee80211_teardown_sdata+0xda/0x1a0 [mac80211]
 [] ieee80211_if_change_type+0x4a/0xc0 [mac80211]
 [] ieee80211_change_iface+0x61/0xa0 [mac80211]
 [] cfg80211_wext_siwmode+0xc7/0x120 [cfg80211]
 [] ioctl_standard_call+0x58/0xf0

(http://www.kerneloops.org/searchweek.php?search=ieee80211_teardown_sdata)

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-11-01 19:19:16.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-11-01 19:20:49.000000000 +0100
@@ -72,6 +72,9 @@ static int ieee80211_change_iface(struct
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
 
+	if (netif_running(dev))
+		return -EBUSY;
+
 	if (!nl80211_type_check(type))
 		return -EINVAL;
 
@@ -81,9 +84,6 @@ static int ieee80211_change_iface(struct
 	if (ret)
 		return ret;
 
-	if (netif_running(sdata->dev))
-		return -EBUSY;
-
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->mesh_id_len)
 		ieee80211_sdata_set_mesh_id(sdata,
 					    params->mesh_id_len,


