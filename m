Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:58621 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbXE1Qm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2007 12:42:27 -0400
Message-Id: <20070528164200.990646275@localhost>
References: <20070528163845.448090722@localhost>
Date: Mon, 28 May 2007 09:38:47 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] hostap: Suppress broadcast if no stations are associated
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Roskin <proski@gnu.org>

This may be useful in mesh setups when most stations act as repeaters only.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Jouni Malinen <j@w1.fi>


Index: linux-2.6/drivers/net/wireless/hostap/hostap_ap.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/hostap/hostap_ap.c
+++ linux-2.6/drivers/net/wireless/hostap/hostap_ap.c
@@ -2704,6 +2704,8 @@ ap_tx_ret hostap_handle_sta_tx(local_inf
 
 	if (hdr->addr1[0] & 0x01) {
 		/* broadcast/multicast frame - no AP related processing */
+		if (local->ap->num_sta <= 0)
+			ret = AP_TX_DROP;
 		goto out;
 	}
 

--

-- 
Jouni Malinen                                            PGP id EFC895FA
