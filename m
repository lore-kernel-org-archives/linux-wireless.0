Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep27-int.chello.at ([62.179.121.47]:57846 "EHLO
	viefep27-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYIOPur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:50:47 -0400
Received: from gollum.odi.ch ([84.74.148.76]) by viefep27-int.chello.at
          (InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
          id <20080915155043.FDFN184.viefep27-int.chello.at@gollum.odi.ch>
          for <linux-wireless@vger.kernel.org>;
          Mon, 15 Sep 2008 17:50:43 +0200
Received: from [192.168.111.10] (mithril [192.168.111.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gollum.odi.ch (Postfix) with ESMTPSA id E8DBC42FC
	for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 17:50:42 +0200 (CEST)
Message-ID: <48CE8452.9080604@odi.ch> (sfid-20080915_175050_484202_3CD78757)
Date: Mon, 15 Sep 2008 17:50:42 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] Don't destroy authentication algorithm before authenticating.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reset_auth is called before each authentication try. So it should not destroy
the auth_alg that was set before.

NB: this may have side-effects with automatic algorithm selection if AP responds 
with alg not supported.

Signed-off-by: Ortwin Glueck <odi@odi.ch>
---
  net/mac80211/mlme.c |   10 +---------
  1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 902cac1..5dbe012 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3420,6 +3420,7 @@ static void ieee80211_sta_reset_auth(struct net_device *dev,
  				     struct ieee80211_if_sta *ifsta)
  {
  	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);

  	if (local->ops->reset_tsf) {
  		/* Reset own TSF to allow time synchronization work. */
@@ -3428,15 +3429,6 @@ static void ieee80211_sta_reset_auth(struct net_device *dev,

  	ifsta->wmm_last_param_set = -1; /* allow any WMM update */

-
-	if (ifsta->auth_algs & IEEE80211_AUTH_ALG_OPEN)
-		ifsta->auth_alg = WLAN_AUTH_OPEN;
-	else if (ifsta->auth_algs & IEEE80211_AUTH_ALG_SHARED_KEY)
-		ifsta->auth_alg = WLAN_AUTH_SHARED_KEY;
-	else if (ifsta->auth_algs & IEEE80211_AUTH_ALG_LEAP)
-		ifsta->auth_alg = WLAN_AUTH_LEAP;
-	else
-		ifsta->auth_alg = WLAN_AUTH_OPEN;
  	ifsta->auth_transaction = -1;
  	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
  	ifsta->auth_tries = ifsta->assoc_tries = 0;
-- 
1.5.6.4
