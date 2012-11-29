Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:24599 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751493Ab2K2XTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 18:19:12 -0500
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH] mac80211: allow userspace registration for ProbeReq in IBSS
Date: Fri, 30 Nov 2012 00:18:12 +0100
Message-ID: <1354231092-10654-1-git-send-email-antonio@open-mesh.com> (sfid-20121130_001915_835225_37A18E6A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change allows userspace to register for ProbeReq on an
IBSS interface. However ProbeRequests are not redirected from
their normal rx path.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 70e8760..1fc8d25 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -474,7 +474,8 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 		.tx = 0xffff,
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
 			BIT(IEEE80211_STYPE_AUTH >> 4) |
-			BIT(IEEE80211_STYPE_DEAUTH >> 4),
+			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
 	},
 	[NL80211_IFTYPE_STATION] = {
 		.tx = 0xffff,
-- 
1.8.0

