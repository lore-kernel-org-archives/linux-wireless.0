Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab2E3NQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 09:16:12 -0400
Message-ID: <1338383762.4511.16.camel@jlt3.sipsolutions.net> (sfid-20120530_151615_403243_25B38365)
Subject: [PATCH 3.5] mac80211: flush off-channel work when interface goes
 down
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nirav Shah <nirav.j2.shah@intel.com>
Date: Wed, 30 May 2012 15:16:02 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When any interface goes down, it could be the one that
we were doing off-channel with. Thus, we need to flush
the offchannel start/stop work so they can't run when
the interface has already been removed from the driver
or even been destroyed. It's OK to flush them even if
they were for another interface, that just means that
we potentially delay the interface down a little bit.

Cc: stable@kernel.org [3.4]
Reported-by: Nirav Shah <nirav.j2.shah@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/iface.c	2012-05-30 15:08:51.000000000 +0200
+++ b/net/mac80211/iface.c	2012-05-30 15:09:24.000000000 +0200
@@ -637,6 +637,8 @@ static void ieee80211_do_stop(struct iee
 		ieee80211_configure_filter(local);
 		break;
 	default:
+		flush_work(&local->hw_roc_start);
+		flush_work(&local->hw_roc_done);
 		flush_work(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.


