Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37781 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760678AbXGZQAo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 12:00:44 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/2] mac80211 [HT] adding MAC80211_HT and MAC80211_HT_DEBUG
Date: Thu, 26 Jul 2007 19:00:39 +0300
Message-Id: <11854656402369-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds MAC80211_HT and MAC80211_HT_DEBUG config variables
to separate HT features

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index a03c886..219b33c 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -20,6 +20,13 @@ config MAC80211_LEDS
 	This option enables a few LED triggers for different
 	packet receive/transmit events.
 
+config MAC80211_HT
+	bool "Enable 802.11n HT Features"
+	depends on MAC80211
+	---help---
+	This option enables 802.11n High Throughput features
+	such as MIMO, AMPDU and AMSDU aggregation	
+
 config MAC80211_DEBUGFS
 	bool "Export mac80211 internals in DebugFS"
 	depends on MAC80211 && DEBUG_FS
@@ -39,6 +46,12 @@ config MAC80211_DEBUG
 	  If you are not trying to debug or develop the ieee80211
 	  subsystem, you most likely want to say N here.
 
+config MAC80211_HT_DEBUG
+	bool "Enables HT debugging output"
+	depends on MAC80211_HT && MAC80211_DEBUG
+	---help---
+	  Select this to see debugging information about HT
+
 config MAC80211_VERBOSE_DEBUG
 	bool "Verbose debugging output"
 	depends on MAC80211_DEBUG
-- 
1.5.2.2
