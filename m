Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46194 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbXBWAMP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 19:12:15 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1N0CDhB022697
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2007 16:12:14 -0800
Received: from freekitty (unknown-230.office.pdx.osdl.net [10.8.0.230])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l1N0CDKA030536
	for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2007 16:12:13 -0800
Date: Thu, 22 Feb 2007 16:11:02 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] bcm43xx: build failure
Message-ID: <20070222161102.76a926e5@freekitty>
In-Reply-To: <20070222161014.62d064a6@freekitty>
References: <20070222161014.62d064a6@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like the ssi field changed.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
---
 drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
index cdce227..5c21b27 100644
--- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
@@ -3681,7 +3681,7 @@ static int bcm43xx_wireless_init(struct 
 		    IEEE80211_HW_MONITOR_DURING_OPER |
 		    IEEE80211_HW_DEVICE_HIDES_WEP |
 		    IEEE80211_HW_WEP_INCLUDE_IV;
-	hw->maxssi = BCM43xx_RX_MAX_SSI;
+	hw->max_rssi = BCM43xx_RX_MAX_SSI;
 	hw->queues = 1;
 	hw->dev = &dev->dev;
 	if (is_valid_ether_addr(sprom->r1.et1mac)) {
-- 
1.4.1

