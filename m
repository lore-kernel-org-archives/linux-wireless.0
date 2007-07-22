Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [77.235.43.93] ([77.235.43.93]:54270 "EHLO main.fasthost.gr"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750843AbXGVNYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2007 09:24:45 -0400
Date: Sun, 22 Jul 2007 16:17:51 +0300
From: Faidon Liambotis <paravoid@debian.org>
To: linux-wireless@vger.kernel.org
Cc: hermes@gibson.dropbear.id.au
Subject: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option for Prism2
Message-ID: <20070722131751.GA3009@void.cube.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since v2.6.14, Prism 2/2.5/3 devices are better supported using the HostAP
driver, which was made to work with these exclusively.
Having the same IDs supported by orinoco too confuses users who have both
drivers compiled in or as modules who expect hostap to drive the device.

Telling users to echo to /sys/bus/pci/drivers/*/unbind and bind is not
exactly user-friendly.

Create an option to disable support for Prism devices in orinoco driver which
disabled the IDs for the PCMCIA module and creates a Kconfig dependency for
the Prism PCI modules.

Signed-off-by: Faidon Liambotis <paravoid@debian.org>
---
 drivers/net/wireless/Kconfig      |   31 ++++++++++++++++--
 drivers/net/wireless/orinoco_cs.c |   60 +++++++++++++++++++------------------
 2 files changed, 58 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index cfcaf5c..54c0568 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -334,9 +334,22 @@ config APPLE_AIRPORT
 	  This driver does not support the Airport Extreme (802.11b/g). Use
 	  the BCM43xx driver for Airport Extreme cards.
 
+config HERMES_PRISM
+	bool "Prism 2/2.5 support for Hermes (DEPRECATED)"
+	depends on HERMES
+	help
+	  Say Y here to enable support for Intersil HFA384x (Prism 2/2.5)
+	  devices in the Hermes driver. This is discouraged since there nowa
+	  is a separate driver for these chipsets called Host AP.
+
+	  Enabling this option is not enough to operate your device with the
+	  Hermes driver; you will need to enable support for PLX9052-based
+	  TMD07160-based, Nortel emobility or Prism 2.5 PCI adapters or the
+	  Prism support for the PCMCIA driver.
+
 config PLX_HERMES
 	tristate "Hermes in PLX9052 based PCI adaptor support (Netgear MA301 etc.)"
-	depends on PCI && HERMES
+	depends on PCI && HERMES_PRISM
 	help
 	  Enable support for PCMCIA cards supported by the "Hermes" (aka
 	  orinoco) driver when used in PLX9052 based PCI adaptors.  These
@@ -347,7 +360,7 @@ config PLX_HERMES
 
 config TMD_HERMES
 	tristate "Hermes in TMD7160 based PCI adaptor support"
-	depends on PCI && HERMES
+	depends on PCI && HERMES_PRISM
 	help
 	  Enable support for PCMCIA cards supported by the "Hermes" (aka
 	  orinoco) driver when used in TMD7160 based PCI adaptors.  These
@@ -357,7 +370,7 @@ config TMD_HERMES
 
 config NORTEL_HERMES
 	tristate "Nortel emobility PCI adaptor support"
-	depends on PCI && HERMES
+	depends on PCI && HERMES_PRISM
 	help
 	  Enable support for PCMCIA cards supported by the "Hermes" (aka
 	  orinoco) driver when used in Nortel emobility PCI adaptors.  These
@@ -366,7 +379,7 @@ config NORTEL_HERMES
 
 config PCI_HERMES
 	tristate "Prism 2.5 PCI 802.11b adaptor support"
-	depends on PCI && HERMES
+	depends on PCI && HERMES_PRISM
 	help
 	  Enable support for PCI and mini-PCI 802.11b wireless NICs based on
 	  the Prism 2.5 chipset.  These are true PCI cards, not the 802.11b
@@ -389,6 +402,16 @@ config PCMCIA_HERMES
 	  configure your card and that /etc/pcmcia/wireless.opts works:
 	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
+config PCMCIA_HERMES_PRISM
+	bool "Prism 2/2.5 PCMCIA card support for Hermes"
+	depends on PCMCIA_HERMES && HERMES_PRISM
+	help
+	  Enable support for Prism 2/2.5 (Intersil HFA384x) chipsets in the
+	  Hermes PCMCIA driver.
+
+	  Usage of this option is strongly discouraged. You should use the
+	  Host AP driver instead.
+
 config PCMCIA_SPECTRUM
 	tristate "Symbol Spectrum24 Trilogy PCMCIA card support"
 	depends on PCMCIA && HERMES
diff --git a/drivers/net/wireless/orinoco_cs.c b/drivers/net/wireless/orinoco_cs.c
index d1e5022..78688f3 100644
--- a/drivers/net/wireless/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco_cs.c
@@ -442,76 +442,80 @@ static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
 	"Pavel Roskin <proski@gnu.org>, et al)";
 
 static struct pcmcia_device_id orinoco_cs_ids[] = {
+#ifdef CONFIG_PCMCIA_HERMES_PRISM
 	PCMCIA_DEVICE_MANF_CARD(0x000b, 0x7100), /* SonicWALL Long Range Wireless Card */
 	PCMCIA_DEVICE_MANF_CARD(0x000b, 0x7300), /* Sohoware NCP110, Philips 802.11b */
-	PCMCIA_DEVICE_MANF_CARD(0x0089, 0x0002), /* AnyPoint(TM) Wireless II PC Card */
 	PCMCIA_DEVICE_MANF_CARD(0x0101, 0x0777), /* 3Com AirConnect PCI 777A */
 	PCMCIA_DEVICE_MANF_CARD(0x0126, 0x8000), /* PROXIM RangeLAN-DS/LAN PC CARD */
 	PCMCIA_DEVICE_MANF_CARD(0x0138, 0x0002), /* Compaq WL100 11 Mbps Wireless Adapter */
+	PCMCIA_DEVICE_MANF_CARD(0x0250, 0x0002), /* Samsung SWL2000-N 11Mb/s WLAN Card */
+	PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1612), /* Linksys WPC11 Version 2.5 */
+	PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1613), /* Linksys WPC11 Version 3 */
+	PCMCIA_DEVICE_MANF_CARD(0x028a, 0x0002), /* Compaq HNW-100 11 Mbps Wireless Adapter */
+	PCMCIA_DEVICE_MANF_CARD(0x02aa, 0x0002), /* ASUS SpaceLink WL-100 */
+	PCMCIA_DEVICE_MANF_CARD(0x50c2, 0x7300), /* Airvast WN-100 */
+	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0002), /* Safeway 802.11b, ZCOMAX AirRunner/XI-300 */
+	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0005), /* D-Link DCF660, Sandisk Connect SDWCFB-000 */
+	PCMCIA_DEVICE_PROD_ID12("ACTIONTEC", "PRISM Wireless LAN PC Card", 0x393089da, 0xa71e69d5),
+	PCMCIA_DEVICE_PROD_ID12("Allied Telesyn", "AT-WCL452 Wireless PCMCIA Radio", 0x5cd01705, 0x4271660f),
+	PCMCIA_DEVICE_PROD_ID12("BUFFALO", "WLI-CF-S11G", 0x2decece3, 0x82067c18),
+	PCMCIA_DEVICE_PROD_ID12("Compaq", "WL200_11Mbps_Wireless_PCI_Card", 0x54f7c49c, 0x15a75e5b),
+	PCMCIA_DEVICE_PROD_ID123("corega", "WL PCCL-11", "ISL37300P", 0x0a21501a, 0x59868926, 0xc9049a39),
+	PCMCIA_DEVICE_PROD_ID12("D", "Link DWL-650 11Mbps WLAN Card", 0x71b18589, 0xb6f1b0ab),
+	PCMCIA_DEVICE_PROD_ID123("Instant Wireless ", " Network PC CARD", "Version 01.02", 0x11d901af, 0x6e9bd926, 0x4b74baa0),
+	PCMCIA_DEVICE_PROD_ID12("Intel", "PRO/Wireless 2011 LAN PC Card", 0x816cc815, 0x07f58077),
+	PCMCIA_DEVICE_PROD_ID12("INTERSIL", "HFA384x/IEEE", 0x74c5e40d, 0xdb472a18),
+	PCMCIA_DEVICE_PROD_ID12("INTERSIL", "I-GATE 11M PC Card / PC Card plus", 0x74c5e40d, 0x8304ff77),
+	PCMCIA_DEVICE_PROD_ID12("Intersil", "PRISM 2_5 PCMCIA ADAPTER", 0x4b801a17, 0x6345a0bf),
+	PCMCIA_DEVICE_PROD_ID123("Intersil", "PRISM Freedom PCMCIA Adapter", "ISL37100P", 0x4b801a17, 0xf222ec2d, 0x630d52b2),
+	PCMCIA_DEVICE_PROD_ID12("Linksys", "Wireless CompactFlash Card", 0x0733cc81, 0x0c52f395),
+	PCMCIA_DEVICE_PROD_ID12("NETGEAR MA401 Wireless PC", "Card", 0xa37434e9, 0x9762e8f1),
+	PCMCIA_DEVICE_PROD_ID12("NETGEAR MA401RA Wireless PC", "Card", 0x0306467f, 0x9762e8f1),
+	PCMCIA_DEVICE_PROD_ID12("Nortel Networks", "emobility 802.11 Wireless LAN PC Card", 0x2d617ea0, 0x88cd5767),
+	PCMCIA_DEVICE_PROD_ID12("OEM", "PRISM2 IEEE 802.11 PC-Card", 0xfea54c90, 0x48f2bdd6),
+	PCMCIA_DEVICE_PROD_ID123("PCMCIA", "11M WLAN Card v2.5", "ISL37300P", 0x281f1c5d, 0x6e440487, 0xc9049a39),
+	PCMCIA_DEVICE_PROD_ID123("The Linksys Group, Inc.", "Instant Wireless Network PC Card", "ISL37300P", 0xa5f472c2, 0x590eb502, 0xc9049a39),
+	PCMCIA_DEVICE_PROD_ID12("ZoomAir 11Mbps High", "Rate wireless Networking", 0x273fe3db, 0x32a1eaee),
+#endif
+	PCMCIA_DEVICE_MANF_CARD(0x0089, 0x0002), /* AnyPoint(TM) Wireless II PC Card */
 	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0002), /* Lucent Orinoco and old Intersil */
 	PCMCIA_DEVICE_MANF_CARD(0x016b, 0x0001), /* Ericsson WLAN Card C11 */
 	PCMCIA_DEVICE_MANF_CARD(0x01eb, 0x080a), /* Nortel Networks eMobility 802.11 Wireless Adapter */
 	PCMCIA_DEVICE_MANF_CARD(0x01ff, 0x0008), /* Intermec MobileLAN 11Mbps 802.11b WLAN Card */
