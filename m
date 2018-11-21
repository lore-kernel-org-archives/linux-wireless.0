Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CC9C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 691672145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 07:54:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="Whgyt874"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 691672145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbeKUS11 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 13:27:27 -0500
Received: from mail-eopbgr730138.outbound.protection.outlook.com ([40.107.73.138]:59712
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbeKUS10 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 13:27:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ivpPpbNOb2P0MMAFr8OlxU0Po2WiLPJw7PY4QNmDAs=;
 b=Whgyt874QL0GZUbl5J1Yz4SqiQBRgVZ2Y2joR1+R0l3Ppo3P2UV6UTr/FUGM39YB9crgqHF5tKZDhaQjakZIblS9Xo1ivJ3W1NtkXGbwXGbHJW0ifMGlob+ZM+c1KPpoqpRSbZyPBj8TL3xKg7AQ+Wvt8LyBl0Y4sMEOHLS8oug=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1174.namprd06.prod.outlook.com (10.160.195.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Wed, 21 Nov 2018 07:53:47 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::809a:6ca8:db12:f5ae%4]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 07:53:47 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Praveen Babu Chandran <Praveen.Chandran@cypress.com>
Subject: [PATCH V4 4/8] brcmfmac: add support for CYW43012 SDIO chipset
Thread-Topic: [PATCH V4 4/8] brcmfmac: add support for CYW43012 SDIO chipset
Thread-Index: AQHUgW9VW+5dQ8cB00CLGGxEcIiarw==
Date:   Wed, 21 Nov 2018 07:53:47 +0000
Message-ID: <1542786800-146083-5-git-send-email-chi-hsien.lin@cypress.com>
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1174;6:ecGIL7lBtcVW8GzR0+nBSBH+pZ6bFgu63bpBvK8Kuknk8Gt5OaElssojEBcN0G3hcK3neGTCuGJhAGHOxkvFbmpUAV5JurJ9E7JtVNfAaS+ANUeQIer3PD9GEzTmsyMribHZHeOl5YmRAbSpGD9Vj37mV+2qOI8MX0/DrNZVGmsOePBgRd4hORay3k2A9lWdYcdvGeqTsW4pE3s1eSiE60M+0wwAfBK7dxgMBjJiv2TV/s+MuGBigev2kNLe5x4Y5qdRTN+bQM8eZaIZLlp2wMz24STkDIH0eTeLothpGQJPnJn/PtCHfoSHvZ6Zo0bTUbtGpnp5jeX6+ilen7C02JgoTIkLrDI3Empm0FqApiLbaOofpSLS4wTZuJnthnfWuX3uQaja6vKiAF/mviD+d77UU3Mv0mRsmliWsAeiE1Goq0G6HXb4RI52zuCXwjBPbqmceJ/EIjBndq/o2zH2SQ==;5:01xwOWtv/fyhhNhcCaanP7YaA57MIiMb+HosOMC707fLqKR0f4xiE2rPAE81WUMff3g2h171Lq38UqwppbVEAkXlj9fl4++dd4+w74AcgMF/aOk4wbvn3XeYyh/x91TDXmf4Xbv1dAy34EgyViA9mA0zyxuyScwHA91FCzNcCTw=;7:hqSFw+t8WWje5Zc4zwirSg/Tr1QuYYQd9QO2XC3j7w9UkCKVWgDUrpPSoYsKEjerjKgn5OCt9oxBxjUEtXXU8krMNaV00yOdffg59MbAX5kuThO302g6KViG90ZBjlAwEE0697RkZmQOUXWm+RCXpg==
x-ms-office365-filtering-correlation-id: 7cb95394-ae73-45c2-75c5-08d64f867752
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1174;
x-ms-traffictypediagnostic: BY1PR0601MB1174:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-microsoft-antispam-prvs: <BY1PR0601MB11749A9DD6341E8508420B2EBBDA0@BY1PR0601MB1174.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(93006095)(93001095)(3231442)(944501410)(52105112)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1174;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1174;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(107886003)(478600001)(36756003)(72206003)(97736004)(8676002)(81166006)(81156014)(186003)(68736007)(6916009)(8936002)(71190400001)(54906003)(2906002)(316002)(25786009)(2501003)(71200400001)(6116002)(3846002)(99286004)(6436002)(2351001)(256004)(305945005)(6486002)(76176011)(7736002)(105586002)(6506007)(4326008)(386003)(52116002)(5640700003)(102836004)(66066001)(2616005)(106356001)(476003)(14454004)(486006)(26005)(11346002)(86362001)(53936002)(2900100001)(446003)(6512007)(5660300001)(575784001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1174;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: UyIHyucFb8aogXJyZLbkyH+e8rfDHjuP0Kk5uvTEzrsY+ivlPWL6vnIEGcDwHQLQaoj13CVo0mkjXrumwZHES6vfp0/RDQcaPyZAK2C6mGWnp865kSiu67n5Vbt75nyyDavVOQMDeEwKl6K1o51t7cah3gPobM+HyXvxJQfbkJcgDjLdwQuVHqAjzSxmpnquwpw5lzFAAiORprMCsy0iXlNDj0XxqTvBdSTFTChvkf4cT4aw6r2Ewwv7ihxQePBJ9zClEXpUYGNqYf76oPVxZLDCRb16cLNvAeUnMvmrLCHoSiD8pfJK5LHLHRIx3wr0BPIKDHwiMSWP5sUgB5Bajg4IAHKVMCV6Uf/Cdx3n3P4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb95394-ae73-45c2-75c5-08d64f867752
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 07:53:47.0296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1174
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

CYW43012 is a 1x1 802.11a/b/g/n Dual-Band HT20, 256-QAM/Turbo QAM. It
is an Ultra Low Power WLAN+BT combo chip.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Praveen Babu C <praveen.chandran@cypress.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    | 14 +++-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 74 ++++++++++++++++++=
----
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |  1 +
 include/linux/mmc/sdio_ids.h                       |  1 +
 5 files changed, 78 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/dr=
ivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index b2ad2122c8c4..d64bf233b12c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -983,6 +983,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] =
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
index 927d62b3d41b..a3c857721446 100644
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
@@ -1356,6 +1363,11 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		addr =3D CORE_CC_REG(base, sr_control1);
 		reg =3D chip->ops->read32(chip->ctx, addr);
 		return reg !=3D 0;
+	case CY_CC_43012_CHIP_ID:
+		addr =3D CORE_CC_REG(pmu->base, retention_ctl);
+		reg =3D chip->ops->read32(chip->ctx, addr);
+		return (reg & (PMU_RCTL_MACPHY_DISABLE_MASK |
+			       PMU_RCTL_LOGIC_DISABLE_MASK)) =3D=3D 0;
 	default:
 		addr =3D CORE_CC_REG(pmu->base, pmucapabilities_ext);
 		reg =3D chip->ops->read32(chip->ctx, addr);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 7a0601543dff..73a034172c4c 100644
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
@@ -677,6 +679,14 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on=
)
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
=20
+	/* In case of 43012 chip, the chip could go down immediately after
+	 * KSO bit is cleared. So the further reads of KSO register could
+	 * fail. Thereby just bailing out immediately after clearing KSO
+	 * bit, to avoid polling of KSO bit.
+	 */
+	if (!on && bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID)
+		return err;
+
 	if (on) {
 		/* device WAKEUP through KSO:
 		 * write bit 0 & read back until
@@ -2402,6 +2412,14 @@ static int brcmf_sdio_tx_ctrlframe(struct brcmf_sdio=
 *bus, u8 *frame, u16 len)
 	return ret;
 }
=20
+static bool brcmf_chip_is_ulp(struct brcmf_chip *ci)
+{
+	if (ci->chip =3D=3D CY_CC_43012_CHIP_ID)
+		return true;
+	else
+		return false;
+}
+
 static void brcmf_sdio_bus_stop(struct device *dev)
 {
 	struct brcmf_bus *bus_if =3D dev_get_drvdata(dev);
@@ -2409,7 +2427,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 	struct brcmf_sdio *bus =3D sdiodev->bus;
 	struct brcmf_core *core =3D bus->sdio_core;
 	u32 local_hostintmask;
-	u8 saveclk;
+	u8 saveclk, bpreq;
 	int err;
=20
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2436,9 +2454,14 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		/* Force backplane clocks to assure F2 interrupt propagates */
 		saveclk =3D brcmf_sdiod_readb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 					    &err);
