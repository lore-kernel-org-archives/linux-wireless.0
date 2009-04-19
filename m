Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbZDSLWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 07:22:18 -0400
Subject: [PATCH] mac80211: fix basic rate bitmap calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 13:22:11 +0200
Message-Id: <1240140131.25826.4.camel@johannes.local> (sfid-20090419_132225_519575_99DA7550)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    commit d61272cbb35fa1c08fe94898583d880256f2dbd3
    Author: Tomas Winkler <tomas.winkler@intel.com>
    Date:   Thu Oct 30 17:08:08 2008 +0200

        mac80211: fix basic rates setting from association response
        
        In previous code all the rates were marked as basic.
        
        Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
        Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
        Signed-off-by: John W. Linville <linville@tuxdriver.com>

introduced a copy/paste error (see patch).

Unfortunately, this not just leads to wrong data being passed
to the driver but is remotely exploitable for some hardware or
driver combinations.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org [2.6.29]
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-19 12:27:46.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-19 12:27:51.000000000 +0200
@@ -1577,7 +1577,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	for (i = 0; i < elems.ext_supp_rates_len; i++) {
 		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
-		bool is_basic = !!(elems.supp_rates[i] & 0x80);
+		bool is_basic = !!(elems.ext_supp_rates[i] & 0x80);
 
 		if (rate > 110)
 			have_higher_than_11mbit = true;


