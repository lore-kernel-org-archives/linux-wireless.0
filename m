Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3AKNnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 08:43:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: cedric.debarge@acksys.fr, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix FT roaming
Date: Fri, 11 Jan 2013 14:43:39 +0100
Message-Id: <1357911819-9504-1-git-send-email-johannes@sipsolutions.net> (sfid-20130111_144321_886241_D82FE615)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During FT roaming, wpa_supplicant attempts to set the
key before association. This used to be rejected, but
as a side effect of my commit 66e67e418908442389d3a9e
("mac80211: redesign auth/assoc") the key was accepted
causing hardware crypto to not be used for it as the
station isn't added to the driver yet.

It would be possible to accept the key and then add it
to the driver when the station has been added. However,
this may run into issues with drivers using the state-
based station adding if they accept the key only after
association like it used to be.

For now, revert to the behaviour from before the auth
and assoc change.

Cc: stable@vger.kernel.org
Reported-by: Cédric Debarge <cedric.debarge@acksys.fr>
Tested-by: Cédric Debarge <cedric.debarge@acksys.fr>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7d290bc..f83e5b6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -164,7 +164,17 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			sta = sta_info_get(sdata, mac_addr);
 		else
 			sta = sta_info_get_bss(sdata, mac_addr);
-		if (!sta) {
+		/*
+		 * The ASSOC test makes sure the driver is ready to
+		 * receive the key. When wpa_supplicant has roamed
+		 * using FT, it attempts to set the key before
+		 * association has completed, this rejects that attempt
+		 * so it will set the key again after assocation.
+		 *
+		 * TODO: accept the key if we have a station entry and
+		 *       add it to the device after the station.
+		 */
+		if (!sta || !test_sta_flag(sta, WLAN_STA_ASSOC)) {
 			ieee80211_key_free(sdata->local, key);
 			err = -ENOENT;
 			goto out_unlock;
-- 
1.8.0

