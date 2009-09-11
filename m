Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([85.199.173.189]:59485 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZIKIWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 04:22:32 -0400
Received: from mx51.mymxserver.com (mail5104.mittwald.de [172.16.51.4])
	by emita2.mittwald.de (Postfix) with ESMTP id 994285FD042
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2009 10:14:32 +0200 (CEST)
From: Holger Schurig <h.schurig@mn-solutions.de>
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: use cfg80211_wext_freq() for freq conversion
Date: Fri, 11 Sep 2009 10:13:53 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909111013.53585.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WEXT's "struct iw_freq" can also be used to handle a channel. This patch now
uses cfg80211_wext_freq() instead of hand-converting the frequency. That
allows user-space to specify channels as well, like with SIOCSIWFREQ.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: linux-wl/net/wireless/scan.c
===================================================================
--- linux-wl.orig/net/wireless/scan.c	2009-09-11 09:05:27.000000000 +0200
+++ linux-wl/net/wireless/scan.c	2009-09-11 09:05:39.000000000 +0200
@@ -662,7 +662,7 @@ int cfg80211_wext_siwscan(struct net_dev
 				int k;
 				int wiphy_freq = wiphy->bands[band]->channels[j].center_freq;
 				for (k = 0; k < wreq->num_channels; k++) {
-					int wext_freq = wreq->channel_list[k].m / 100000;
+					int wext_freq = cfg80211_wext_freq(wiphy, &wreq->channel_list[k]);
 					if (wext_freq == wiphy_freq)
 						goto wext_freq_found;
 				}


-- 
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Geschäftsführer: P.Schrittenlocher
