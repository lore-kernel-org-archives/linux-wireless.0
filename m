Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:45520 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbZHQKrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 06:47:33 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_VVhhnippI0IkKQxaDoT6FQ)"
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KOI00MSAON9FPD0@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 17 Aug 2009 12:47:33 +0200 (CEST)
Received: from [137.226.12.123]
 (informatik-4-137-226-12-123.nn.RWTH-Aachen.DE [137.226.12.123] (may be
 forged))	by relay.rwth-aachen.de (8.13.8+Sun/8.13.8/1)
 with ESMTP id n7HAlXYi003761	for <linux-wireless@vger.kernel.org>; Mon,
 17 Aug 2009 12:47:33 +0200 (CEST)
Message-id: <4A893520.1010901@nets.rwth-aachen.de>
Date: Mon, 17 Aug 2009 12:46:56 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: fix output qualifier for unsigned values
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_VVhhnippI0IkKQxaDoT6FQ)
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT

Hi,

with 0.9.16 a "iw wlan0 station dump" gives the following output:

Station XX:XX:XX:XX:XX:XX (on wlan0)
	inactive time:	4 ms
	rx bytes:	-1611945626
	rx packets:	7643414
	tx bytes:	1527923993
	tx packets:	4829428
	signal:  	-63 dBm
	tx bitrate:	54.0 MBit/s


Seems to be the output qualifier %d is used wrongly in some cases.
This patch fixes that.

--Boundary_(ID_VVhhnippI0IkKQxaDoT6FQ)
Content-type: text/x-patch; name=iw_use_unsigned.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=iw_use_unsigned.patch

Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>

diff -Naur iw-0.9.16.orig/station.c iw-0.9.16/station.c
--- iw-0.9.16.orig/station.c	2009-08-16 16:03:36.000000000 +0200
+++ iw-0.9.16/station.c	2009-08-17 12:31:58.119502558 +0200
@@ -80,19 +80,19 @@
 	printf("Station %s (on %s)", mac_addr, dev);
 
 	if (sinfo[NL80211_STA_INFO_INACTIVE_TIME])
-		printf("\n\tinactive time:\t%d ms",
+		printf("\n\tinactive time:\t%u ms",
 			nla_get_u32(sinfo[NL80211_STA_INFO_INACTIVE_TIME]));
 	if (sinfo[NL80211_STA_INFO_RX_BYTES])
-		printf("\n\trx bytes:\t%d",
+		printf("\n\trx bytes:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_RX_BYTES]));
 	if (sinfo[NL80211_STA_INFO_RX_PACKETS])
-		printf("\n\trx packets:\t%d",
+		printf("\n\trx packets:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_RX_PACKETS]));
 	if (sinfo[NL80211_STA_INFO_TX_BYTES])
-		printf("\n\ttx bytes:\t%d",
+		printf("\n\ttx bytes:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_BYTES]));
 	if (sinfo[NL80211_STA_INFO_TX_PACKETS])
-		printf("\n\ttx packets:\t%d",
+		printf("\n\ttx packets:\t%u",
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_PACKETS]));
 	if (sinfo[NL80211_STA_INFO_SIGNAL])
 		printf("\n\tsignal:  \t%d dBm",

--Boundary_(ID_VVhhnippI0IkKQxaDoT6FQ)--
