Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3EWVMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 17:12:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10] mac80211: assign AP_VLAN hw queues correctly
Date: Thu, 23 May 2013 23:12:09 +0200
Message-Id: <1369343529-16103-1-git-send-email-johannes@sipsolutions.net> (sfid-20130523_231226_245145_D8209694)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A lot of code in mac80211 assumes that the hw queues are
set up correctly for all interfaces (except for monitor)
but this isn't true for AP_VLAN interfaces. Fix this by
copying the AP master configuration when an AP VLAN is
brought up, after this the AP interface can't change its
configuration any more and needs to be brought down to
change it, which also forces AP_VLAN interfaces down, so
just copying in open() is sufficient.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 68f51c3..00e2238 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -474,6 +474,9 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			master->control_port_protocol;
 		sdata->control_port_no_encrypt =
 			master->control_port_no_encrypt;
+		sdata->vif.cab_queue = master->vif.cab_queue;
+		memcpy(sdata->vif.hw_queue, master->vif.hw_queue,
+		       sizeof(sdata->vif.hw_queue));
 		break;
 		}
 	case NL80211_IFTYPE_AP:
-- 
1.8.0

