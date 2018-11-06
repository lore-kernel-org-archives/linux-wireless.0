Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C5AC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7565A20818
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 03:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="nF7qiRyZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7565A20818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbeKFNNo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 08:13:44 -0500
Received: from mail-eopbgr810120.outbound.protection.outlook.com ([40.107.81.120]:58734
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729628AbeKFNNo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 08:13:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJAT+SxHmfNnr8AnIdsXmBWz92ZbcFSvW3usvTAD/tA=;
 b=nF7qiRyZQ7Y/VTY5kf1Qzm0BiedR9FGNGMozjryeZamV+mmVnaT57pj8ET5EwTU0YPplVpUI4/gb1YBrWs/dEp5yatR7rK9NSvIrbPI7u2MFgPW3K6Y3jOFJ2Vb9cOOUxsS5Z/yXJHudFOvGJNxWal9kXusg+LM9yKPNJbVQ3LI=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1142.namprd06.prod.outlook.com (10.160.196.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Tue, 6 Nov 2018 03:50:23 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.032; Tue, 6 Nov 2018
 03:50:23 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Praveen Babu Chandran <Praveen.Chandran@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH 06/11] brcmfmac: saverestore support changes for 43012
Thread-Topic: [PATCH 06/11] brcmfmac: saverestore support changes for 43012
Thread-Index: AQHUdYPYR8zoDI+kq0mivIEV6A+foQ==
Date:   Tue, 6 Nov 2018 03:50:23 +0000
Message-ID: <1541476188-75475-7-git-send-email-chi-hsien.lin@cypress.com>
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
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1142;6:3/LmfYgsKtcaZ01Nj9gNBEwHpsn2Ek25UQI1YUX2kF4YqNS9Puup2Zm9r2jDfd3dtzLjPpHy1T9nsH6ODHKCRNnjmkoG8+8kqU3cDlnAAE+7VUoGwCY+sCZXKPgLHDiog7FZf3wjqq6aLViqsxtDag8AtLGIyWm09BNJshYGoZXSne5BgL7NCRUyPARqoxvOQ98hHsDVvbYtuJ1zGi3GJtabGe6TLG8/NPqr2yNlP7AZPR5CmqBlwBUGIsdC3rGM3OVAf1CsOJ46+qfkzIhBl8h8KZfhAcbeqfFcOZYvtB2oilHtoyhh9fiQM7Bsb+NLMyj3eeEYR2V1VRZ9aRiOcSCa4gOYoMhsm/w8nPUW93o6zblY4jWb/CcNLXdm512cGIhoDkgxiTvCuFAx9XFYiLR8bD0vsTgZRXrsojDT3hhDLXvQWyZ8LgEVBjWy7U8lJ1jlfj3QP7gsIqe/186g1g==;5:g12pGh5erAkaAfKHHCqHXxQExmu/OQN8ngRoUWJJW5OgN6984Depwnw1gGfjfLdyBsg1gNqA/dY1SKpS5cWwULrgtWvmSA6wWfgB3N29NGORitMdFwBY26FF6CbCcrC+qnc0HNJ1CcZ1O9KvGOGj+XYjDPQ2EeNTm1w+zrMI77E=;7:sZ46mBGA5iKu8V53mFRUES/SQULSiOy7zYYjpOBA6NJtsbrN+rVSzTsIQW7HBd2FCqULeun1pNpyx1ZsfE9AwGZ5NMuj27kZ6fgXv0X68qZTL2xwsG1rRU/CkFA1XdZ9ubLNr3JNpEayfvmwAIqzCg==
x-ms-office365-filtering-correlation-id: b9997e13-bb4c-491e-f759-08d6439afa88
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1142;
x-ms-traffictypediagnostic: BY1PR0601MB1142:
x-microsoft-antispam-prvs: <BY1PR0601MB11422A9D57E79135199CBD41BBCB0@BY1PR0601MB1142.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105095)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123562045)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1142;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1142;
x-forefront-prvs: 0848C1A6AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(6506007)(36756003)(386003)(102836004)(186003)(2906002)(6916009)(8936002)(54906003)(5660300001)(81156014)(5640700003)(81166006)(14454004)(26005)(8676002)(476003)(486006)(2351001)(2616005)(446003)(97736004)(11346002)(6436002)(106356001)(105586002)(6512007)(256004)(6486002)(4326008)(3846002)(6116002)(7736002)(68736007)(99286004)(72206003)(53936002)(305945005)(76176011)(66066001)(2501003)(107886003)(86362001)(316002)(71200400001)(71190400001)(52116002)(25786009)(478600001)(2900100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1142;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: XuqR6H8dSRJ9HHUihB8NPlENQWjPhdT1w/dntNopq9ayyzUspaVfJqBS/uRPWeYptQQYEoXGHLHbjDs0zZGzR2AH82151SgSIuDU2nAWAAapzwRZ72z+LCBhchE7WQzsXm84YrjjG8K9yFCodjY/6Dgmn7lhq/6nBhjATEcays63kjO0X4XRFm2LGMtpFYoM9y2tE6Av2/nu9uMcBp2LpHsuLhfomCAicd2ZxgNAU8pCJEWESKRAGLN6bwvDLMb3JlAJw2towZlWSyoA+GJcdMGwZ+pxZHgB3LQJiOfIof32wgi/SQxztPlsO/CCJMAyzzv+iQ1cFUwsf9/vedoXek7U/7RBKEeQULqC0SLs3o0=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9997e13-bb4c-491e-f759-08d6439afa88
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2018 03:50:23.2132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1142
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Praveen Babu C <praveen.chandran@cypress.com>

Add saverestore register settings for 43012.

Signed-off-by: Praveen Babu C <praveen.chandran@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  5 +++++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 22 +++++++++++++++++-=
----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 7d5005d75e01..a8d3b96b727f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1365,6 +1365,11 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
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
index 299f59f58d8c..a32eb5f868b5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3354,16 +3354,29 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *b=
us)
 {
 	int err =3D 0;
 	u8 val;
+	u8 wakeupctrl;
+	u8 cardcap;
+	u8 chipclkcsr;
=20
 	brcmf_dbg(TRACE, "Enter\n");
=20
+	if (bus->ci->chip =3D=3D CY_CC_43012_CHIP_ID) {
+		wakeupctrl =3D SBSDIO_FUNC1_WCTRL_ALPWAIT_SHIFT;
+		cardcap =3D SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC;
+		chipclkcsr =3D SBSDIO_HT_AVAIL_REQ;
+	} else {
+		wakeupctrl =3D SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
+		cardcap =3D (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
+				   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT);
+		chipclkcsr =3D SBSDIO_FORCE_HT;
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
@@ -3372,8 +3385,7 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus=
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
@@ -3381,7 +3393,7 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus=
)
 	}
=20
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-			   SBSDIO_FORCE_HT, &err);
+			   chipclkcsr, &err);
 	if (err) {
 		brcmf_err("error writing SBSDIO_FUNC1_CHIPCLKCSR\n");
 		return;
--=20
2.1.0

