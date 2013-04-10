Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924Ab3DJTqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 15:46:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: andersk@mit.edu, dcbw@redhat.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3.9] mac80211: fix cfg80211 interaction on auth/assoc request
Date: Wed, 10 Apr 2013 21:46:34 +0200
Message-Id: <1365623194-1893-1-git-send-email-johannes@sipsolutions.net> (sfid-20130410_214648_317246_EC0A4E42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If authentication (or association with FT) is requested by
userspace, mac80211 currently doesn't tell cfg80211 that it
disconnected from the AP. That leaves inconsistent state:
cfg80211 thinks it's connected while mac80211 thinks it's
not. Typically this won't last long, as soon as mac80211
reports the new association to cfg80211 the old one goes
away. If, however, the new authentication or association
doesn't succeed, then cfg80211 will forever think the old
one still exists and will refuse attempts to authenticate
or associate with the AP it thinks it's connected to.

Anders reported that this leads to it taking a very long
time to reconnect to a network, or never even succeeding.
I tested this with an AP hacked to never respond to auth
frames, and one that works, and with just those two the
system never recovers because one won't work and cfg80211
thinks it's connected to the other so refuses connections
to it.

To fix this, simply make mac80211 tell cfg80211 when it is
no longer connected to the old AP, while authenticating or
associating to a new one.

Cc: stable@vger.kernel.org
Reported-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 82cc303..346ad4c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3964,8 +3964,16 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	/* prep auth_data so we don't go into idle on disassoc */
 	ifmgd->auth_data = auth_data;
 
-	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	if (ifmgd->associated) {
+		u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+				       WLAN_REASON_UNSPECIFIED,
+				       false, frame_buf);
+
+		__cfg80211_send_deauth(sdata->dev, frame_buf,
+				       sizeof(frame_buf));
+	}
 
 	sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
 
@@ -4025,8 +4033,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	if (ifmgd->associated) {
+		u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+				       WLAN_REASON_UNSPECIFIED,
+				       false, frame_buf);
+
+		__cfg80211_send_deauth(sdata->dev, frame_buf,
+				       sizeof(frame_buf));
+	}
 
 	if (ifmgd->auth_data && !ifmgd->auth_data->done) {
 		err = -EBUSY;
-- 
1.8.0

