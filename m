Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxm.seznam.cz ([77.75.72.45]:34649 "EHLO mxm.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbZABMJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 07:09:54 -0500
Cc: linux-wireless@vger.kernel.org,
	=?us-ascii?Q?Michael=20Green?= <Michael.Green@atheros.com>,
	=?us-ascii?Q?Luis=20R=2E=20Rodriguez?= <mcgrof@gmail.com>
To: linville@tuxdriver.com
Date: Fri, 02 Jan 2009 13:09:41 +0100 (CET)
From: =?iso-8859-2?Q?Carlos=20Lau=E9?= <CarlosL@seznam.cz>
Subject: =?us-ascii?Q?=5BPATCH=20v3=5D=20wireless=2Dregdb=3A=20Update=20regulatory=20rules=20for=20Czech=20Republic=20=28CZ=29=20on=205GHz?=
Mime-Version: 1.0
Message-Id: <272.644-30384-2075382930-1230898181@seznam.cz> (sfid-20090102_131021_406737_1E9F3985)
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This patch updates the frequency table for Czech Republic to include 80=
2.11a. It should be in conformance with all EU & Czech laws.Thanks  Mic=
hael Green &   Luis R. Rodriguez for explaining some details about TPC =
compliance. It does not penalize by 3dB, nor includes the dubious  freq=
uencies 5,725=E2=80=935,875 GHz.

Signed-off-by: Carlos Lau=C3=A9 <carlosl@seznam.cz>

diff --git a/db.txt b/db.txt
index 6a282b6..55d928a 100644
--- a/db.txt
+++ b/db.txt
@@ -141,10 +141,13 @@ country CY:
        (5250 - 5330 @ 40), (N/A, 20), DFS
        (5490 - 5710 @ 40), (N/A, 27), DFS

+# Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
+# and http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
 country CZ:
-       (2402 - 2482 @ 40), (N/A, 20)
-       (5170 - 5250 @ 40), (N/A, 20)
-       (5250 - 5330 @ 40), (N/A, 20), DFS
+       (2400 - 2483.5 @ 40), (N/A, 100 mW)
+       (5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
+       (5250 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
+       (5470 - 5725 @ 40), (N/A, 1000 mW), DFS

 # Data from "Frequenznutzungsplan" (as published in April 2008),
 # downloaded from http://www.bundesnetzagentur.de/media/archive/13358.=
pdf
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
