Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbZG0IWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 04:22:33 -0400
Subject: [PATCH] cfg80211: fix disassoc while not associated
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 10:22:28 +0200
Message-Id: <1248682948.19945.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to disassociate while not associated,
the kernel would crash rather than refusing the
operation, fix this;

Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/mlme.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- wireless-testing.orig/net/wireless/mlme.c	2009-07-27 10:20:17.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-27 10:20:56.000000000 +0200
@@ -545,6 +545,12 @@ static int __cfg80211_mlme_disassoc(stru
 
 	ASSERT_WDEV_LOCK(wdev);
 
+	if (wdev->sme_state != CFG80211_SME_CONNECTED)
+		return -ENOTCONN;
+
+	if (WARN_ON(!wdev->current_bss))
+		return -ENOTCONN;
+
 	memset(&req, 0, sizeof(req));
 	req.reason_code = reason;
 	req.ie = ie;