-	PCMCIA_DEVICE_MANF_CARD(0x0250, 0x0002), /* Samsung SWL2000-N 11Mb/s WLAN Card */
 	PCMCIA_DEVICE_MANF_CARD(0x0261, 0x0002), /* AirWay 802.11 Adapter (PCMCIA) */
 	PCMCIA_DEVICE_MANF_CARD(0x0268, 0x0001), /* ARtem Onair */
 	PCMCIA_DEVICE_MANF_CARD(0x026f, 0x0305), /* Buffalo WLI-PCM-S11 */
-	PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1612), /* Linksys WPC11 Version 2.5 */
-	PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1613), /* Linksys WPC11 Version 3 */
-	PCMCIA_DEVICE_MANF_CARD(0x028a, 0x0002), /* Compaq HNW-100 11 Mbps Wireless Adapter */
 	PCMCIA_DEVICE_MANF_CARD(0x028a, 0x0673), /* Linksys WCF12 Wireless CompactFlash Card */
-	PCMCIA_DEVICE_MANF_CARD(0x02aa, 0x0002), /* ASUS SpaceLink WL-100 */
 	PCMCIA_DEVICE_MANF_CARD(0x02ac, 0x0002), /* SpeedStream SS1021 Wireless Adapter */
 	PCMCIA_DEVICE_MANF_CARD(0x14ea, 0xb001), /* PLANEX RoadLannerWave GW-NS11H */
