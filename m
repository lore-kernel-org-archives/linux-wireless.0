Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:43316 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1CUXlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 19:41:09 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: fix adhoc mode NULL pointer issue
Date: Mon, 21 Mar 2011 16:44:38 -0700
Message-Id: <1300751079-20535-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300751079-20535-1-git-send-email-bzhao@marvell.com>
References: <1300751079-20535-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

mwifiex_cfg80211_assoc() handles both infra and adhoc modes.
"sme" parameter is from cfg80211 stack and only meaningful
to infra mode. For adhoc mode, NULL is passed to "sme" as a
dummy parameter. We should differentiate infra/adhoc modes
correctly to avoid access sme structure in adhoc mode.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   33 ++++++++++++++++---------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f4d240e..80f367f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1044,27 +1044,28 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 				mwifiex_channels_to_cfg80211_channel_type
 				(priv->adapter->chan_offset));
 
-	if (!sme && (mode != MWIFIEX_BSS_MODE_IBSS)) {
-		BUG_ON(sme == NULL);
-		return ret;
-	}
-
 	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);	/* Disable keys */
 
-	if (!sme && privacy) {
-		/*
-		 * Keep MWIFIEX_ENCRYPTION_MODE_WEP40 for now so that
-		 * the firmware can find a matching network from the
-		 * scan. cfg80211 doesnt not give us the encryption
-		 * mode at this stage so just setting it to wep here
-		 */
-		auth_type = MWIFIEX_AUTH_MODE_OPEN;
-		wpa_enabled = 0;
-		ret = mwifiex_set_auth(priv, MWIFIEX_ENCRYPTION_MODE_WEP104,
-							auth_type, wpa_enabled);
+	if (mode == MWIFIEX_BSS_MODE_IBSS) {
+		/* "privacy" is set only for ad-hoc mode */
+		if (privacy) {
+			/*
+			 * Keep MWIFIEX_ENCRYPTION_MODE_WEP104 for now so that
+			 * the firmware can find a matching network from the
+			 * scan. The cfg80211 does not give us the encryption
+			 * mode at this stage so just setting it to WEP here.
+			 */
+			wpa_enabled = 0;
+			auth_type = MWIFIEX_AUTH_MODE_OPEN;
+			ret = mwifiex_set_auth(priv,
+						MWIFIEX_ENCRYPTION_MODE_WEP104,
+						auth_type, wpa_enabled);
+		}
+
 		goto done;
 	}
 
+	/* Now handle infra mode. "sme" is valid for infra mode only */
 	if (sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC
 			|| sme->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
 		auth_type = MWIFIEX_AUTH_MODE_OPEN;
-- 
1.7.0.2

