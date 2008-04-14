Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbYDOKat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 06:30:49 -0400
Subject: [PATCH] mac80211: allow WDS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 15:37:03 +0200
Message-Id: <1208180223.4111.64.camel@johannes.berg> (sfid-20080415_113207_717295_89E9D4FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows creating interfaces in WDS mode or switching
existing ones into WDS mode (both via cfg80211 and wext.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Not too useful without AP mode, but I see no reason to not allow WDS
(unlike AP where I do see reasons.) Maybe somebody can come up with a
different use for it...

 net/mac80211/cfg.c  |    2 ++
 net/mac80211/wext.c |    3 +++
 2 files changed, 5 insertions(+)

--- everything.orig/net/mac80211/cfg.c	2008-04-14 15:34:25.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-04-14 15:35:20.000000000 +0200
@@ -33,6 +33,8 @@ nl80211_type_to_mac80211_type(enum nl802
 	case NL80211_IFTYPE_MESH_POINT:
 		return IEEE80211_IF_TYPE_MESH_POINT;
 #endif
+	case NL80211_IFTYPE_WDS:
+		return IEEE80211_IF_TYPE_WDS;
 	default:
 		return IEEE80211_IF_TYPE_INVALID;
 	}
--- everything.orig/net/mac80211/wext.c	2008-04-14 15:33:27.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-04-14 15:35:20.000000000 +0200
@@ -236,6 +236,9 @@ static int ieee80211_ioctl_siwmode(struc
 	case IW_MODE_ADHOC:
 		type = IEEE80211_IF_TYPE_IBSS;
 		break;
+	case IW_MODE_REPEAT:
+		type = IEEE80211_IF_TYPE_WDS;
+		break;
 	case IW_MODE_MONITOR:
 		type = IEEE80211_IF_TYPE_MNTR;
 		break;


