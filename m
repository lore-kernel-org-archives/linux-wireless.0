Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760652AbXHOPBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 11:01:23 -0400
Message-Id: <20070815145046.815119000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>
Subject: [PATCH 12/20] mac80211: fix preamble setting
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like in commit 28487a90 the condition was unintentionally
negated by moving some code, fix it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>

---
 net/mac80211/ieee80211_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-15 13:39:52.366520121 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-15 13:39:52.926520121 +0200
@@ -1962,7 +1962,7 @@ static int ieee80211_ioctl_prism2_param(
 		break;
 
 	case PRISM2_PARAM_PREAMBLE:
-		if (sdata->type != IEEE80211_IF_TYPE_AP) {
+		if (sdata->type == IEEE80211_IF_TYPE_AP) {
 			sdata->short_preamble = !!value;
 			ieee80211_erp_info_change_notify(dev, IEEE80211_ERP_CHANGE_PREAMBLE);
 		} else {

-- 

