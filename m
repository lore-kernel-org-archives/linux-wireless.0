Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:18912 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbcC2Jfa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 05:35:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCHv3 RESEND 11/11] cfg80211: allow to tie the NAN instance to the owner
Date: Tue, 29 Mar 2016 12:35:09 +0300
Message-Id: <1459244109-16038-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160329_113535_864829_5685C870)
In-Reply-To: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow the user space application that starts NAN to
forbid any other socket to add or remove functions.
Notifications will be sent to the socket that started
the NAN interface only.

By default, keep the current behavior: events are sent
in multicast and any application can add / remove
functions.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/uapi/linux/nl80211.h |  7 +++++++
 net/wireless/nl80211.c       | 26 ++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f4a2e46..c9867ae 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -849,6 +849,7 @@
  *	This cookie may be used in NAN events even before the command
  *	returns, so userspace shouldn't process NAN events until it processes
  *	the response to this command.
+ *	Look at %NL80211_ATTR_SOCKET_OWNER as well.
  * @NL80211_CMD_RM_NAN_FUNCTION: Remove a NAN function by cookie.
  *	This command is also used as a notification sent when a NAN function is
  *	terminated. This will contain a %NL80211_ATTR_NAN_FUNC_INST_ID
@@ -1760,6 +1761,12 @@ enum nl80211_commands {
  *	regulatory indoor configuration would be owned by the netlink socket
  *	that configured the indoor setting, and the indoor operation would be
  *	cleared when the socket is closed.
+ *	If set during NAN interface creation, the interface will be destroyed
+ *	if the socket is closed just like any other interface. Moreover, only
+ *	the netlink socket that created the interface will be allowed to add
+ *	and remove functions. NAN notifications will be sent in unicast to that
+ *	socket. Without this attribute, any socket can add functions and the
+ *	notifications will be sent to the %NL80211_MCGRP_NAN multicast group.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4872349..b42c45f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10304,6 +10304,10 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 
 	func.cookie = wdev->wiphy->cookie_counter++;
 
+	if (wdev->owner_nlportid &&
+	    wdev->owner_nlportid != info->snd_portid)
+		return -ENOTCONN;
+
 	err = nla_parse(tb, NL80211_NAN_FUNC_ATTR_MAX,
 			nla_data(info->attrs[NL80211_ATTR_NAN_FUNC]),
 			nla_len(info->attrs[NL80211_ATTR_NAN_FUNC]),
@@ -10487,6 +10491,10 @@ static int nl80211_nan_rm_func(struct sk_buff *skb,
 	if (!info->attrs[NL80211_ATTR_COOKIE])
 		return -EINVAL;
 
+	if (wdev->owner_nlportid &&
+	    wdev->owner_nlportid != info->snd_portid)
+		return -ENOTCONN;
+
 	cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
 
 	rdev_rm_nan_func(rdev, wdev, cookie);
@@ -10581,8 +10589,13 @@ void cfg80211_nan_match(struct wireless_dev *wdev,
 	nla_nest_end(msg, match_attr);
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
-				NL80211_MCGRP_NAN, gfp);
+	if (!wdev->owner_nlportid)
+		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
+					msg, 0, NL80211_MCGRP_NAN, gfp);
+	else
+		genlmsg_unicast(wiphy_net(&rdev->wiphy), msg,
+				wdev->owner_nlportid);
+
 	return;
 
 nla_put_failure:
@@ -10627,8 +10640,13 @@ void cfg80211_nan_func_terminated(struct wireless_dev *wdev,
 
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
-				NL80211_MCGRP_NAN, gfp);
+	if (!wdev->owner_nlportid)
+		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
+					msg, 0, NL80211_MCGRP_NAN, gfp);
+	else
+		genlmsg_unicast(wiphy_net(&rdev->wiphy), msg,
+				wdev->owner_nlportid);
+
 	return;
 
 nla_put_failure:
-- 
2.5.0

