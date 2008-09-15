Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep27-int.chello.at ([62.179.121.47]:57593 "EHLO
	viefep27-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYIOPrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:47:15 -0400
Received: from gollum.odi.ch ([84.74.148.76]) by viefep27-int.chello.at
          (InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
          id <20080915154711.FCVE184.viefep27-int.chello.at@gollum.odi.ch>
          for <linux-wireless@vger.kernel.org>;
          Mon, 15 Sep 2008 17:47:11 +0200
Received: from [192.168.111.10] (mithril [192.168.111.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gollum.odi.ch (Postfix) with ESMTPSA id B1B9A235A17
	for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 17:47:10 +0200 (CEST)
Message-ID: <48CE837E.2010109@odi.ch> (sfid-20080915_174719_472906_26C0ABC9)
Date: Mon, 15 Sep 2008 17:47:10 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: Support iwconfig enc restricted with WEP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 code doesn't handle WEP with shared keys correctly. Using the ath9k 
driver on my MacBook I am unable to put the driver into restricted mode (shared 
key). It stays in open mode. That is the following command has no effect: 
iwconfig wlan0 enc restricted. I can also confirm this when looking at the 
authentication packets that go over the air: they are sent with the open flag, 
and not the shared key flag.

Signed-off-by: Ortwin Glueck <odi@odi.ch>
---
  net/mac80211/wext.c |   12 ++++++++++++
  1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 34fa8ed..645c276 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -929,6 +929,18 @@ static int ieee80211_ioctl_siwencode(struct net_device *dev,
  	else
  		idx--;

+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+		if (erq->flags & IW_ENCODE_OPEN) {
+			printk("wext: open\n");
+			ifsta->auth_alg = WLAN_AUTH_OPEN;
+		}
+		else if (erq->flags & IW_ENCODE_RESTRICTED) {
+			printk("wext: shared key\n");
+			ifsta->auth_alg = WLAN_AUTH_SHARED_KEY;
+		}
+	}
+
  	if (erq->flags & IW_ENCODE_DISABLED)
  		remove = 1;
  	else if (erq->length == 0) {
-- 
1.5.6.4
