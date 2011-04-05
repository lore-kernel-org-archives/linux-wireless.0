Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45867 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1DECQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 22:16:29 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so6482252iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 19:16:29 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v7 03/10] mac80211: Support userspace mesh authentication
Date: Mon,  4 Apr 2011 18:15:33 -0700
Message-Id: <1301966140-26080-4-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301966140-26080-1-git-send-email-thomas@cozybit.com>
References: <1301966140-26080-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, disallow joining a secure mesh if the wiphy does not support
authentication.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/main.c |    4 ++++
 net/wireless/mesh.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 562d298..0d3c16e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -759,6 +759,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	/* mesh depends on Kconfig, but drivers should set it if they want */
 	local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
 #endif
+	/* if the underlying driver supports mesh, mac80211 will (at least)
+	 * provide routing of mesh authentication frames to userspace */
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_MESH_POINT))
+		local->hw.wiphy->flags |= WIPHY_FLAG_MESH_AUTH;
 
 	/* mac80211 supports control port protocol changing */
 	local->hw.wiphy->flags |= WIPHY_FLAG_CONTROL_PORT_PROTOCOL;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0d4b226..0e5c122 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -72,6 +72,10 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_MESH_AUTH) &&
+	      setup->is_secure)
+		return -EOPNOTSUPP;
+
 	if (wdev->mesh_id_len)
 		return -EALREADY;
 
-- 
1.7.4.1

