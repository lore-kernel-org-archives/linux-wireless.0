Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56758 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2IKVSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 17:18:41 -0400
Received: by wibhi8 with SMTP id hi8so4366513wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 14:18:40 -0700 (PDT)
Subject: [PATCH] carl9170: fix spurious transmissions in sniffer mode
To: linux-wireless@vger.kernel.org
Cc: scchen@qca.qualcomm.com, linville@tuxdriver.com,
	johannes@sipsolutions.net, marco@tampabay.rr.com,
	janusz.dziedzic@gmail.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Tue, 11 Sep 2012 23:18:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201209112318.35334.chunkeey@googlemail.com> (sfid-20120911_231846_198454_A38F100C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several people have complained about an unusual
and undocumented feature of the AR9170 hardware:

In siffer mode, the hardware generates spurious
ACK frames for every received frame... even
broadcasts.

The reason for this malfunction is unknown:
<http://marc.info/?l=linux-wireless&m=134517238506033>
But there's a workaround: Instead of the special
sniffer mode, the hardware will be put into
station mode and all rx filters are disabled.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Marco Fonseca <marco@tampabay.rr.com>
Reported-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/mac.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index e3b1b6e..24d75ab 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -343,7 +343,24 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
 			break;
 		}
 	} else {
-		mac_addr = NULL;
+		/*
+		 * Enable monitor mode
+		 *
+		 * rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
+		 * sniffer |= AR9170_MAC_SNIFFER_ENABLE_PROMISC;
+		 *
+		 * When the hardware is in SNIFFER_PROMISC mode,
+		 * it generates spurious ACKs for every incoming
+		 * frame. This confuses every peer in the
+		 * vicinity and the network throughput will suffer
+		 * badly.
+		 *
+		 * Hence, the hardware will be put into station
+		 * mode and just the rx filters are disabled.
+		 */
+		cam_mode |= AR9170_MAC_CAM_STA;
+		rx_ctrl |= AR9170_MAC_RX_CTRL_PASS_TO_HOST;
+		mac_addr = common->macaddr;
 		bssid = NULL;
 	}
 	rcu_read_unlock();
@@ -355,8 +372,6 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
 		enc_mode |= AR9170_MAC_ENCRYPTION_RX_SOFTWARE;
 
 	if (ar->sniffer_enabled) {
-		rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
-		sniffer |= AR9170_MAC_SNIFFER_ENABLE_PROMISC;
 		enc_mode |= AR9170_MAC_ENCRYPTION_RX_SOFTWARE;
 	}
 
-- 
1.7.10.4