-	PCMCIA_DEVICE_MANF_CARD(0x50c2, 0x7300), /* Airvast WN-100 */
 	PCMCIA_DEVICE_MANF_CARD(0x9005, 0x0021), /* Adaptec Ultra Wireless ANW-8030 */
 	PCMCIA_DEVICE_MANF_CARD(0xc001, 0x0008), /* CONTEC FLEXSCAN/FX-DDS110-PCC */
 	PCMCIA_DEVICE_MANF_CARD(0xc250, 0x0002), /* Conceptronic CON11Cpro, EMTAC A2424i */
-	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0002), /* Safeway 802.11b, ZCOMAX AirRunner/XI-300 */
-	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0005), /* D-Link DCF660, Sandisk Connect SDWCFB-000 */
 	PCMCIA_DEVICE_PROD_ID12(" ", "IEEE 802.11 Wireless LAN/PC Card", 0x3b6e20c8, 0xefccafe9),
 	PCMCIA_DEVICE_PROD_ID12("3Com", "3CRWE737A AirConnect Wireless LAN PC Card", 0x41240e5b, 0x56010af3),
-	PCMCIA_DEVICE_PROD_ID12("ACTIONTEC", "PRISM Wireless LAN PC Card", 0x393089da, 0xa71e69d5),
 	PCMCIA_DEVICE_PROD_ID12("Addtron", "AWP-100 Wireless PCMCIA", 0xe6ec52ce, 0x08649af2),
 	PCMCIA_DEVICE_PROD_ID123("AIRVAST", "IEEE 802.11b Wireless PCMCIA Card", "HFA3863", 0xea569531, 0x4bcb9645, 0x355cb092),
