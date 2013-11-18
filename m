Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63591 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3KRRLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:11:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 01/12 NEXT] rtlwifi: rtl8192c: Prevent reconnect attempts if not connected
Date: Mon, 18 Nov 2013 11:11:25 -0600
Message-Id: <1384794696-20314-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131118_181158_018258_8D70E006)
In-Reply-To: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver has a watchdog timer that attempts to reconnect when beacon frames
are not seen for 6 seconds. This patch disables that reconnect whenever the
device has never been connected.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -1437,7 +1437,8 @@ void rtl_watchdog_wq_callback(void *data
 			/* if we can't recv beacon for 6s, we should
 			 * reconnect this AP
 			 */
-			if (rtlpriv->link_info.roam_times >= 3) {
+			if ((rtlpriv->link_info.roam_times >= 3) &&
+			    !is_zero_ether_addr(rtlpriv->mac80211.bssid)) {
 				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 					 "AP off, try to reconnect now\n");
 				rtlpriv->link_info.roam_times = 0;
