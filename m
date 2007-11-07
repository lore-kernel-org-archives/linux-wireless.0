Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbXKGPke (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 10:40:34 -0500
Subject: [PATCH] mac80211: fix MAC80211_RCSIMPLE Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4731D9CC.3090809@lwfinger.net>
References: <4731D9CC.3090809@lwfinger.net>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 16:41:13 +0100
Message-Id: <1194450073.4470.46.camel@johannes.berg> (sfid-20071107_154040_079940_95CE0FF2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I meant for this to be selectable only with EMBEDDED, not enabled only
with EMBEDDED. This does it that way. Sorry.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/Kconfig	2007-11-07 16:38:57.779051161 +0100
+++ everything/net/mac80211/Kconfig	2007-11-07 16:39:06.949024631 +0100
@@ -14,9 +14,9 @@ config MAC80211
 	networking stack.
 
 config MAC80211_RCSIMPLE
-	bool "'simple' rate control algorithm"
+	bool "'simple' rate control algorithm" if EMBEDDED
 	default y
-	depends on MAC80211 && EMBEDDED
+	depends on MAC80211
 	help
 	  This option allows you to turn off the 'simple' rate
 	  control algorithm in mac80211. If you do turn it off,


