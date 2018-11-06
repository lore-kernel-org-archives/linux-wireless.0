Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30FDC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4FA420818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="BmbeHItz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4FA420818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbeKFNNm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:13:42 -0500
Received: from mail-eopbgr810120.outbound.protection.outlook.com ([40.107.81.120]:58734
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729628AbeKFNNm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:13:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Efi3va6LFy4PyPNTy0dlJ3j4dVbq0Oe2qjH6de9WAzc=;
 b=BmbeHItz+4K8eEkOwgHg1q5p4o2Ck0TRndRhNXPOvK67UXGhzn18NQFGp2G9Ozoc48fflSnSfrh2DTuACT+rPmOCJU3NKBRnDrIMJcaB8bPDLXYrI+gaZ8KbqQKusyoEZ84b7ueoX2qE//PXX0zFJvo5MU3Ej9bgsQr+3yibFts=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:20 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:20 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 04/11] brcmfmac: add support for CYW43012 SDIO chipset
Thread-Topic: [PATCH 04/11] brcmfmac: add support for CYW43012 SDIO chipset
Thread-Index: AQHUdYPWpm0KZ+LuEUeOEYV1k1antw==
Date:   Tue, 6 Nov 2018 03:50:20 +0000
Message-ID: <1541476188-75475-5-git-send-email-chi-hsien.lin@cypress.com>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: MWHPR2201CA0082.namprd22.prod.outlook.com
 (2603:10b6:301:5e::35) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:Qhy2E8EHCkHKmEfVuJjyCAW+/FAwNpe992UUB9aF8nThSrHHs55CtLv8HW1WG3FWm9DDnE4lAzXnPU/DVJuai+o3rx2dI23hzHDo7git1Tn9R5ailvwrrstlNinlBcCTuIHD3JYRBooYYkzoCBgOEXpX0ixP5OlwDSF6984b2xfxrgOHdA6xzn4K4yJ4qWZDxt8NKJwLXjPlhZw3esvqSmVsCwnXRiZHBe74hMFgVC2LDnfZUO7DsbAqloSIKLzcJc4Hj3aRbeZlqrvmWXszrATGZ1Ac0arKvX0w1VuX5TaKHS5Rjgps3482cScFNaDnCi1GljRydZjVmKw9FOg9yGkNpEscQjhWnJeA4Laq8LrTDc0T13C92glLXiGn9W1EQURBUZYSldnOtqVkLIXlsUrX9KVv9BH3OPOfx8KYYmeIcWBUIoO1piuDM3GDf6wZuaYxy5HFvgca6Kg0iloarw==;5:ATEJBPqbk22VtOgUIeoFQU6q7mm0c8sia0cqlYTzBY/sNKCQdOWd1z7eQPmrFx058Y7JYNoX7XpGaLLl3SDaMSuzLPSCpWtFaIgLRG+Sr49f4YEDLjRwnRGB/bEuw0/A2lWrSPKJfKP4W8Ejj4mkSlt7Vhd9uw2LPWFI1Wo+yjs=;7:dUZQt9KCUIm5l/RCj9zvBLnnPAeJc0xA0UgJchoHDVRCVZ9cXUamBcQuI5hs+mu62W2AtFR14zA6SRB/zG5pgSeFjQA/fsbtL343B5crX+XvSKXov5K8KC5qFgvQvcHeFpgzD9QZtpGTrZ+5h5ds3w==
x-ms-office365-filtering-correlation-id: 28f8d581-956a-4321-e552-08d6439af8b6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB1142BBE068A41848CF63F77EBBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(575784001)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: IyXwpUQuLdmDdO1mhBPvIBQ8XcSal8egrsl/0Jh7GQ7GIcdMV5tcCaYhRkfEbVsIyRIhXSrBSUEFfsew9nO4nHajep7PF1y/ef47FK2nRBA3+P4wLrDYZxcuKs7tUVR0sE8UgbkRxAN2+DjYw/avQaFXm7n5U05Nz4fIqa/8MVKSKkRE0lpWYF3eNC365zZ63TeCtJLzMWCd6YSBHl8Tpq9iVP8nKuZ66QhOMa51Gms/XA0x0w5Dc2XJtA1fTkOkKQO4kfY8SHpo5VpJ9NEAe5PIobj3GMm8rQAHBI+yLMBUgKNI88I5JTQS5WPwG6e0NZamXqCTchNJq4ArfvkwDRqt8JeiYvEUyKiDBHaYoPI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f8d581-956a-4321-e552-08d6439af8b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:20.1268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

CYW43012 is a 1x1 802.11a/b/g/n Dual-Band HT20, 256-QAM/Turbo QAM. It
is an Ultra Low Power WLAN+BT combo chip.

Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  9 ++++-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 40 ++++++++++++++++++=
----
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |  1 +
 include/linux/mmc/sdio_ids.h                       |  1 +
 5 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/dr=
ivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 3e37c8cf82c6..c1d4f93f7347 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -972,6 +972,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] =
=3D {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_4373),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_43012),
 	{ /* end: all zeroes */ }
 };
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 927d62b3d41b..60fd3018534e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -165,6 +165,7 @@ struct sbconfig {
 #define SRCI_LSS_MASK		0x00f00000
 #define SRCI_LSS_SHIFT		20
 #define	SRCI_SRNB_MASK		0xf0
+#define	SRCI_SRNB_MASK_EXT	0x100
 #define	SRCI_SRNB_SHIFT		4
 #define	SRCI_SRBSZ_MASK		0xf
 #define	SRCI_SRBSZ_SHIFT	0
@@ -592,7 +593,13 @@ static void brcmf_chip_socram_ramsize(struct brcmf_cor=
e_priv *sr, u32 *ramsize,
 		if (lss !=3D 0)
 			*ramsize +=3D (1 << ((lss - 1) + SR_BSZ_BASE));
 	} else {
-		nb =3D (coreinfo & SRCI_SRNB_MASK) >> SRCI_SRNB_SHIFT;
+		/* length of SRAM Banks increased for corerev greater than 23 */
+		if (sr->pub.rev >=3D 23) {
+			nb =3D (coreinfo & (SRCI_SRNB_MASK | SRCI_SRNB_MASK_EXT))
+				>> SRCI_SRNB_SHIFT;
+		} else {
+			nb =3D (coreinfo & SRCI_SRNB_MASK) >> SRCI_SRNB_SHIFT;
+		}
 		for (i =3D 0; i < nb; i++) {
 			retent =3D brcmf_chip_socram_banksize(sr, i, &banksize);
 			*ramsize +=3D banksize;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 34a838fcc319..299f59f58d8c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -624,6 +624,7 @@ BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
 BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
 BRCMF_FW_DEF(4356, "brcmfmac4356-sdio");
 BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
+BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
=20
 static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] =3D {
 	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
@@ -643,7 +644,8 @@ static const struct brcmf_firmware_mapping brcmf_sdio_f=
wnames[] =3D {
 	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFFC0, 43455),
 	BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
 	BRCMF_FW_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
-	BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373)
+	BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373),
+	BRCMF_FW_ENTRY(CY_CC_43012_CHIP_ID, 0xFFFFFFFF, 43012)
 };
