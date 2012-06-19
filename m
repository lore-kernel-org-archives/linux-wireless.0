Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:65292 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2FSV7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 17:59:41 -0400
Received: from mail0.frost.chambana.net (mail0.frost.chambana.net [209.66.96.68])
	by www19.servergod.com (Postfix) with ESMTP id A653C11FFE4
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 14:59:41 -0700 (PDT)
Received: by mail0.frost.chambana.net (Postfix) with SMTP id 5D19359A05D
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 21:59:41 +0000
From: Will Hawkins <hawkinsw@opentechinstitute.org>
To: hawkinsw@opentechinstitute.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 1/3] mac80211: Track auth frame registrations on IBSS ifaces
Date: Tue, 19 Jun 2012 17:59:12 -0400
Message-Id: <88045ffa83c9b4defb7b5eca98bc389ed6c2c5c1.1340142553.git.hawkinsw@opentechinstitute.org> (sfid-20120619_235945_809890_5A5864F9)
In-Reply-To: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
References: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
In-Reply-To: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
References: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track userspace registrations for authentication
frames received on an IBSS interface. This field
will be used to decide whether or not to send
"open system" authentication frames when a new
station joins an adhoc network.

Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
---
 net/mac80211/cfg.c         |   10 ++++++++++
 net/mac80211/ieee80211_i.h |    1 +
 2 files changed, 11 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 498c94e..e00a696 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2486,6 +2486,16 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 					  u16 frame_type, bool reg)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && 
+	    (frame_type == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_AUTH))) {
+		struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+		if (reg)
+			ifibss->auth_frame_registrations++;
+		else if (reg > 0)
+			ifibss->auth_frame_registrations--;
+	}
 
 	if (frame_type != (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_REQ))
 		return;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e6cbf5b..599f9fd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -508,6 +508,7 @@ struct ieee80211_if_ibss {
 	bool privacy;
 
 	bool control_port;
+	unsigned int auth_frame_registrations;
 
 	u8 bssid[ETH_ALEN] __aligned(2);
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
-- 
1.7.9.5


