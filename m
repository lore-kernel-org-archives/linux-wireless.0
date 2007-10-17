Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbXJQTrQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 15:47:16 -0400
Subject: [PATCH] libertas: fix debug output format warning
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 15:47:01 -0400
Message-Id: <1192650421.14276.24.camel@localhost.localdomain> (sfid-20071017_204720_514010_E015AADC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 4c37834..0a0bf66 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -890,7 +890,7 @@ int wlan_scan_networks(wlan_private * priv,
 	lbs_deb_scan("The scan table contains:\n");
 	list_for_each_entry (iter_bss, &adapter->network_list, list) {
 		lbs_deb_scan("scan %02d, " MAC_FMT ", RSSI, %d, SSID '%s'\n",
-		       i++, iter_bss->bssid, (s32) iter_bss->rssi,
+		       i++, MAC_ARG(iter_bss->bssid), (s32) iter_bss->rssi,
 		       escape_essid(iter_bss->ssid, iter_bss->ssid_len));
 	}
 	mutex_unlock(&adapter->lock);

