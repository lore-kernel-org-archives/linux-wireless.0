Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031666AbXEALL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 07:11:28 -0400
Subject: [PATCH] fix mac80211 compile w/o VERBOSE_DEBUG but w/ DEBUG
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>
Content-Type: text/plain
Date: Tue, 01 May 2007 13:12:09 +0200
Message-Id: <1178017929.3483.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes mac80211 compilation when CONFIG_MAC80211_DEBUG is set but
CONFIG_MAC80211_VERBOSE_DEBUG is not.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-05-01 13:09:38.284734191 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-05-01 13:10:06.374734191 +0200
@@ -951,7 +951,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 
 	if (unlikely(!tx->u.tx.mgmt_interface && tx->sdata->ieee802_1x &&
 		     !(sta_flags & WLAN_STA_AUTHORIZED))) {
-#ifdef CONFIG_MAC80211_DEBUG
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		printk(KERN_DEBUG "%s: dropped frame to " MAC_FMT
 		       " (unauthorized port)\n", tx->dev->name,
 		       MAC_ARG(hdr->addr1));


