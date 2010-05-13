Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52378 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0EMFDu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 01:03:50 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 22:03:50 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19435.34888.771503.178631@gargle.gargle.HOWL>
Date: Thu, 13 May 2010 10:34:08 +0530
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <jussi.kivilinna@mbnet.fi>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Fix signal_type comparison
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

signal_type is enum cfg80211_signal_type.

This fixes the gcc warning:

scan.c: In function `cfg80211_inform_bss':
scan.c:518:6: warning: comparison between `enum cfg80211_signal_type' and `enum nl80211_bss'
scan.c: In function `cfg80211_inform_bss_frame':
scan.c:574:6: warning: comparison between `enum cfg80211_signal_type' and `enum nl80211_bss'

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/wireless/scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index a026c6d..58401d2 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -515,7 +515,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 
 	privsz = wiphy->bss_priv_size;
 
-	if (WARN_ON(wiphy->signal_type == NL80211_BSS_SIGNAL_UNSPEC &&
+	if (WARN_ON(wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
 			(signal < 0 || signal > 100)))
 		return NULL;
 
@@ -571,7 +571,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 				      u.probe_resp.variable);
 	size_t privsz = wiphy->bss_priv_size;
 
-	if (WARN_ON(wiphy->signal_type == NL80211_BSS_SIGNAL_UNSPEC &&
+	if (WARN_ON(wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
 	            (signal < 0 || signal > 100)))
 		return NULL;
 
-- 
1.7.1

