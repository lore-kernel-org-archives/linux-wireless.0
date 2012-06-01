Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42272 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965374Ab2FAQPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 12:15:50 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/10] brcm80211: smac: remove DFS channels from 5GHz band
Date: Fri,  1 Jun 2012 11:15:31 -0500
Message-Id: <1338567336-12076-6-git-send-email-seth.forshee@canonical.com> (sfid-20120601_181623_797326_96553690)
In-Reply-To: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
References: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmsmac doesn't currently support DFS or radar detection. Until it does
we need to avoid using DFS channels, so for now remove them from the
list of supported channels in the 5GHZ band.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   48 --------------------
 1 file changed, 48 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 50f92a0..d2c0903 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -130,54 +130,6 @@ static struct ieee80211_channel brcms_5ghz_nphy_chantable[] = {
 	CHAN5GHZ(40, IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN5GHZ(44, IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(48, IEEE80211_CHAN_NO_HT40PLUS),
-	/* UNII-2 */
-	CHAN5GHZ(52,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(56,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(60,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(64,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	/* MID */
-	CHAN5GHZ(100,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(104,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(108,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(112,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(116,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(120,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(124,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(128,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(132,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40MINUS),
-	CHAN5GHZ(136,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS),
-	CHAN5GHZ(140,
-		 IEEE80211_CHAN_RADAR | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_HT40PLUS |
-		 IEEE80211_CHAN_NO_HT40MINUS),
 	/* UNII-3 */
 	CHAN5GHZ(149, IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(153, IEEE80211_CHAN_NO_HT40PLUS),
-- 
1.7.9.5

