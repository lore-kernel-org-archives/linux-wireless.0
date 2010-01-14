Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51038 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab0ANLJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 06:09:51 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0EB9Gga010906
	for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 13:09:48 +0200
Received: from [127.0.1.1] (trdhcp21270.nmp.nokia.com [172.22.212.70])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0EB9HvF027598
	for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 13:09:18 +0200
Subject: [PATCH 1/2] mac80211: fix mac80211.h documentation warnings
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 14 Jan 2010 13:09:14 +0200
Message-ID: <20100114110914.22608.12379.stgit@tikku>
In-Reply-To: <20100114110826.22608.23087.stgit@tikku>
References: <20100114110826.22608.23087.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

There were some warnings about missing documentation and a missing reference.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 Documentation/DocBook/mac80211.tmpl |    2 +-
 include/net/mac80211.h              |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/mac80211.tmpl b/Documentation/DocBook/mac80211.tmpl
index f3f37f1..971d1c0 100644
--- a/Documentation/DocBook/mac80211.tmpl
+++ b/Documentation/DocBook/mac80211.tmpl
@@ -144,7 +144,7 @@ usage should require reading the full document.
         this though and the recommendation to allow only a single
         interface in STA mode at first!
       </para>
-!Finclude/net/mac80211.h ieee80211_if_init_conf
+!Finclude/net/mac80211.h ieee80211_vif
     </chapter>
 
     <chapter id="rx-tx">
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f313a3c..bbfa475 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -107,6 +107,7 @@ enum ieee80211_max_queues {
  *	2^n-1 in the range 1..32767]
  * @cw_max: maximum contention window [like @cw_min]
  * @txop: maximum burst time in units of 32 usecs, 0 meaning disabled
+ * @uapsd: is U-APSD mode enabled for the queue
  */
 struct ieee80211_tx_queue_params {
 	u16 txop;
@@ -608,7 +609,11 @@ enum ieee80211_conf_changed {
 /**
  * enum ieee80211_smps_mode - spatial multiplexing power save mode
  *
- * @
+ * @IEEE80211_SMPS_AUTOMATIC: automatic
+ * @IEEE80211_SMPS_OFF: off
+ * @IEEE80211_SMPS_STATIC: static
+ * @IEEE80211_SMPS_DYNAMIC: dynamic
+ * @IEEE80211_SMPS_NUM_MODES: internal, don't use
  */
 enum ieee80211_smps_mode {
 	IEEE80211_SMPS_AUTOMATIC,

