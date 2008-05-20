Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ensim03.bon.m2soft.com ([195.38.20.12]:35416 "EHLO
	ensim03.bon.m2soft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbYETQuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 12:50:09 -0400
Date: Tue, 20 May 2008 18:42:54 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] net/mac80211: always true conditionals
Message-ID: <20080520184254.0804e77b@lucky.kitzblitz> (sfid-20080520_185016_426473_D6DB64EB)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct always true conditionals.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---

 net/mac80211/cfg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/cfg.c	2008-04-17 04:49:44.000000000 +0200
+++ b/net/mac80211/cfg.c	2008-05-20 16:03:29.000000000 +0200
@@ -558,7 +558,7 @@
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
-		if (sdata->vif.type != IEEE80211_IF_TYPE_VLAN ||
+		if (sdata->vif.type != IEEE80211_IF_TYPE_VLAN &&
 		    sdata->vif.type != IEEE80211_IF_TYPE_AP)
 			return -EINVAL;
 	} else
@@ -621,7 +621,7 @@
 	if (params->vlan && params->vlan != sta->dev) {
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
-		if (vlansdata->vif.type != IEEE80211_IF_TYPE_VLAN ||
+		if (vlansdata->vif.type != IEEE80211_IF_TYPE_VLAN &&
 		    vlansdata->vif.type != IEEE80211_IF_TYPE_AP)
 			return -EINVAL;
 
