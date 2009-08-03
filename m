Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbZHCPEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 11:04:25 -0400
Subject: [PATCH] cfg80211: clear SSID on disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Joerg Albert <jal2@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 17:03:52 +0200
Message-Id: <1249311832.4561.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SME state machine in cfg80211 uses the SSID stored
in struct wireless_dev internally, but fails to clear
it when disconnecting. This doesn't matter to the SME
state machine, but does matter for IBSS. Thus, when
disconnecting, clear the SSID to avoid messing up the
IBSS state machine.

Reported-by: Joerg Albert <jal2@gmx.de>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/sme.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/net/wireless/sme.c	2009-08-03 16:45:01.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-08-03 16:59:02.000000000 +0200
@@ -550,6 +550,7 @@ void __cfg80211_disconnected(struct net_
 
 	wdev->current_bss = NULL;
 	wdev->sme_state = CFG80211_SME_IDLE;
+	wdev->ssid_len = 0;
 
 	if (wdev->conn) {
 		kfree(wdev->conn->ie);


