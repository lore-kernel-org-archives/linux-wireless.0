Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxm.seznam.cz ([77.75.72.45]:59953 "EHLO mxm.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbYK1PiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 10:38:08 -0500
In-Reply-To: <1227864737.3883.0.camel@johannes.berg>
Date: Fri, 28 Nov 2008 16:37:55 +0100 (CET)
Cc: linux-wireless@vger.kernel.org
To: linville@tuxdriver.com
From: =?iso-8859-2?Q?Carlos=20Lau=E9?= <CarlosL@seznam.cz>
Subject: =?us-ascii?Q?=5BPATCH=5D=20wireless=2Dregdb=3A=20Update=20regulatory=20rules=20for=20Czech=20Republic=20=28CZ=29=20on=205GHz?=
Mime-Version: 1.0
Message-Id: <819.1442-26431-1638312140-1227886675@seznam.cz> (sfid-20081128_163815_900945_A9BD6069)
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > OK, I thought we cannot guarantee the automatic power regulation,
> > using lower values for now, it would be nice to implement the required
> > mechanism to assure tx power regulation, but then how to define the
> > two values? two tables, or a flag like "NO-APC -3" indicating that,
> > without tx power regulation, there is a lower limit for tx power? 
> 
> No, it's not that trivial, needs more thought and a db change.

Sure, I realize that, but we should start somewhere... I think  we can discuss how to change it, change at least the db and the parser, then start making little changes all around. I'll send this idea into another e-mail to discuss about. For now, we should stay with the lower settings

> > And the patch:
> 
> I think you forgot something.
> 
> johannes

 Yes, there is definitely something missing... sorry... But I remember sending it a second time a couple of minutes later, including the patch. Perhaps something happened between Firefox and my free webmail.... restarted Firefox, let's try again.

The patch:

--- old/db.txt	2008-11-28 00:42:28.000000000 +0100
+++ new/db.txt	2008-11-28 00:48:43.000000000 +0100
@@ -141,10 +141,15 @@
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
 
+# Data from
+# http://www.ctu.cz/1/download/Opatreni%20obecne%20povahy/VO_R_12_08_2005_34.pdf
+# and http://www.ctu.cz/1/download/OOP/Rok_2007/VO_R_10_03_2007_4.pdf
 country CZ:
-	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(2402 - 2482 @ 40), (N/A, 100 mW)
+	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
+	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
+	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
+	(5725 - 5875 @ 40), (N/A, 25 mW)
 
 # Data from "Frequenznutzungsplan" (as published in April 2008),
 # downloaded from http://www.bundesnetzagentur.de/media/archive/13358.pdf
