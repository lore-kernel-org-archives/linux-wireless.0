Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46111 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753439AbZBVRTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 12:19:36 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 22 Feb 2009 18:19:33 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090222171933.102390@gmx.net> (sfid-20090222_181939_945473_D5334000)
MIME-Version: 1.0
Subject: [PATCH v3] mac80211: Give it some time to do the TSF sync
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Give slow hardware some time to do the TSF sync, to not run into an IBS=
S merging endless loop in some rarely situations.

Version 2 adds a comment.
Version 3: I had forgotten to change the bracket.
Version 4: No magic number.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1bbfc70..367d2cf 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -29,6 +29,7 @@
 #define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
=20
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
+#define IEEE80211_IBSS_MERGE_DELAY 0x400000
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
=20
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
@@ -332,6 +333,10 @@ static void ieee80211_rx_bss_info(struct ieee80211=
_sub_if_data *sdata,
 	       jiffies);
 #endif
=20
+	/* give slow hardware some time to do the TSF sync */
+	if (rx_timestamp < IEEE80211_IBSS_MERGE_DELAY)
+		goto put_bss;
+
 	if (beacon_timestamp > rx_timestamp) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "%s: beacon TSF higher than "

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
