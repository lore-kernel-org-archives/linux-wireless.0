Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759AbZCUQj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 12:39:27 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ll4EF-0004MJ-MW
	for linux-wireless@vger.kernel.org; Sat, 21 Mar 2009 17:39:24 +0100
Subject: [RFT] mac80211: allow mode changes while interface is up
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 17:39:23 +0100
Message-Id: <1237653563.5100.309.camel@johannes.local> (sfid-20090321_173939_639387_E07A8200)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It might be nicer sometimes to allow mode changes while the
interface is up, e.g. from managed to ibss mode, so that IP
configuration is retained. This patch changes mac80211 to
support that, it effectively internally behaves as though
you had actually done a down/change/up cycle.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
COMPLETELY UNTESTED. If anyone needs this functionality
please test and adopt this patch -- I have no interest in
pushing it into the kernel.

 net/mac80211/iface.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2009-03-21 17:20:23.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-03-21 17:26:59.000000000 +0100
@@ -749,24 +749,22 @@ static void ieee80211_setup_sdata(struct
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type)
 {
-	ASSERT_RTNL();
+	int ret = 0;
+	bool running = false;
+	enum nl80211_iftype oldtype;
 
-	if (type == sdata->vif.type)
-		return 0;
+	ASSERT_RTNL();
 
 	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
 	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
 	    type == NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
-	/*
-	 * We could, here, on changes between IBSS/STA/MESH modes,
-	 * invoke an MLME function instead that disassociates etc.
-	 * and goes into the requested mode.
-	 */
+	oldtype = sdata->vif.type;
+	running = netif_running(sdata->dev);
 
-	if (netif_running(sdata->dev))
-		return -EBUSY;
+	if (running)
+		ieee80211_stop(sdata->dev);
 
 	/* Purge and reset type-dependent state. */
 	ieee80211_teardown_sdata(sdata->dev);
@@ -778,7 +776,23 @@ int ieee80211_if_change_type(struct ieee
 			sdata->local->hw.conf.channel->band);
 	sdata->drop_unencrypted = 0;
 
-	return 0;
+	if (running) {
+		ret = ieee80211_open(sdata->dev);
+		if (ret) {
+			/*
+			 * ieee80211_open could fail, for example if the user
+			 * wants to have an interface combination now that we
+			 * do not support -- in that case roll back. This has
+			 * to succeed unless we have a driver/mac80211 bug,
+			 * since the interface was there before!
+			 */
+			ieee80211_teardown_sdata(sdata->dev);
+			ieee80211_setup_sdata(sdata, oldtype);
+			WARN_ON(ieee80211_open(sdata->dev));
+		}
+	}
+
+	return ret;
 }
 
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,