-	PCMCIA_DEVICE_PROD_ID12("Allied Telesyn", "AT-WCL452 Wireless PCMCIA Radio", 0x5cd01705, 0x4271660f),
 	PCMCIA_DEVICE_PROD_ID12("ASUS", "802_11b_PC_CARD_25", 0x78fc06ee, 0xdb9aa842),
 	PCMCIA_DEVICE_PROD_ID12("ASUS", "802_11B_CF_CARD_25", 0x78fc06ee, 0x45a50c1e),
 	PCMCIA_DEVICE_PROD_ID12("Avaya Communication", "Avaya Wireless PC Card", 0xd8a43b78, 0x0d341169),
 	PCMCIA_DEVICE_PROD_ID12("BENQ", "AWL100 PCMCIA ADAPTER", 0x35dadc74, 0x01f7fedb),
 	PCMCIA_DEVICE_PROD_ID12("BUFFALO", "WLI-PCM-L11G", 0x2decece3, 0xf57ca4b3),
-	PCMCIA_DEVICE_PROD_ID12("BUFFALO", "WLI-CF-S11G", 0x2decece3, 0x82067c18),
 	PCMCIA_DEVICE_PROD_ID12("Cabletron", "RoamAbout 802.11 DS", 0x32d445f5, 0xedeffd90),
-	PCMCIA_DEVICE_PROD_ID12("Compaq", "WL200_11Mbps_Wireless_PCI_Card", 0x54f7c49c, 0x15a75e5b),
-	PCMCIA_DEVICE_PROD_ID123("corega", "WL PCCL-11", "ISL37300P", 0x0a21501a, 0x59868926, 0xc9049a39),
 	PCMCIA_DEVICE_PROD_ID12("corega K.K.", "Wireless LAN PCC-11", 0x5261440f, 0xa6405584),
 	PCMCIA_DEVICE_PROD_ID12("corega K.K.", "Wireless LAN PCCA-11", 0x5261440f, 0xdf6115f9),
 	PCMCIA_DEVICE_PROD_ID12("corega_K.K.", "Wireless_LAN_PCCB-11", 0x29e33311, 0xee7a27ae),
 	PCMCIA_DEVICE_PROD_ID12("D", "Link DRC-650 11Mbps WLAN Card", 0x71b18589, 0xf144e3ac),
-	PCMCIA_DEVICE_PROD_ID12("D", "Link DWL-650 11Mbps WLAN Card", 0x71b18589, 0xb6f1b0ab),
 	PCMCIA_DEVICE_PROD_ID12("D-Link Corporation", "D-Link DWL-650H 11Mbps WLAN Adapter", 0xef544d24, 0xcd8ea916),
 	PCMCIA_DEVICE_PROD_ID12("Digital Data Communications", "WPC-0100", 0xfdd73470, 0xe0b6f146),
 	PCMCIA_DEVICE_PROD_ID12("ELSA", "AirLancer MC-11", 0x4507a33a, 0xef54f0e3),
 	PCMCIA_DEVICE_PROD_ID12("HyperLink", "Wireless PC Card 11Mbps", 0x56cc3f1a, 0x0bcf220c),
