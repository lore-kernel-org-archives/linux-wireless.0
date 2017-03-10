Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37709 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965046AbdCJJfZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 04:35:25 -0500
Received: by mail-wm0-f51.google.com with SMTP id n11so6232547wma.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 01:35:24 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        simon.wunderlich@openmesh.com,
        Benjamin Berg <benjamin@sipsolutions.net>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH] mac80211: Allow multiple listeners for management frames.
Date: Fri, 10 Mar 2017 10:34:54 +0100
Message-Id: <20170310093454.27664-1-sven.eckelmann@openmesh.com> (sfid-20170310_105054_629053_A05BBF88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin@sipsolutions.net>

Previously it was not possible to have multiple listeners for management
frames in userspace. This is a bit weird as multiple processes in
userspace might try to request management frame reporting but only
the first request was accepted.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
It is currently unknown why Benjamin never forwarded it. I am doing this
now to have a chance that this private patch doesn't have to be rebased
anymore by OpenMesh.
---
 net/wireless/mlme.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 22b3d9990065..f8ce18dcaa61 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -467,6 +467,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_mgmt_registration *reg, *nreg;
 	int err = 0;
+	int registered = 0;
 	u16 mgmt_type;
 
 	if (!wdev->wiphy->mgmt_stypes)
@@ -494,6 +495,12 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 		if (frame_type != le16_to_cpu(reg->frame_type))
 			continue;
 
+		registered = 1;
+
+		/* Allow duplicate registrations on different ports */
+		if (snd_portid != reg->nlportid)
+			continue;
+
 		if (memcmp(reg->match, match_data, mlen) == 0) {
 			err = -EALREADY;
 			break;
@@ -516,7 +523,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 	/* process all unregistrations to avoid driver confusion */
 	cfg80211_process_mlme_unregistrations(rdev);
 
-	if (rdev->ops->mgmt_frame_register)
+	if (rdev->ops->mgmt_frame_register && !registered)
 		rdev_mgmt_frame_register(rdev, wdev, frame_type, true);
 
 	return 0;
@@ -536,6 +543,26 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
 	spin_lock_bh(&wdev->mgmt_registrations_lock);
 
 	list_for_each_entry_safe(reg, tmp, &wdev->mgmt_registrations, list) {
+		struct cfg80211_mgmt_registration *inner;
+		int keep_registration = 0;
+
+		/* Do not remove registration as long as there is one other
+		 * registration for the frame type. Note that this registration
+		 * might even be on the same nlportid with a different match.
+		 */
+		list_for_each_entry(inner, &wdev->mgmt_registrations, list) {
+			if (inner == reg)
+				continue;
+
+			if (reg->frame_type == inner->frame_type) {
+				keep_registration = 1;
+				break;
+			}
+		}
+
+		if (keep_registration)
+			continue;
+
 		if (reg->nlportid != nlportid)
 			continue;
 
@@ -735,7 +762,6 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 			continue;
 
 		result = true;
-		break;
 	}
 
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
-- 
2.11.0
