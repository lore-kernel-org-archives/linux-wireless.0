Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:51854 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2LJPs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 10:48:28 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wireless-regdb: add regulatory rule for ETSI members on 60gHz band
Date: Mon, 10 Dec 2012 17:48:24 +0200
Message-ID: <2028055.RB8DPWJWyd@lx-vladimir> (sfid-20121210_164832_994851_EF408B8E)
In-Reply-To: <1355142835.9857.19.camel@jlt4.sipsolutions.net>
References: <8774585.BvFN3Opv12@lx-vladimir> <2225032.pbhpKMrF3f@lx-vladimir> <1355142835.9857.19.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, December 10, 2012 01:33:55 PM Johannes Berg wrote:
> On Mon, 2012-12-10 at 14:15 +0200, Vladimir Kondratiev wrote:
> > On Monday, December 10, 2012 12:31:47 PM Johannes Berg wrote:
> > > does the kernel understand the two rules with
> > > different TX power/outdoor restriction properly?
> > 
> > Oh no! You are right, kernel won't get it.
> > 
> > In general: What is the right way to specify different restrictions
> > for indoor and outdoor?
> 
> I don't know if we have a way to handle it right now ...
> 
> > In this particular case, would it be appropriate to specify
> > indoor usage only, as 60g wi-fi will be used mostly indoor?
> 
> With the current rule system that'd be the only way, I think.

OK, patch follows. I updated message title as well.

> 
> We should keep it in mind for the new rule system.
> 
> However, I notice there are also spectral power limits, that might be
> relevant in case anyone ever uses the database for narrower channels?

Agree, it is worth to add "spectral power limit" to the regdb. Right now
there is no such thing -> to the wish list for new rule system.

So, we get out with 3 items for new rule system:

1) support "unspecified" bandwidth
2) support multiple overlapping rules for the same frequency range.
3) add spectral power limit

and, patch:

>From 69554755daf74ba32ebe0d028de57ed45003e0ab Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 10 Dec 2012 17:43:53 +0200
Subject: [PATCH v2] wireless-regdb: add regulatory rule for ETSI members on
 60GHz band

Purpose is to serve for 802.11ad specification that introduces operation
on the 60GHz band, using bandwidth 2160MHz.

For the 60GHz band, regulation defined in the "Etsi En 302 567"
http://docsfiles.com/pdf_final_draft_etsi_en_302_567.html

It defines for the frequency range 57 GHz to 66 GHz,
Max. power level (EIRP) for
indoor only: 40 dBm, and indoor/outdoor: 25 dBm
Also, there is spectral power density limit
13 dBm/MHz for indoor and -2 dBm/MHz indoor/outdoor

Only indoor part specified, as kernel can't use multiple
rules per frequency at the moment. Also, standard do not set bandwidth limitation;
for purpose of 802.11ad this patch specifies bandwidth 2160 MHz,
in this case gross EIRP limit applies. Frequency limits also set accordingly
to the 802.11ad channel allocation.

This patch apply this to the full ETSI member countries:

The EU member states:
Austria, Belgium, Bulgaria, Cyprus, Czech Republic, Denmark,
Estonia, Finland, France, Germany, Greece, Hungary, Ireland,
Italy, Latvia, Lithuania, Luxembourg, Malta, Netherlands,
Poland, Portugal, Romania, Slovakia, Slovenia, Spain, Sweden,
United Kingdom

plus:
Andorra, Iceland, Norway, Switzerland, Croatia,
Bosnia and Herzegovina, Serbia, Macedonia,
Ukraine, Turkey, Georgia

Final country codes list:

AD
AT
BA
BE
BG
CH
CY
CZ
DE
DK
EE
ES
FI
FR
GB
GE
GR
HR
HU
IE
IS
IT
LT
LU
LV
MK
MT
NL
NO
PL
PT
RO
RS
SE
SI
SK
TR
UA

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 db.txt |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/db.txt b/db.txt
index b97255d..c8e455d 100644
--- a/db.txt
+++ b/db.txt
@@ -12,6 +12,10 @@ country 00:
         (5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
 
 
+country AD:
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+
 country AE:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
@@ -44,6 +48,8 @@ country AT: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country AU:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -67,6 +73,8 @@ country BA: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country BB:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -82,12 +90,16 @@ country BE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country BG: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 23)
 	(5250 - 5290 @ 40), (N/A, 23), DFS
 	(5490 - 5710 @ 40), (N/A, 30), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country BH:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -139,6 +151,8 @@ country CH: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country CL:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -173,6 +187,8 @@ country CY: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 # Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
 # and http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
@@ -183,6 +199,8 @@ country CZ: DFS-ETSI
 	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 # Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from
 # http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
@@ -205,12 +223,16 @@ country DE: DFS-ETSI
 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
 	# entries 308002, 309001 and 310003
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country DK: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country DO:
 	(2402 - 2472 @ 40), (3, 27)
@@ -232,6 +254,8 @@ country EE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country EG:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -243,29 +267,39 @@ country ES: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country FI: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country FR: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country GE:
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 18)
 	(5250 - 5330 @ 40), (N/A, 18), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country GB: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country GD:
 	(2402 - 2472 @ 40), (3, 27)
@@ -279,6 +313,8 @@ country GR: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country GL: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -317,6 +353,8 @@ country HR: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country HT:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -329,6 +367,8 @@ country HU: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country ID:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -338,6 +378,8 @@ country IE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country IL:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -355,6 +397,8 @@ country IS: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country IR:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -365,6 +409,8 @@ country IT: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country JM:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -445,18 +491,24 @@ country LT: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country LU: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country LV: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country MC: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -477,12 +529,16 @@ country MK: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country MT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country MY:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -500,12 +556,16 @@ country NL: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20), NO-OUTDOOR
 	(5250 - 5330 @ 40), (N/A, 20), NO-OUTDOOR, DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country NO: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country NP:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -553,12 +613,16 @@ country PL: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country PT: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country PR:
 	(2402 - 2472 @ 40), (3, 27)
@@ -575,6 +639,12 @@ country RO: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+
+country RS:
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country RU:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -595,6 +665,8 @@ country SE: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country SG:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -607,12 +679,16 @@ country SI: DFS-ETSI
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country SK: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 40), (N/A, 20)
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country SV:
 	(2402 - 2482 @ 40), (N/A, 20)
@@ -651,9 +727,13 @@ country TR: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 20), (N/A, 20)
 	(5250 - 5330 @ 20), (N/A, 20), DFS
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country UA:
 	(2402 - 2482 @ 40), (N/A, 20)
+        # 60 gHz band channels 1-4, ref: Etsi En 302 567
+        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country US: DFS-FCC
 	(2402 - 2472 @ 40), (3, 27)
-- 
1.7.10.4