=20
 static void pkt_align(struct sk_buff *p, int len, int align)
@@ -677,6 +679,15 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on=
)
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
=20
+	/* In case of 43012 chip, the chip could go down immediately after
+	 * KSO bit is cleared. So the further reads of KSO register could
+	 * fail. Thereby just bailing out immediately after clearing KSO
+	 * bit, to avoid polling of KSO bit.
+	 */
+	if (!on && bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID) {
+		return err;
+	}
+
 	if (on) {
 		/* device WAKEUP through KSO:
 		 * write bit 0 & read back until
@@ -2436,9 +2447,20 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		/* Force backplane clocks to assure F2 interrupt propagates */
 		saveclk =3D brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 					    &err);
-		if (!err)
-			brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-					   (saveclk | SBSDIO_FORCE_HT), &err);
+		if (!err) {
+			if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID) {
+				brcmf_sdiod_writeb(sdiodev,
+						   SBSDIO_FUNC1_CHIPCLKCSR,
+						   (saveclk |
+						    SBSDIO_HT_AVAIL_REQ),
+						   &err);
+			} else {
+				brcmf_sdiod_writeb(sdiodev,
+						   SBSDIO_FUNC1_CHIPCLKCSR,
+						   (saveclk | SBSDIO_FORCE_HT),
+						   &err);
+			}
+		}
 		if (err)
 			brcmf_err("Failed to force clock for F2: err %d\n",
 				  err);
@@ -4085,8 +4107,14 @@ static void brcmf_sdio_firmware_callback(struct devi=
ce *dev, int err,
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
 	saveclk =3D brcmf_sdiod_readb(sdiod, SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
-		brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_CHIPCLKCSR,
-				   (saveclk | SBSDIO_FORCE_HT), &err);
+		if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID) {
+			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_CHIPCLKCSR,
+					   (saveclk | SBSDIO_HT_AVAIL_REQ),
+					   &err);
+		} else {
+			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_CHIPCLKCSR,
+					   (saveclk | SBSDIO_FORCE_HT), &err);
+		}
 	}
 	if (err) {
 		brcmf_err("Failed to force clock for F2: err %d\n", err);
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h =
b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index acb87238922f..839980da9643 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -60,6 +60,7 @@
 #define BRCM_CC_43664_CHIP_ID		43664
 #define BRCM_CC_4371_CHIP_ID		0x4371
 #define CY_CC_4373_CHIP_ID		0x4373
+#define CY_CC_43012_CHIP_ID		43012
=20
 /* USB Device IDs */
 #define BRCM_USB_43143_DEVICE_ID	0xbd1e
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 4224902a8e22..4332199c71c2 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -42,6 +42,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
 #define SDIO_DEVICE_ID_BROADCOM_4356		0x4356
 #define SDIO_DEVICE_ID_CYPRESS_4373		0x4373
+#define SDIO_DEVICE_ID_CYPRESS_43012		43012
=20
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
--=20
2.1.0

