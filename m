Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC0DC282CB
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E69C20863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="PHMlww6v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfBIHNI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:13:08 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:14154 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfBIHNI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:13:08 -0500
X-IronPort-AV: E=Sophos;i="5.58,350,1544511600"; 
   d="scan'208";a="23610418"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 09 Feb 2019 00:13:07 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.37) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:13:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmnZYU6N5ki8wtVhbuCaV6KPVF2omqoT3quEs2RrQGg=;
 b=PHMlww6vRWyIlSmoskU0FPlXYYLUhtvPO3QIyHBgclUOeBe5uO76Ok9JBFInAvaIzf0WOWILednC+P72KZb83k67FpQqPKwCfXQZJ7DSZoZo1VhjjFHYc52dWTC6oY/eCeKy4bS7xPT7jjzqRNu1Jvs2HXnZ7CxaYBD2uHMOeJo=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3077.namprd11.prod.outlook.com (20.177.226.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Sat, 9 Feb 2019 07:13:05 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:13:05 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 16/16] wilc1000: add Makefile and Kconfig files for wilc1000
 compilation
Thread-Topic: [PATCH 16/16] wilc1000: add Makefile and Kconfig files for
 wilc1000 compilation
Thread-Index: AQHUwEbmKfjeluefPka6jQG2YTtkjA==
Date:   Sat, 9 Feb 2019 07:13:04 +0000
Message-ID: <1549696298-9795-17-git-send-email-ajay.kathat@microchip.com>
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::31) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3077;6:1OK/J8rcsmQBue6hM9y37AEpUOR5eqKgCsQvtvZeSLGTSkAwyKBqc/akGlggAQd+/jrreNKABLVYDsD7cSYCQq2MTBVKra8uhq9L24W+1c9OMKs4458NX/qmw/Lw+Pv9ZZ5r5Oz9nhgeKJX7CsBC8WmgUiyuFgdjC7kvvD2O8sBKdHYy9uxcHUrlZjt2I9bJhHUMbt2sYE4M/rqDR9yiXGNFqc8HqRvi+YS9vzluhoH36hdc0XctrvxN8XEVBPp2pPvJ/MarPZOm8oMgQxcP0mpcG395kgk946ZB/brobRpZgl33u0kG01RT2TbocC1+4JR98mS0Vr81VAEqq8veWjGjj2BoWK9ybFLAGVLbaiXCZXP3nWuvg55BYReOkgWHTmkWk2NGQ2he4nCORK0HQF6hNPFrdmOWHPbiU7Mbcq5GRHTJhayJYsdR0GVjfgvsoQU92r1+YkSLcwBsI0GvGQ==;5:CuRE+cOCVEGNCKf4ag2Q8SDmUbG/F9RcUKiGZUfX8OjTJ4gqT4qIs5+fAvVXn7vi6f3N0fem+U6zmnHJCR8wPXROQa0fd/CpwWLMtt2n1aoil9z9rKXRvvo6kAIB2KlESXqFawbBNVesU56ygEcVXtnziCIZ2GrNPMR0hAmuT6MxM5uQTGeux8wznwuqBZ88jldnZUp8Thtvjagazs3aaA==;7:voePPk/iV36NKx7kYF+OUJjEM7/LMI4ciPOAVnwZJyPD13Wny7xalAngL/aS3RSkEvPDp9Ulg+yn5kp+AKtPBI0VmxsaSuDgqKCxXNyfRN4WFy788XOySsGKsHqxJW7YEPgpWAlgTL1ie36YxuMLeQ==
x-ms-office365-filtering-correlation-id: f3266285-43a0-4bd7-1299-08d68e5e08bc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3077;
x-ms-traffictypediagnostic: BYAPR11MB3077:
x-microsoft-antispam-prvs: <BYAPR11MB3077298DDB8DA1E901685410E36A0@BYAPR11MB3077.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(39860400002)(136003)(366004)(199004)(189003)(81166006)(8676002)(81156014)(97736004)(386003)(6506007)(14454004)(99286004)(305945005)(486006)(72206003)(6916009)(53936002)(102836004)(478600001)(7736002)(8936002)(26005)(186003)(36756003)(50226002)(54906003)(256004)(2616005)(476003)(11346002)(446003)(68736007)(105586002)(106356001)(5640700003)(2351001)(6116002)(3846002)(52116002)(316002)(6436002)(66066001)(107886003)(25786009)(4326008)(2501003)(2906002)(76176011)(78486014)(6486002)(86362001)(71200400001)(71190400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3077;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: //pFcN5rSrgNjO3oDZLkrrAaJELie2h3Sf9saJcfY400RINuS6E4JWnfpiaEEwZ6bMSEvWo1COdZVGmDMSu1rPLJDCtPqDG7Q4B9x5RynR4UjPk/ahsp2SyTb0olIklb2IQ+iAeViFCQZLy/13FmJnuFPpVyV7G4KIonThgCaLk1use96iLDugfMolsjLF4RVhqc46jSqn73Pmw49Jt5d1H9my7k9Gr235DD4oOCcIf1QL8Gtw0ICSU+eG5579pZEigAhyDz5qcQwPyCqeZTfOYAH78qIZj6AGSw39ZEGi8EqYZ+Amy1ZaglsVl0KWxLKONaEx9BzoSjKgiiMPeSAzagdMp0moaIsy5c/YD4J4aCfCPqB8lNosfXJ7BCMw0iRZ9lkUJobLaBp9v5ffbfVqocT8NpI2AfPBxkFUyRtoQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f3266285-43a0-4bd7-1299-08d68e5e08bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:13:01.7769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3077
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Added Makefile and Kconfig for compiling the wilc1000 module from
'drivers/net/wireless/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/net/wireless/Kconfig                     |  1 +
 drivers/net/wireless/Makefile                    |  1 +
 drivers/net/wireless/microchip/Kconfig           | 14 ++++++++
 drivers/net/wireless/microchip/Makefile          |  2 ++
 drivers/net/wireless/microchip/wilc1000/Kconfig  | 42 ++++++++++++++++++++=
++++
 drivers/net/wireless/microchip/wilc1000/Makefile | 14 ++++++++
 drivers/staging/Kconfig                          |  2 --
 drivers/staging/Makefile                         |  1 -
 8 files changed, 74 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/microchip/Kconfig
 create mode 100644 drivers/net/wireless/microchip/Makefile
 create mode 100644 drivers/net/wireless/microchip/wilc1000/Kconfig
 create mode 100644 drivers/net/wireless/microchip/wilc1000/Makefile

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8c456a6..cc3a2ef 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -46,6 +46,7 @@ source "drivers/net/wireless/st/Kconfig"
 source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zydas/Kconfig"
 source "drivers/net/wireless/quantenna/Kconfig"
+source "drivers/net/wireless/microchip/Kconfig"
=20
 config PCMCIA_RAYCS
 	tristate "Aviator/Raytheon 2.4GHz wireless support"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 6cfe745..f9a51c2 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_WLAN_VENDOR_ST) +=3D st/
 obj-$(CONFIG_WLAN_VENDOR_TI) +=3D ti/
 obj-$(CONFIG_WLAN_VENDOR_ZYDAS) +=3D zydas/
 obj-$(CONFIG_WLAN_VENDOR_QUANTENNA) +=3D quantenna/