-		if (!err)
-			brcmf_sdiod_writeb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-					   (saveclk | SBSDIO_FORCE_HT), &err);
+		if (!err) {
+			bpreq =3D saveclk;
+			bpreq |=3D brcmf_chip_is_ulp(bus->ci) ?
+				SBSDIO_HT_AVAIL_REQ : SBSDIO_FORCE_HT;
+			brcmf_sdiod_writeb(sdiodev,
+					   SBSDIO_FUNC1_CHIPCLKCSR,
+					   bpreq, &err);
+		}
 		if (err)
 			brcmf_err("Failed to force clock for F2: err %d\n",
 				  err);
@@ -3328,20 +3351,45 @@ static int brcmf_sdio_download_firmware(struct brcm=
f_sdio *bus,
 	return bcmerror;
 }
=20
+static bool brcmf_sdio_aos_no_decode(struct brcmf_sdio *bus)
+{
+	if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID)
+		return true;
+	else
+		return false;
+}
+
 static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 {
 	int err =3D 0;
 	u8 val;
+	u8 wakeupctrl;
+	u8 cardcap;
+	u8 chipclkcsr;
=20
 	brcmf_dbg(TRACE, "Enter\n");
=20
+	if (brcmf_chip_is_ulp(bus->ci)) {
+		wakeupctrl =3D SBSDIO_FUNC1_WCTRL_ALPWAIT_SHIFT;
+		chipclkcsr =3D SBSDIO_HT_AVAIL_REQ;
+	} else {
+		wakeupctrl =3D SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
+		chipclkcsr =3D SBSDIO_FORCE_HT;
+	}
+
+	if (brcmf_sdio_aos_no_decode(bus)) {
+		cardcap =3D SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC;
+	} else {
+		cardcap =3D (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
+			   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT);
+	}
+
 	val =3D brcmf_sdiod_readb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
 	if (err) {
 		brcmf_err("error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
-
-	val |=3D 1 << SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
+	val |=3D 1 << wakeupctrl;
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, val, &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_WAKEUPCTRL\n");
@@ -3350,8 +3398,7 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus=
)
=20
 	/* Add CMD14 Support */
 	brcmf_sdiod_func0_wb(bus->sdiodev, SDIO_CCCR_BRCM_CARDCAP,
-			     (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
-			      SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT),
+			     cardcap,
 			     &err);
 	if (err) {
 		brcmf_err("error writing SDIO_CCCR_BRCM_CARDCAP\n");
@@ -3359,7 +3406,7 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus=
)
 	}
=20
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-			   SBSDIO_FORCE_HT, &err);
+			   chipclkcsr, &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_CHIPCLKCSR\n");
 		return;
@@ -4051,7 +4098,7 @@ static void brcmf_sdio_firmware_callback(struct devic=
e *dev, int err,
 	const struct firmware *code;
 	void *nvram;
 	u32 nvram_len;
-	u8 saveclk;
+	u8 saveclk, bpreq;
 	u8 devctl;
=20
 	brcmf_dbg(TRACE, "Enter: dev=3D%s, err=3D%d\n", dev_name(dev), err);
@@ -4085,8 +4132,11 @@ static void brcmf_sdio_firmware_callback(struct devi=
ce *dev, int err,
 	/* Force clocks on backplane to be sure F2 interrupt propagates */
 	saveclk =3D brcmf_sdiod_readb(sdiod, SBSDIO_FUNC1_CHIPCLKCSR, &err);
 	if (!err) {
+		bpreq =3D saveclk;
+		bpreq |=3D brcmf_chip_is_ulp(bus->ci) ?
+			SBSDIO_HT_AVAIL_REQ : SBSDIO_FORCE_HT;
 		brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_CHIPCLKCSR,
-				   (saveclk | SBSDIO_FORCE_HT), &err);
+				   bpreq, &err);
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

