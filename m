Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:45010 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762247AbYDURAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:03 -0400
Received: by nf-out-0910.google.com with SMTP id g13so577983nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 09:59:58 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 2/9] rt2x00: Remove DRIVER_SUPPORT_MIXED_INTERFACES
Date: Mon, 21 Apr 2008 18:59:54 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com>
In-Reply-To: <200804211858.46659.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804211859.54561.IvDoorn@gmail.com> (sfid-20080421_190104_321070_CC9FF0F5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A lot more is needed to support mixed interfaces then just this flag,
such things need new redesigns in rt2x00lib to actually make it happen.
So far there doesn't exist a Ralink chipset that can handle it, so
we might as well remove the flag for now and see what should be done
whenever a device appears that can handle it.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 -
 drivers/net/wireless/rt2x00/rt2x00mac.c |   11 +++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 57bdc15..7a23b00 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -621,7 +621,6 @@ enum rt2x00_flags {
 	/*
 	 * Driver features
 	 */
-	DRIVER_SUPPORT_MIXED_INTERFACES,
 	DRIVER_REQUIRE_FIRMWARE,
 	DRIVER_REQUIRE_BEACON_GUARD,
 	DRIVER_REQUIRE_ATIM_QUEUE,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index e46d406..e078e0a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -201,13 +201,12 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 		return -ENODEV;
 
 	/*
-	 * When we don't support mixed interfaces (a combination
-	 * of sta and ap virtual interfaces) then we can only
-	 * add this interface when the rival interface count is 0.
+	 * We don't support mixed combinations of sta and ap virtual
+	 * interfaces. We can only add this interface when the rival
+	 * interface count is 0.
 	 */
-	if (!test_bit(DRIVER_SUPPORT_MIXED_INTERFACES, &rt2x00dev->flags) &&
-	    ((conf->type == IEEE80211_IF_TYPE_AP && rt2x00dev->intf_sta_count) ||
-	     (conf->type != IEEE80211_IF_TYPE_AP && rt2x00dev->intf_ap_count)))
+	if ((conf->type == IEEE80211_IF_TYPE_AP && rt2x00dev->intf_sta_count) ||
+	    (conf->type != IEEE80211_IF_TYPE_AP && rt2x00dev->intf_ap_count))
 		return -ENOBUFS;
 
 	/*
-- 
1.5.4.5

