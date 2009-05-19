Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35201 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZESIjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 04:39:36 -0400
Subject: [PATCH] mac80211: fix kernel-doc
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 May 2009 10:39:34 +0200
Message-Id: <1242722374.17164.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving information from config_interface to bss_info_changed
removed struct ieee80211_if_conf which the documentation still
refers to, additionally there's one kernel-doc description too
much and one other missing, fix all this.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/DocBook/mac80211.tmpl |    1 -
 include/net/mac80211.h              |    1 -
 net/mac80211/sta_info.h             |    1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-05-19 10:25:25.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-05-19 10:35:11.000000000 +0200
@@ -173,7 +173,6 @@ enum ieee80211_bss_change {
  * @timestamp: beacon timestamp
  * @beacon_int: beacon interval
  * @assoc_capability: capabilities taken from assoc resp
- * @ht: BSS's HT configuration
  * @basic_rates: bitmap of basic rates, each bit stands for an
  *	index into the rate table configured by the driver in
  *	the current band.
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-05-19 10:27:04.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2009-05-19 10:35:11.000000000 +0200
@@ -216,6 +216,7 @@ struct sta_ampdu_mlme {
  * @plink_state: peer link state
  * @plink_timeout: timeout of peer link
  * @plink_timer: peer link watch timer
+ * @plink_timer_was_running: used by suspend/resume to restore timers
  * @debugfs: debug filesystem info
  * @sta: station information we share with the driver
  */
--- wireless-testing.orig/Documentation/DocBook/mac80211.tmpl	2009-05-19 10:37:35.000000000 +0200
+++ wireless-testing/Documentation/DocBook/mac80211.tmpl	2009-05-19 10:37:41.000000000 +0200
@@ -145,7 +145,6 @@ usage should require reading the full do
         interface in STA mode at first!
       </para>
 !Finclude/net/mac80211.h ieee80211_if_init_conf
-!Finclude/net/mac80211.h ieee80211_if_conf
     </chapter>
 
     <chapter id="rx-tx">


