Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754872AbcKBOMd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:12:33 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/10] rt2800: use RTS/CTS protection instead of CTS-to-self
Date: Wed,  2 Nov 2016 15:11:03 +0100
Message-Id: <1478095865-8651-9-git-send-email-sgruszka@redhat.com> (sfid-20161102_151237_253006_B5998830)
In-Reply-To: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change default to RTS/CTS protection. This has a cost of transmitting
one more control frame (RTS) however protect us from traffic from
hidden node.

On station mode will use CTS-to-self if AP will configure that
for the network.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 812f8e7..57bfec4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1621,7 +1621,7 @@ static void rt2800_config_ht_opmode(struct rt2x00_dev *rt2x00dev,
 		 * => Protect all HT40 transmissions.
 		 */
 		mm20_mode = gf20_mode = 0;
-		mm40_mode = gf40_mode = 2;
+		mm40_mode = gf40_mode = 1;
 
 		break;
 	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
@@ -1644,7 +1644,7 @@ static void rt2800_config_ht_opmode(struct rt2x00_dev *rt2x00dev,
 		 * Legacy STAs are present
 		 * => Protect all HT transmissions.
 		 */
-		mm20_mode = mm40_mode = gf20_mode = gf40_mode = 2;
+		mm20_mode = mm40_mode = gf20_mode = gf40_mode = 1;
 
 		/*
 		 * If erp protection is needed we have to protect HT
@@ -1660,7 +1660,7 @@ static void rt2800_config_ht_opmode(struct rt2x00_dev *rt2x00dev,
 
 	/* check for STAs not supporting greenfield mode */
 	if (any_sta_nongf)
-		gf20_mode = gf40_mode = 2;
+		gf20_mode = gf40_mode = 1;
 
 	/* Update HT protection config */
 	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
-- 
1.7.1
