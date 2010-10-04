Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54264 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab0JDMcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 08:32:07 -0400
Date: Mon, 4 Oct 2010 14:31:46 +0200
From: Dan Carpenter <error27@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>, "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] ipw2200: check for allocation failures
Message-ID: <20101004123146.GC5692@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If kzalloc() fails then return should return with -ENOMEM.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I think the first allocation should get freed by free_libipw() but I
wasn't able to follow that code path far enough to verify...

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index cb2552a..d04d760 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11470,6 +11470,10 @@ static int ipw_net_init(struct net_device *dev)
 		bg_band->channels =
 			kzalloc(geo->bg_channels *
 				sizeof(struct ieee80211_channel), GFP_KERNEL);
+		if (!bg_band->channels) {
+			rc = -ENOMEM;
+			goto out;
+		}
 		/* translate geo->bg to bg_band.channels */
 		for (i = 0; i < geo->bg_channels; i++) {
 			bg_band->channels[i].band = IEEE80211_BAND_2GHZ;
@@ -11505,6 +11509,10 @@ static int ipw_net_init(struct net_device *dev)
 		a_band->channels =
 			kzalloc(geo->a_channels *
 				sizeof(struct ieee80211_channel), GFP_KERNEL);
+		if (!a_band->channels) {
+			rc = -ENOMEM;
+			goto out;
+		}
 		/* translate geo->bg to a_band.channels */
 		for (i = 0; i < geo->a_channels; i++) {
 			a_band->channels[i].band = IEEE80211_BAND_2GHZ;
