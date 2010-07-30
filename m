Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0G3ELX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 00:11:23 -0400
Subject: [wt PATCH 2/5] libertas: better scan response debugging
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280470034.14523.4.camel@dcbw.foobar.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 23:12:53 -0700
Message-ID: <1280470373.14523.9.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it a bit easier to debug scan results in the future.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index b60f661..c7da6c0 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -502,20 +502,31 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 
 	pos = scanresp->bssdesc_and_tlvbuffer;
 
+	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_RSP", scanresp->bssdesc_and_tlvbuffer,
+			scanresp->bssdescriptsize);
+
 	tsfdesc = pos + bsssize;
 	tsfsize = 4 + 8 * scanresp->nr_sets;
+	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_TSF", (u8 *) tsfdesc, tsfsize);
 
 	/* Validity check: we expect a Marvell-Local TLV */
 	i = get_unaligned_le16(tsfdesc);
 	tsfdesc += 2;
-	if (i != TLV_TYPE_TSFTIMESTAMP)
+	if (i != TLV_TYPE_TSFTIMESTAMP) {
+		lbs_deb_scan("scan response: invalid TSF Timestamp %d\n", i);
 		goto done;
+	}
+
 	/* Validity check: the TLV holds TSF values with 8 bytes each, so
 	 * the size in the TLV must match the nr_sets value */
 	i = get_unaligned_le16(tsfdesc);
 	tsfdesc += 2;
-	if (i / 8 != scanresp->nr_sets)
+	if (i / 8 != scanresp->nr_sets) {
+		lbs_deb_scan("scan response: invalid number of TSF timestamp "
+			     "sets (expected %d got %d)\n", scanresp->nr_sets,
+			     i / 8);
 		goto done;
+	}
 
 	for (i = 0; i < scanresp->nr_sets; i++) {
 		const u8 *bssid;
@@ -557,8 +568,11 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 			id = *pos++;
 			elen = *pos++;
 			left -= 2;
-			if (elen > left || elen == 0)
+			if (elen > left || elen == 0) {
+				lbs_deb_scan("scan response: invalid IE fmt\n");
 				goto done;
+			}
+
 			if (id == WLAN_EID_DS_PARAMS)
 				chan_no = *pos;
 			if (id == WLAN_EID_SSID) {
@@ -589,7 +603,9 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 					capa, intvl, ie, ielen,
 					LBS_SCAN_RSSI_TO_MBM(rssi),
 					GFP_KERNEL);
-		}
+		} else
+			lbs_deb_scan("scan response: missing BSS channel IE\n");
+
 		tsfdesc += 8;
 	}
 	ret = 0;
-- 
1.7.2


