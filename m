Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53750 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754193AbZBUVwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 16:52:06 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 21 Feb 2009 22:52:02 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090221215202.227310@gmx.net> (sfid-20090221_225210_404734_CCA7E5A1)
MIME-Version: 1.0
Subject: [PATCH] mac80211: Give it some time to do the TSF sync
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Give slow hardware some time to do the TSF sync, to not run into an IBS=
S merging endless loop in some rarely situations.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1bbfc70..896e45c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -332,7 +332,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_=
sub_if_data *sdata,
 	       jiffies);
 #endif
=20
-	if (beacon_timestamp > rx_timestamp) {
+	if (beacon_timestamp > rx_timestamp && rx_timestamp > 0x400000) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "%s: beacon TSF higher than "
 		       "local TSF - IBSS merge with BSSID %pM\n",

--=20
Jetzt 1 Monat kostenlos! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 17,95 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
