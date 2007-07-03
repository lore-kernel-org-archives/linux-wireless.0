Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:8238 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbXGCP1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:27:17 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH, take #2] libertas: remove unused adapter->prev_xx variables
Date: Tue, 3 Jul 2007 17:27:11 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200707031727.12013.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>

There were just used in some debug output, but nowhere else.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---

This is non-wordwrapped. Also, the linux-wireless-dev mailing list
didn't like the original subject.

 drivers/net/wireless/libertas/cmdresp.c |    9 ---------
 drivers/net/wireless/libertas/dev.h     |    4 ----
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 197d045..646b591 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -65,18 +65,9 @@ void libertas_mac_event_disconnected(wlan_private * priv)
 	            escape_essid(adapter->curbssparams.ssid,
 	                         adapter->curbssparams.ssid_len),
 	            adapter->curbssparams.ssid_len);
-	lbs_deb_cmd("previous SSID '%s', length %u\n",
-	            escape_essid(adapter->prev_ssid, adapter->prev_ssid_len),
-	            adapter->prev_ssid_len);
 
 	adapter->connect_status = LIBERTAS_DISCONNECTED;
 
-	/* Save previous SSID and BSSID for possible reassociation */
-	memcpy(&adapter->prev_ssid, &adapter->curbssparams.ssid,
-	       IW_ESSID_MAX_SIZE);
-	adapter->prev_ssid_len = adapter->curbssparams.ssid_len;
-	memcpy(adapter->prev_bssid, adapter->curbssparams.bssid, ETH_ALEN);
-
 	/* Clear out associated SSID and BSSID since connection is
 	 * no longer valid.
 	 */
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 7c565cb..7c0ee0f 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -257,10 +257,6 @@ struct _wlan_adapter {
 	/* IW_MODE_* */
 	u8 mode;
 
-	u8 prev_ssid[IW_ESSID_MAX_SIZE + 1];
-	u8 prev_ssid_len;
-	u8 prev_bssid[ETH_ALEN];
-
 	/* Scan results list */
 	struct list_head network_list;
 	struct list_head network_free_list;
-- 
1.5.2.1

