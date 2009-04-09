Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323AbZDIH4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 03:56:09 -0400
Subject: [PATCH] fix iwl3945 registration regression
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: reinette.chatre@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <87ljqamktq.fsf@litku.valot.fi> (sfid-20090409_075706_696359_FC064489)
References: <87ljqamktq.fsf@litku.valot.fi>
	 (sfid-20090409_075706_696359_FC064489)
Content-Type: text/plain
Date: Thu, 09 Apr 2009 09:56:02 +0200
Message-Id: <1239263762.32594.19.camel@johannes.local> (sfid-20090409_095621_484226_6C688CE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot that iwl3945 registration is separate from iwlagn.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Hi Kalle, Reinette,

This looks like my mistake, sorry!

> [   17.489314] WARNING: at net/wireless/core.c:291 wiphy_register+0xa7/0x1bf [cfg80211]()

> And the warning from code:
> 
> 	if (WARN_ON(wiphy->max_scan_ssids < 1))
> 		return -EINVAL;

I thought 3945 were already unified so that the setup code was common,
but it turns out not to be. This patch will fix it.

Alternatively the scanning rework patches you (Reinette) have will also
fix it -- do you just want to send those to John instead?

johannes

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-09 09:53:35.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-09 09:53:57.000000000 +0200
@@ -4913,6 +4913,8 @@ static int iwl3945_setup_mac(struct iwl_
 
 	hw->wiphy->custom_regulatory = true;
 
+	hw->wiphy->max_scan_ssids = 1; /* WILL FIX */
+
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 