-	PCMCIA_DEVICE_PROD_ID123("Instant Wireless ", " Network PC CARD", "Version 01.02", 0x11d901af, 0x6e9bd926, 0x4b74baa0),
-	PCMCIA_DEVICE_PROD_ID12("Intel", "PRO/Wireless 2011 LAN PC Card", 0x816cc815, 0x07f58077),
-	PCMCIA_DEVICE_PROD_ID12("INTERSIL", "HFA384x/IEEE", 0x74c5e40d, 0xdb472a18),
-	PCMCIA_DEVICE_PROD_ID12("INTERSIL", "I-GATE 11M PC Card / PC Card plus", 0x74c5e40d, 0x8304ff77),
-	PCMCIA_DEVICE_PROD_ID12("Intersil", "PRISM 2_5 PCMCIA ADAPTER", 0x4b801a17, 0x6345a0bf),
-	PCMCIA_DEVICE_PROD_ID123("Intersil", "PRISM Freedom PCMCIA Adapter", "ISL37100P", 0x4b801a17, 0xf222ec2d, 0x630d52b2),
 	PCMCIA_DEVICE_PROD_ID12("LeArtery", "SYNCBYAIR 11Mbps Wireless LAN PC Card", 0x7e3b326a, 0x49893e92),
-	PCMCIA_DEVICE_PROD_ID12("Linksys", "Wireless CompactFlash Card", 0x0733cc81, 0x0c52f395),
 	PCMCIA_DEVICE_PROD_ID12("Lucent Technologies", "WaveLAN/IEEE", 0x23eb9949, 0xc562e72a),
 	PCMCIA_DEVICE_PROD_ID12("MELCO", "WLI-PCM-L11", 0x481e0094, 0x7360e410),
 	PCMCIA_DEVICE_PROD_ID12("MELCO", "WLI-PCM-L11G", 0x481e0094, 0xf57ca4b3),
 	PCMCIA_DEVICE_PROD_ID12("Microsoft", "Wireless Notebook Adapter MN-520", 0x5961bf85, 0x6eec8c01),
 	PCMCIA_DEVICE_PROD_ID12("NCR", "WaveLAN/IEEE", 0x24358cd4, 0xc562e72a),
-	PCMCIA_DEVICE_PROD_ID12("NETGEAR MA401 Wireless PC", "Card", 0xa37434e9, 0x9762e8f1),
-	PCMCIA_DEVICE_PROD_ID12("NETGEAR MA401RA Wireless PC", "Card", 0x0306467f, 0x9762e8f1),
-	PCMCIA_DEVICE_PROD_ID12("Nortel Networks", "emobility 802.11 Wireless LAN PC Card", 0x2d617ea0, 0x88cd5767),
-	PCMCIA_DEVICE_PROD_ID12("OEM", "PRISM2 IEEE 802.11 PC-Card", 0xfea54c90, 0x48f2bdd6),
 	PCMCIA_DEVICE_PROD_ID12("OTC", "Wireless AirEZY 2411-PCC WLAN Card", 0x4ac44287, 0x235a6bed),
-	PCMCIA_DEVICE_PROD_ID123("PCMCIA", "11M WLAN Card v2.5", "ISL37300P", 0x281f1c5d, 0x6e440487, 0xc9049a39),
 	PCMCIA_DEVICE_PROD_ID12("PLANEX", "GeoWave/GW-CF110", 0x209f40ab, 0xd9715264),
 	PCMCIA_DEVICE_PROD_ID12("PLANEX", "GeoWave/GW-NS110", 0x209f40ab, 0x46263178),
 	PCMCIA_DEVICE_PROD_ID12("PROXIM", "LAN PC CARD HARMONY 80211B", 0xc6536a5e, 0x090c3cd9),
@@ -520,8 +524,6 @@ static struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("SMC", "SMC2532W-B EliteConnect Wireless Adapter", 0xc4f8b18b, 0x196bd757),
 	PCMCIA_DEVICE_PROD_ID12("SMC", "SMC2632W", 0xc4f8b18b, 0x474a1f2a),
 	PCMCIA_DEVICE_PROD_ID12("Symbol Technologies", "LA4111 Spectrum24 Wireless LAN PC Card", 0x3f02b4d6, 0x3663cb0e),
-	PCMCIA_DEVICE_PROD_ID123("The Linksys Group, Inc.", "Instant Wireless Network PC Card", "ISL37300P", 0xa5f472c2, 0x590eb502, 0xc9049a39),
-	PCMCIA_DEVICE_PROD_ID12("ZoomAir 11Mbps High", "Rate wireless Networking", 0x273fe3db, 0x32a1eaee),
 	PCMCIA_DEVICE_NULL,
 };
 MODULE_DEVICE_TABLE(pcmcia, orinoco_cs_ids);
-- 
1.5.2.4

