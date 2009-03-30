Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbZC3UlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 16:41:01 -0400
Subject: [PATCH] update/fix DE 5GHz rules
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Seibold <bernhard.seibold@uni-ulm.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Thomas =?ISO-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
In-Reply-To: <1238113267.29544.14.camel@blob> (sfid-20090327_015046_030762_288A170F)
References: <1238113267.29544.14.camel@blob>
	 (sfid-20090327_015046_030762_288A170F)
Content-Type: text/plain
Date: Mon, 30 Mar 2009 22:39:49 +0200
Message-Id: <1238445589.5970.35.camel@johannes.local> (sfid-20090330_224113_517077_A1F82057)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates the 5 GHz rules -- TPC is not supported in any way yet so
the transmit power limit needs to be halved; some additional ranges are
available.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 db.txt |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index d3a05ea..b9cb935 100644
--- a/db.txt
+++ b/db.txt
@@ -162,13 +162,15 @@ country CZ:
 
 # Data from "Frequenznutzungsplan" (as published in April 2008),
 # downloaded from http://www.bundesnetzagentur.de/media/archive/13358.pdf
+# Also applicable is http://www.bundesnetzagentur.de/media/archive/5009.pdf
+# On the 5 GHz ranges TX power can be doubled if TPC is implemented.
 country DE:
 	# entries 279004 and 280006
 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
-	# entries 303005 and 304002
-	(5150 - 5255 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
-	# entries 308002 and 309001
-	(5470 - 5650 @ 40), (N/A, 1000 mW), DFS
+	# entries 303005, 304002 and 305002
+	(5150 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
+	# entries 308002, 309001 and 310003
+	(5470 - 5725 @ 40), (N/A, 500 mW), NO-OUTDOOR, DFS
 
 country DK:
 	(2402 - 2482 @ 40), (N/A, 20)


