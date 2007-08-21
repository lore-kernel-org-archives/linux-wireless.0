Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761408AbXHUPQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:16:04 -0400
Message-Id: <20070821150038.987283000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>
Subject: [PATCH 02/27] mac80211: fix preamble setting
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

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-21 14:39:16.465923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-21 14:39:42.055923881 +0200
@@ -2191,7 +2191,7 @@ static int ieee80211_ioctl_prism2_param(
 		break;
 
 	case PRISM2_PARAM_PREAMBLE:
-		if (sdata->type != IEEE80211_IF_TYPE_AP) {
+		if (sdata->type == IEEE80211_IF_TYPE_AP) {
 			sdata->short_preamble = !!value;
 			ieee80211_erp_info_change_notify(dev, IEEE80211_ERP_CHANGE_PREAMBLE);
 		} else {

-- 

