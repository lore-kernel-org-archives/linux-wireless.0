Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:34511 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872Ab3KZPHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 10:07:40 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH-mac80211] cfg80211: disable CSA for all drivers
Date: Tue, 26 Nov 2013 16:07:26 +0100
Message-Id: <1385478446-27868-1-git-send-email-sw@simonwunderlich.de> (sfid-20131126_160751_461361_E4466B51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel switch announcement code has some major locking problems
which can cause a deadlock in worst case. A series of fixes has been
proposed, but these are non-trivial and need to be tested first.
Therefore disable CSA completely for 3.13.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
This is based on mac80211.git and should go into 3.13 only
---
 net/wireless/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index aff959e..507e71f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -451,6 +451,12 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
+	/*
+	 * There are major locking problems in nl80211/mac80211 for CSA,
+	 * disable for all drivers until this has been reworked.
+	 */
+	wiphy->flags &= ~WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+
 #ifdef CONFIG_PM
 	if (WARN_ON(wiphy->wowlan &&
 		    (wiphy->wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
-- 
1.7.10.4

