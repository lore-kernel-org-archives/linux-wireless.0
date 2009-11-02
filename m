Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbZKBKbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 05:31:52 -0500
Subject: [PATCH] mac80211: fix internal scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Sujith <m.sujith@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Nov 2009 11:31:51 +0100
Message-ID: <1257157911.3555.183.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The internal scan request mac80211 uses to
scan for IBSS networks was set up to contain
no channels at all because n_channels wasn't
set after setting up the channels array. Fix
this to properly scan for networks.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Sujith, this might fix the iwlwifi problem?

 net/mac80211/main.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/net/mac80211/main.c	2009-11-02 11:23:42.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-02 11:23:57.000000000 +0100
@@ -901,6 +901,7 @@ int ieee80211_register_hw(struct ieee802
 			i++;
 		}
 	}
+	local->int_scan_req->n_channels = i;
 
 	local->network_latency_notifier.notifier_call =
 		ieee80211_max_network_latency;


