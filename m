Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:28734 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZIKIOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 04:14:24 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: minimal error handling for wext-compat freq scanning
Date: Fri, 11 Sep 2009 10:13:55 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909111013.55263.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: linux-wl/net/wireless/scan.c
===================================================================
--- linux-wl.orig/net/wireless/scan.c	2009-09-11 09:05:39.000000000 +0200
+++ linux-wl/net/wireless/scan.c	2009-09-11 09:05:42.000000000 +0200
@@ -680,6 +680,11 @@ int cfg80211_wext_siwscan(struct net_dev
 		err = -EINVAL;
 		goto out;
 	}
+	/* No channels found? */
+	if (!i) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	/* Set real number of channels specified in creq->channels[] */
 	creq->n_channels = i;

-- 
http://www.holgerschurig.de
