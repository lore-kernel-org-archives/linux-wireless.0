Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:36251 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaBTOph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 09:45:37 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/2] cfg80211: docbook: add interface combinations documentation
Date: Thu, 20 Feb 2014 16:45:34 +0200
Message-Id: <1392907534-14470-2-git-send-email-luca@coelho.fi> (sfid-20140220_154607_414265_5E1FA95F)
In-Reply-To: <1392907534-14470-1-git-send-email-luca@coelho.fi>
References: <1392907534-14470-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add the ieee80211_iface_limit and the ieee80211_iface_combination
structures to docbook.  Reformat the examples of combinations
slightly, so it looks a bit better on docbook.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 Documentation/DocBook/80211.tmpl |  2 ++
 include/net/cfg80211.h           | 12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
index 46ad6fa..044b764 100644
--- a/Documentation/DocBook/80211.tmpl
+++ b/Documentation/DocBook/80211.tmpl
@@ -98,6 +98,8 @@
 !Finclude/net/cfg80211.h priv_to_wiphy
 !Finclude/net/cfg80211.h set_wiphy_dev
 !Finclude/net/cfg80211.h wdev_priv
+!Finclude/net/cfg80211.h ieee80211_iface_limit
+!Finclude/net/cfg80211.h ieee80211_iface_combination
       </chapter>
       <chapter>
       <title>Actions and configuration</title>
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2c53749..f7a8d69 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2611,9 +2611,12 @@ struct ieee80211_iface_limit {
  *	only in special cases.
  * @radar_detect_widths: bitmap of channel widths supported for radar detection
  *
- * These examples can be expressed as follows:
+ * With this structure the driver can describe which interface
+ * combinations it supports concurrently.
  *
- * Allow #STA <= 1, #AP <= 1, matching BI, channels = 1, 2 total:
+ * Examples:
+ *
+ * 1. Allow #STA <= 1, #AP <= 1, matching BI, channels = 1, 2 total:
  *
  *  struct ieee80211_iface_limit limits1[] = {
  *	{ .max = 1, .types = BIT(NL80211_IFTYPE_STATION), },
@@ -2627,7 +2630,7 @@ struct ieee80211_iface_limit {
  *  };
  *
  *
- * Allow #{AP, P2P-GO} <= 8, channels = 1, 8 total:
+ * 2. Allow #{AP, P2P-GO} <= 8, channels = 1, 8 total:
  *
  *  struct ieee80211_iface_limit limits2[] = {
  *	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) |
@@ -2641,7 +2644,8 @@ struct ieee80211_iface_limit {
  *  };
  *
  *
- * Allow #STA <= 1, #{P2P-client,P2P-GO} <= 3 on two channels, 4 total.
+ * 3. Allow #STA <= 1, #{P2P-client,P2P-GO} <= 3 on two channels, 4 total.
+ *
  * This allows for an infrastructure connection and three P2P connections.
  *
  *  struct ieee80211_iface_limit limits3[] = {
-- 
1.8.5.3

