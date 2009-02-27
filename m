Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53102 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754819AbZB0SnU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 13:43:20 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 19:43:14 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090227184314.42290@gmx.net> (sfid-20090227_194323_967797_BF5FC99C)
MIME-Version: 1.0
Subject: [PATCH] mac80211: Replacement for: Implement commit in wireless
 extensions
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch _not_ implements commit in wireless extensions, but solves s=
ome dependencies needed by the other patches.

The maybe usage of this ioctl must discussed after the complete joining=
 process (STA and *IBSS*) in nl80211 defined.

I hope this is a compromise.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ecbc8e0..7f00c70 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -920,6 +920,7 @@ static inline int ieee80211_bssid_match(const u8 *r=
addr, const u8 *addr)
=20
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
 int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 chang=
ed);
+void ieee80211_commit(struct ieee80211_sub_if_data *sdata);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sd=
ata,
 				      u32 changed);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f38db4d..1b2d598 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -294,6 +294,20 @@ int ieee80211_hw_config(struct ieee80211_local *lo=
cal, u32 changed)
 	return ret;
 }
=20
+void ieee80211_commit(struct ieee80211_sub_if_data *sdata)
+{
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_ADHOC:
+		ieee80211_ibss_commit(sdata);
+		break;
+	case NL80211_IFTYPE_STATION:
+		ieee80211_sta_commit(sdata);
+		break;
+	default:
+		break;
+	}
+}
+
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sd=
ata,
 				      u32 changed)
 {

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