+obj-$(CONFIG_WLAN_VENDOR_MICROCHIP) +=3D microchip/
=20
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+=3D ray_cs.o
diff --git a/drivers/net/wireless/microchip/Kconfig b/drivers/net/wireless/=
microchip/Kconfig
new file mode 100644
index 0000000..24b5e443
--- /dev/null
+++ b/drivers/net/wireless/microchip/Kconfig
@@ -0,0 +1,14 @@
+config WLAN_VENDOR_MICROCHIP
+	bool "Microchip devices"
+	default y
+	---help---
+	If you have a wireless card belonging to this class, say Y.
+
+	Note that the answer to this question doesn't directly affect the
+	kernel: saying N will just cause the configurator to skip all the
+	questions about these cards. If you say Y, you will be asked for
+	your specific card in the following questions.
+
+if WLAN_VENDOR_MICROCHIP
+source "drivers/net/wireless/microchip/wilc1000/Kconfig"
+endif # WLAN_VENDOR_MICROCHIP
diff --git a/drivers/net/wireless/microchip/Makefile b/drivers/net/wireless=
/microchip/Makefile
new file mode 100644
index 0000000..73b763c
--- /dev/null
+++ b/drivers/net/wireless/microchip/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_WILC1000)		+=3D wilc1000/
diff --git a/drivers/net/wireless/microchip/wilc1000/Kconfig b/drivers/net/=
wireless/microchip/wilc1000/Kconfig
new file mode 100644
index 0000000..f1a693b
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/Kconfig
@@ -0,0 +1,42 @@
+config WILC1000
+	tristate
+	help
+	  This module only support IEEE 802.11n WiFi.
+
+config WILC1000_SDIO
+	tristate "WILC1000 SDIO (WiFi only)"
+	depends on CFG80211 && INET && MMC
+	select WILC1000
+	help
+	  This module adds support for the SDIO interface of adapters using
+	  WILC1000 chipset. The Atmel WILC1000 SDIO is a full speed interface.
+	  It meets SDIO card specification version 2.0. The interface supports
+	  the 1-bit/4-bit SD transfer mode at the clock range of 0-50 MHz.
+	  The host can use this interface to read and write from any register
+	  within the chip as well as configure the WILC1000 for data DMA.
+	  To use this interface, pin9 (SDIO_SPI_CFG) must be grounded. Select
+	  this if your platform is using the SDIO bus.
+
+config WILC1000_SPI
+	tristate "WILC1000 SPI (WiFi only)"
+	depends on CFG80211 && INET && SPI
+	select WILC1000
+	help
+	  This module adds support for the SPI interface of adapters using
+	  WILC1000 chipset. The Atmel WILC1000 has a Serial Peripheral
+	  Interface (SPI) that operates as a SPI slave. This SPI interface can
+	  be used for control and for serial I/O of 802.11 data. The SPI is a
+	  full-duplex slave synchronous serial interface that is available
+	  immediately following reset when pin 9 (SDIO_SPI_CFG) is tied to
+	  VDDIO. Select this if your platform is using the SPI bus.
+
+config WILC1000_HW_OOB_INTR
+	bool "WILC1000 out of band interrupt"
+	depends on WILC1000_SDIO
+	default n
+	help
+	  This option enables out-of-band interrupt support for the WILC1000
+	  chipset. This OOB interrupt is intended to provide a faster interrupt
+	  mechanism for SDIO host controllers that don't support SDIO interrupt.
+	  Select this option If the SDIO host controller in your platform
+	  doesn't support SDIO time devision interrupt.
diff --git a/drivers/net/wireless/microchip/wilc1000/Makefile b/drivers/net=
/wireless/microchip/wilc1000/Makefile
new file mode 100644
index 0000000..2ad3fee
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/Makefile
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_WILC1000) +=3D wilc1000.o
+
+ccflags-y +=3D -DFIRMWARE_1002=3D\"atmel/wilc1002_firmware.bin\" \
+		-DFIRMWARE_1003=3D\"atmel/wilc1003_firmware.bin\"
+
+wilc1000-objs :=3D wilc_wfi_cfgoperations.o wilc_netdev.o wilc_mon.o \
+			host_interface.o wilc_wlan_cfg.o wilc_wlan.o
+
+obj-$(CONFIG_WILC1000_SDIO) +=3D wilc1000-sdio.o
+wilc1000-sdio-objs +=3D wilc_sdio.o
+
+obj-$(CONFIG_WILC1000_SPI) +=3D wilc1000-spi.o
+wilc1000-spi-objs +=3D wilc_spi.o
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index e4f6088..8a30ce4 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -88,8 +88,6 @@ source "drivers/staging/fbtft/Kconfig"
=20
 source "drivers/staging/fsl-dpaa2/Kconfig"
=20
-source "drivers/staging/wilc1000/Kconfig"
-
 source "drivers/staging/most/Kconfig"
=20
 source "drivers/staging/ks7010/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 5868631..86a6c50 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -34,7 +34,6 @@ obj-$(CONFIG_UNISYSSPAR)	+=3D unisys/
 obj-$(CONFIG_COMMON_CLK_XLNX_CLKWZRD)	+=3D clocking-wizard/
 obj-$(CONFIG_FB_TFT)		+=3D fbtft/
 obj-$(CONFIG_FSL_DPAA2)		+=3D fsl-dpaa2/
-obj-$(CONFIG_WILC1000)		+=3D wilc1000/
 obj-$(CONFIG_MOST)		+=3D most/
 obj-$(CONFIG_KS7010)		+=3D ks7010/
 obj-$(CONFIG_GREYBUS)		+=3D greybus/
--=20
2.7.4

