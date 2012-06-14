Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:62477 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2FNQoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:44:04 -0400
Message-ID: <4FDA14D1.30804@opentechinstitute.org> (sfid-20120614_184408_552858_88073270)
Date: Thu, 14 Jun 2012 12:44:01 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: add support for userspace to handle auth frames
 on adhoc ifaces
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow userspace daemons to register for (DE)AUTH management frames
received on an adhoc interface. Registration for these frames, done
through nl80211, is necessary to support certain userspace
authentication schemes.

Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
---
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d81c178..4467162 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -455,7 +455,9 @@ static const struct ieee80211_txrx_stypes
 ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
        [NL80211_IFTYPE_ADHOC] = {
                .tx = 0xffff,
-               .rx = BIT(IEEE80211_STYPE_ACTION >> 4),
+               .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+                       BIT(IEEE80211_STYPE_AUTH >> 4) |
+                       BIT(IEEE80211_STYPE_DEAUTH >> 4),
        },
        [NL80211_IFTYPE_STATION] = {
                .tx = 0xffff,

