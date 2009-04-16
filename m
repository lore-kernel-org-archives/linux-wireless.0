Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZDPKQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 06:16:17 -0400
Subject: [PATCH 2.6.30] cfg80211: copy hold when replacing BSS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <Kalle.Valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 12:15:38 +0200
Message-Id: <1239876938.9737.14.camel@johannes.local> (sfid-20090416_121620_410957_FA62E3F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we receive a probe response frame we can replace the
BSS struct in our list -- but if that struct is held then
we need to hold the new one as well.

We really should fix this completely and not replace the
struct, but this is a bandaid for now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/scan.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/wireless/scan.c	2009-04-16 12:12:08.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-04-16 12:12:21.000000000 +0200
@@ -364,6 +364,8 @@ cfg80211_bss_update(struct cfg80211_regi
 		list_replace(&found->list, &res->list);
 		rb_replace_node(&found->rbn, &res->rbn,
 				&dev->bss_tree);
+		/* XXX: workaround */
+		res->hold = found->hold;
 		kref_put(&found->ref, bss_release);
 		found = res;
 	} else if (found) {


