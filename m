Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55582 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356AbZFKPTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 11:19:51 -0400
Date: Thu, 11 Jun 2009 18:19:45 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: Do not try to associate with an empty SSID
Message-ID: <20090611151945.GA17284@jm.kir.nu>
References: <20090611105411.GA13825@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090611105411.GA13825@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like some programs (e.g., NM) are setting an empty SSID with
SIOCSIWESSID in some cases. This seems to trigger mac80211 to try to
associate with an invalid configuration (wildcard SSID) which will
result in failing associations (or odd issues, potentially including
kernel panic with some drivers) if the AP were to actually accept this
anyway).

Only start association process if the SSID is actually set. This
speeds up connection with NM in number of cases and avoids sending out
broken association request frames.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |    8 ++++++++
 1 file changed, 8 insertions(+)

v2: Allow disassociation in ssid_len=0 case and only avoid starting a
new association. This function is difficult to understand and for now, I
just want to fix the critical issue here. Eventually, this code should
be redesigned or at least commented clearly.

--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-11 13:38:01.000000000 +0300
+++ wireless-testing/net/mac80211/mlme.c	2009-06-11 18:08:39.000000000 +0300
@@ -2445,6 +2445,14 @@ void ieee80211_sta_req_auth(struct ieee8
 			ieee80211_set_disassoc(sdata, true, true,
 					       WLAN_REASON_DEAUTH_LEAVING);
 
+		if (ifmgd->ssid_len == 0) {
+			/*
+			 * Only allow association to be started if a valid SSID
+			 * is configured.
+			 */
+			return;
+		}
+
 		if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) ||
 		    ifmgd->state != IEEE80211_STA_MLME_ASSOCIATE)
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
 
-- 
Jouni Malinen                                            PGP id EFC895FA
