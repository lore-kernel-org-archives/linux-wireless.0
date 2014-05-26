Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:59417 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaEZMTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 08:19:17 -0400
Received: from ni.piap.pl (localhost.localdomain [127.0.0.1])
	by ni.piap.pl (Postfix) with ESMTP id B74E2440E93
	for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 14:19:15 +0200 (CEST)
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 26 May 2014 14:14:46 +0200
MIME-Version: 1.0
Message-ID: <m361ksvirt.fsf@t19.piap.pl> (sfid-20140526_141920_406189_96CE4710)
Content-Type: text/plain; charset=utf-8
Subject: [PATCH v3.15-rcX] Fix IBSS join by initializing last_scan_completed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this fix, freshly rebooted Linux creates a new IBSS, instead
of joining existing one. Only when jiffies counter overflows after
5 minutes the IBSS can be successfully joined.

Intel Wireless 7260 PCIe.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1648,6 +1648,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->u.ibss.control_port = params->control_port;
 	sdata->u.ibss.userspace_handles_dfs = params->userspace_handles_dfs;
 	sdata->u.ibss.basic_rates = params->basic_rates;
+	sdata->u.ibss.last_scan_completed = jiffies;
 
 	/* fix basic_rates if channel does not support these rates */
 	rate_flags = ieee80211_chandef_rate_flags(&params->chandef);

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
