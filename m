Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([89.167.52.164]:48071 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551AbZEUUeG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 16:34:06 -0400
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?=
	<mirq-linux@rere.qmqm.pl>
To: netdev@vger.kernel.org
Message-ID: <6-1000-10527-1242938044-3360@rere.qmqm.pl>
In-Reply-To: <1-1000-10527-1242938044-3360@rere.qmqm.pl>
Subject: [PATCH 6/6 2.6.30-rc6] wireless: Use genl_register_family_with_ops()
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 May 2009 22:34:06 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use genl_register_family_with_ops() instead of a copy.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>

diff -urN linux-orig-mqbr/net/wireless/nl80211.c linux-mqbr/net/wireless/nl80211.c
--- linux-orig-mqbr/net/wireless/nl80211.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-mqbr/net/wireless/nl80211.c	2009-05-21 17:51:34.000000000 +0200
@@ -3395,18 +3395,13 @@
 
 int nl80211_init(void)
 {
-	int err, i;
+	int err;
 
-	err = genl_register_family(&nl80211_fam);
+	err = genl_register_family_with_ops(&nl80211_fam,
+		nl80211_ops, ARRAY_SIZE(nl80211_ops));
 	if (err)
 		return err;
 
-	for (i = 0; i < ARRAY_SIZE(nl80211_ops); i++) {
-		err = genl_register_ops(&nl80211_fam, &nl80211_ops[i]);
-		if (err)
-			goto err_out;
-	}
-
 	err = genl_register_mc_group(&nl80211_fam, &nl80211_config_mcgrp);
 	if (err)
 		goto err_out;
