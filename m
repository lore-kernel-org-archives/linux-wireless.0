Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7001 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab0BKW4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 17:56:17 -0500
Subject: [PATCH] Introduce PCMCIA_DEVICE_PROD_ID3, use it in hostap_cs and
 orinoco_cs
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ozzy <ozzymud@gmail.com>
Cc: linux-pcmcia@lists.infradead.org
Content-Type: text/plain
Date: Thu, 11 Feb 2010 17:56:06 -0500
Message-Id: <1265928966.19980.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another PCMCIA device with Intersil Prism chipset has been reported:

Socket 0:
  product info: "Gigabyte", "GN-WLM01_P25L_ADAPTER", "ISL37300P", "Eval-RevA"
  manfid: 0x02e0, 0x1011
  function: 6 (network)

As it's the case with some other Prism based devices, the third ID
string contains a design name that should be sufficient to identify the
card as having Intersil Prism chipset and thus compatible with both
orinoco_cs and hostap_cs.

Introduce PCMCIA_DEVICE_PROD_ID3 that matches the third ID string only.

Use it in orinoco_cs and hostap_cs to match cards with the third ID
string indicating Prism chipset.  Remove corresponding entries that use
PCMCIA_DEVICE_PROD_ID123.

Reported-by: Ozzy <ozzymud@gmail.com>
Signed-off-by: Pavel Roskin <proski@gnu.org>
---
I'm not sure how to submit this patch, as it touches the PCMCIA code.
I'm ready to split it as necessary.

 drivers/net/wireless/hostap/hostap_cs.c   |   17 ++++-------------
 drivers/net/wireless/orinoco/orinoco_cs.c |    9 ++++-----
 include/pcmcia/device_id.h                |    5 +++++
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index c9640a3..d19748d 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -794,13 +794,6 @@ static struct pcmcia_device_id hostap_cs_ids[] = {
 	PCMCIA_MFC_DEVICE_PROD_ID12(0, "SanDisk", "ConnectPlus",
 				    0x7a954bd9, 0x74be00c6),
 	PCMCIA_DEVICE_PROD_ID123(
-		"Intersil", "PRISM 2_5 PCMCIA ADAPTER",	"ISL37300P",
-		0x4b801a17, 0x6345a0bf, 0xc9049a39),
-	/* D-Link DWL-650 Rev. P1; manfid 0x000b, 0x7110 */
-	PCMCIA_DEVICE_PROD_ID123(
-		"D-Link", "DWL-650 Wireless PC Card RevP", "ISL37101P-10",
-		0x1a424a1c, 0x6ea57632, 0xdd97a26b),
-	PCMCIA_DEVICE_PROD_ID123(
 		"Addtron", "AWP-100 Wireless PCMCIA", "Version 01.02",
 		0xe6ec52ce, 0x08649af2, 0x4b74baa0),
 	PCMCIA_DEVICE_PROD_ID123(
@@ -834,14 +827,12 @@ static struct pcmcia_device_id hostap_cs_ids[] = {
 		"Ver. 1.00",
 		0x5cd01705, 0x4271660f, 0x9d08ee12),
 	PCMCIA_DEVICE_PROD_ID123(
-		"corega", "WL PCCL-11", "ISL37300P",
-		0xa21501a, 0x59868926, 0xc9049a39),
-	PCMCIA_DEVICE_PROD_ID123(
-		"The Linksys Group, Inc.", "Wireless Network CF Card", "ISL37300P",
-		0xa5f472c2, 0x9c05598d, 0xc9049a39),
-	PCMCIA_DEVICE_PROD_ID123(
 		"Wireless LAN" , "11Mbps PC Card", "Version 01.02",
 		0x4b8870ff, 0x70e946d1, 0x4b74baa0),
+	PCMCIA_DEVICE_PROD_ID3("HFA3863", 0x355cb092),
+	PCMCIA_DEVICE_PROD_ID3("ISL37100P", 0x630d52b2),
+	PCMCIA_DEVICE_PROD_ID3("ISL37101P-10", 0xdd97a26b),
+	PCMCIA_DEVICE_PROD_ID3("ISL37300P", 0xc9049a39),
 	PCMCIA_DEVICE_NULL
 };
 MODULE_DEVICE_TABLE(pcmcia, hostap_cs_ids);
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index f27bb83..1d4ada1 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -407,7 +407,6 @@ static struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("3Com", "3CRWE737A AirConnect Wireless LAN PC Card", 0x41240e5b, 0x56010af3),
 	PCMCIA_DEVICE_PROD_ID12("ACTIONTEC", "PRISM Wireless LAN PC Card", 0x393089da, 0xa71e69d5),
 	PCMCIA_DEVICE_PROD_ID12("Addtron", "AWP-100 Wireless PCMCIA", 0xe6ec52ce, 0x08649af2),
-	PCMCIA_DEVICE_PROD_ID123("AIRVAST", "IEEE 802.11b Wireless PCMCIA Card", "HFA3863", 0xea569531, 0x4bcb9645, 0x355cb092),
 	PCMCIA_DEVICE_PROD_ID12("Allied Telesyn", "AT-WCL452 Wireless PCMCIA Radio", 0x5cd01705, 0x4271660f),
 	PCMCIA_DEVICE_PROD_ID12("ASUS", "802_11b_PC_CARD_25", 0x78fc06ee, 0xdb9aa842),
 	PCMCIA_DEVICE_PROD_ID12("ASUS", "802_11B_CF_CARD_25", 0x78fc06ee, 0x45a50c1e),
@@ -417,7 +416,6 @@ static struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("BUFFALO", "WLI-CF-S11G", 0x2decece3, 0x82067c18),
 	PCMCIA_DEVICE_PROD_ID12("Cabletron", "RoamAbout 802.11 DS", 0x32d445f5, 0xedeffd90),
 	PCMCIA_DEVICE_PROD_ID12("Compaq", "WL200_11Mbps_Wireless_PCI_Card", 0x54f7c49c, 0x15a75e5b),
-	PCMCIA_DEVICE_PROD_ID123("corega", "WL PCCL-11", "ISL37300P", 0x0a21501a, 0x59868926, 0xc9049a39),
 	PCMCIA_DEVICE_PROD_ID12("corega K.K.", "Wireless LAN PCC-11", 0x5261440f, 0xa6405584),
 	PCMCIA_DEVICE_PROD_ID12("corega K.K.", "Wireless LAN PCCA-11", 0x5261440f, 0xdf6115f9),
 	PCMCIA_DEVICE_PROD_ID12("corega_K.K.", "Wireless_LAN_PCCB-11", 0x29e33311, 0xee7a27ae),
@@ -432,7 +430,6 @@ static struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("INTERSIL", "HFA384x/IEEE", 0x74c5e40d, 0xdb472a18),
 	PCMCIA_DEVICE_PROD_ID12("INTERSIL", "I-GATE 11M PC Card / PC Card plus", 0x74c5e40d, 0x8304ff77),
 	PCMCIA_DEVICE_PROD_ID12("Intersil", "PRISM 2_5 PCMCIA ADAPTER", 0x4b801a17, 0x6345a0bf),
-	PCMCIA_DEVICE_PROD_ID123("Intersil", "PRISM Freedom PCMCIA Adapter", "ISL37100P", 0x4b801a17, 0xf222ec2d, 0x630d52b2),
 	PCMCIA_DEVICE_PROD_ID12("LeArtery", "SYNCBYAIR 11Mbps Wireless LAN PC Card", 0x7e3b326a, 0x49893e92),
 	PCMCIA_DEVICE_PROD_ID12("Linksys", "Wireless CompactFlash Card", 0x0733cc81, 0x0c52f395),
 	PCMCIA_DEVICE_PROD_ID12("Lucent Technologies", "WaveLAN/IEEE", 0x23eb9949, 0xc562e72a),
@@ -445,7 +442,6 @@ static struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("Nortel Networks", "emobility 802.11 Wireless LAN PC Card", 0x2d617ea0, 0x88cd5767),
 	PCMCIA_DEVICE_PROD_ID12("OEM", "PRISM2 IEEE 802.11 PC-Card", 0xfea54c90, 0x48f2bdd6),
 	PCMCIA_DEVICE_PROD_ID12("OTC", "Wireless AirEZY 2411-PCC WLAN Card", 0x4ac44287, 0x235a6bed),
-	PCMCIA_DEVICE_PROD_ID123("PCMCIA", "11M WLAN Card v2.5", "ISL37300P", 0x281f1c5d, 0x6e440487, 0xc9049a39),
 	PCMCIA_DEVICE_PROD_ID12("PLANEX", "GeoWave/GW-CF110", 0x209f40ab, 0xd9715264),
 	PCMCIA_DEVICE_PROD_ID12("PLANEX", "GeoWave/GW-NS110", 0x209f40ab, 0x46263178),
 	PCMCIA_DEVICE_PROD_ID12("PROXIM", "LAN PC CARD HARMONY 80211B", 0xc6536a5e, 0x090c3cd9),
@@ -454,8 +450,11 @@ static struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("SMC", "SMC2532W-B EliteConnect Wireless Adapter", 0xc4f8b18b, 0x196bd757),
 	PCMCIA_DEVICE_PROD_ID12("SMC", "SMC2632W", 0xc4f8b18b, 0x474a1f2a),
 	PCMCIA_DEVICE_PROD_ID12("Symbol Technologies", "LA4111 Spectrum24 Wireless LAN PC Card", 0x3f02b4d6, 0x3663cb0e),
-	PCMCIA_DEVICE_PROD_ID123("The Linksys Group, Inc.", "Instant Wireless Network PC Card", "ISL37300P", 0xa5f472c2, 0x590eb502, 0xc9049a39),
 	PCMCIA_DEVICE_PROD_ID12("ZoomAir 11Mbps High", "Rate wireless Networking", 0x273fe3db, 0x32a1eaee),
+	PCMCIA_DEVICE_PROD_ID3("HFA3863", 0x355cb092),
+	PCMCIA_DEVICE_PROD_ID3("ISL37100P", 0x630d52b2),
+	PCMCIA_DEVICE_PROD_ID3("ISL37101P-10", 0xdd97a26b),
+	PCMCIA_DEVICE_PROD_ID3("ISL37300P", 0xc9049a39),
 	PCMCIA_DEVICE_NULL,
 };
 MODULE_DEVICE_TABLE(pcmcia, orinoco_cs_ids);
diff --git a/include/pcmcia/device_id.h b/include/pcmcia/device_id.h
index c33ea08..63e5b8f 100644
--- a/include/pcmcia/device_id.h
+++ b/include/pcmcia/device_id.h
@@ -34,6 +34,11 @@
 	.prod_id = { NULL, (v2), NULL, NULL },  \
 	.prod_id_hash = { 0, (vh2), 0, 0 }, }
 
+#define PCMCIA_DEVICE_PROD_ID3(v3, vh3) { \
+	.match_flags = PCMCIA_DEV_ID_MATCH_PROD_ID3, \
+	.prod_id = { NULL, NULL, (v3), NULL },  \
+	.prod_id_hash = { 0, 0, (vh3), 0 }, }
+
 #define PCMCIA_DEVICE_PROD_ID12(v1, v2, vh1, vh2) { \
 	.match_flags = PCMCIA_DEV_ID_MATCH_PROD_ID1| \
 			PCMCIA_DEV_ID_MATCH_PROD_ID2, \

-- 
Regards,
Pavel Roskin
