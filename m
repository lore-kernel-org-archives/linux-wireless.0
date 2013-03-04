Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:37307 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3CDVIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 16:08:00 -0500
Received: by mail-pb0-f48.google.com with SMTP id wy12so3404999pbc.7
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 13:07:59 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolution.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 4/5] nl80211: user_mpm overrides auto_open_plinks
Date: Mon,  4 Mar 2013 13:06:13 -0800
Message-Id: <1362431174-4747-4-git-send-email-thomas@cozybit.com> (sfid-20130304_220804_067715_233D7A00)
In-Reply-To: <1362431174-4747-1-git-send-email-thomas@cozybit.com>
References: <1362431174-4747-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the user requested a userspace MPM, automatically
disable auto_open_plinks to fully disable the kernel MPM.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/uapi/linux/nl80211.h |    6 ++++--
 net/wireless/nl80211.c       |    3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 8134c6a..79da871 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2467,8 +2467,10 @@ enum nl80211_mesh_power_mode {
  * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
  *	point.
  *
- * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
- *	open peer links when we detect compatible mesh peers.
+ * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically open
+ *	peer links when we detect compatible mesh peers. Disabled if
+ *	@NL80211_MESH_SETUP_USERSPACE_MPM or @NL80211_MESH_SETUP_USERSPACE_AMPE are
+ *	set.
  *
  * @NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES: the number of action frames
  *	containing a PREQ that an MP can send to a particular destination (path
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index eca897a..ddd251b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7427,6 +7427,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
+	if (setup.user_mpm)
+		cfg.auto_open_plinks = false;
+
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
 		err = nl80211_parse_chandef(rdev, info, &setup.chandef);
 		if (err)
-- 
1.7.10.4

