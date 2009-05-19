Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbZESTNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 15:13:25 -0400
Subject: [PATCH] mac80211: don't try to do anything on unchanged genIE
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Tue, 19 May 2009 21:12:52 +0200
Message-Id: <1242760372.4797.70.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the genIE hasn't changed there's no reason to kick
the state machine since it won't be able to do anything
new -- doing this decreases the useless work we do for
reassociating because if we do kick the state machine
it will try to find a usable BSS but there might not be
one because wpa_supplicant will only change the BSSID
a little later.

In a sense this is a workaround for userspace behaviour,
but on the other hand userspace cannot really keep track
of what the kernel currently has for genIE since any
process could have changed that while wpa_supplicant
wasn't looking.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    4 ++++
 net/mac80211/wext.c |    5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-19 21:01:09.923912895 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-19 21:01:37.662665272 +0200
@@ -2496,6 +2496,10 @@ int ieee80211_sta_set_extra_ie(struct ie
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (len == ifmgd->extra_ie_len &&
+	    !memcmp(ifmgd->extra_ie, ie, len))
+		return -EALREADY;
+
 	kfree(ifmgd->extra_ie);
 	if (len == 0) {
 		ifmgd->extra_ie = NULL;
--- wireless-testing.orig/net/mac80211/wext.c	2009-05-19 21:01:22.739788309 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-05-19 21:01:37.665663772 +0200
@@ -37,12 +37,13 @@ static int ieee80211_ioctl_siwgenie(stru
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		int ret = ieee80211_sta_set_extra_ie(sdata, extra, data->length);
-		if (ret)
+		if (ret && ret != -EALREADY)
 			return ret;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
-		ieee80211_sta_req_auth(sdata);
+		if (ret != -EALREADY)
+			ieee80211_sta_req_auth(sdata);
 		return 0;
 	}
 


