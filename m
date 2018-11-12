Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18CCC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9657521722
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 07:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cypress.com header.i=@cypress.com header.b="aQHXyDlD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9657521722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cypress.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbeKLRVx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 12:21:53 -0500
Received: from mail-eopbgr760111.outbound.protection.outlook.com ([40.107.76.111]:51743
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbeKLRVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 12:21:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1VCAHZvgi9BRHQ2RHE59GabMNr5piN6aM+mVEMjF4g=;
 b=aQHXyDlDV8uEOGdn6/CbS1zU/Q9vVHx8Nwpz23ogFAJ9XPn7/8T797ycuLaEeV7tlRPVwGzfOpAWCd2SskQIIsdQk6GImE0xSKQ8m4mOpxXzaRbcalowCEv7GC1OhAtCd7wUlReqTNq9OqMhgclkJzoiraU7xK08tDQ5NAKff7g=
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com (10.162.111.23) by
 BY1PR0601MB1126.namprd06.prod.outlook.com (10.160.196.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.29; Mon, 12 Nov 2018 07:29:51 +0000
Received: from BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979]) by BY1PR0601MB1436.namprd06.prod.outlook.com
 ([fe80::199f:c63e:1449:1979%3]) with mapi id 15.20.1294.044; Mon, 12 Nov 2018
 07:29:51 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <Naveen.Gupta@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Subject: [PATCH V2 6/8] brcmfmac: update 43012 F2 watermark setting to fix DMA
 Error during UDP RX Traffic
Thread-Topic: [PATCH V2 6/8] brcmfmac: update 43012 F2 watermark setting to
 fix DMA Error during UDP RX Traffic
Thread-Index: AQHUell/i2NozFkudUaxpNpPaeE67Q==
Date:   Mon, 12 Nov 2018 07:29:51 +0000
Message-ID: <1542007730-47284-7-git-send-email-chi-hsien.lin@cypress.com>
References: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1542007730-47284-1-git-send-email-chi-hsien.lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [12.110.209.245]
x-clientproxiedby: HK0PR03CA0084.apcprd03.prod.outlook.com
 (2603:1096:203:72::24) To BY1PR0601MB1436.namprd06.prod.outlook.com
 (2a01:111:e400:522c::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BY1PR0601MB1126;6:82JajRksKs7gAeNEOe/TMMwyG3mWoNIZlqeObgwWlQcp47xYNtNNTjTkrT35q1WX9NCaxUe8VQykk7ynYLf3i0orw+pDZjslCzuVtfEGp9uULRq37xk9cS9fLWnHBri8cbrLad9tuTSBq1dWnNcUTvGahI1EyGLdr+rDfRLeJDcsgRvEUBX88oWofW4uDugtP6UP1vkKCaHQIbtwM6DvAbL/XJEh+ZEPfyPy2ZOVEawsjAWFn4zwqqMNNwnC6rJCUaFEBMU3Td9xHgh36xZIK/VpTNNX0M/78XYJllDhpLyG03+k+hatHw5TjNsuQrfcv+XK36Vjn89FUWg5SKB0dqlcGbisRqCkiM4Wt+GlSCJOSmIt8Yi4pVWgxZEA3roOzFIjraVm4cDThQb38OR/W+DbgDywoxyFVE5yz7pxVES8pOawkMPJNCwFZaQWoxGJ7mBZWIZO5Wli2zlZyu+tgg==;5:19i7D/45wvGF+LlXxQkimDTLvGr/CKMgBA8T24RP2nCgVsbGZBT0EHI6Qd59t0yCsozMkhu6IOAiqiL4Jm0ZgOPvP81yx9mKUn9XNGNxsui/avtB6MgrNGuOWGr8xazZT3O4ua4RqutffSFtS9Y4qptQJ/d3PcsGQq8d3GbycfY=;7:/WL4cemHYet4DymzJ9wksYy01zem+QtjFfSWzm3dWCuFOQhS8JvwErYOVIWIPNDOFrtXyQTVUx5Ia2HWQHAypESKEFRaM/gz709IqlSUpXN/ANR9NitcDwnek1SYcKqriJ/gscOegsmptRT9miamwg==
x-ms-office365-filtering-correlation-id: d10d04cb-c8d4-43b1-286b-08d64870a1ae
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390040)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:BY1PR0601MB1126;
x-ms-traffictypediagnostic: BY1PR0601MB1126:
x-microsoft-antispam-prvs: <BY1PR0601MB1126EC4ADBBA50477B995E78BBC10@BY1PR0601MB1126.namprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(258095267146985)(208715162771679);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231382)(944501410)(52105112)(93006095)(93001095)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:BY1PR0601MB1126;BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1126;
x-forefront-prvs: 0854128AF0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(39850400004)(136003)(189003)(199004)(25786009)(4326008)(2906002)(76176011)(3846002)(6116002)(99286004)(52116002)(81156014)(81166006)(478600001)(68736007)(8676002)(6486002)(14454004)(66066001)(5640700003)(6436002)(72206003)(8936002)(256004)(386003)(102836004)(6506007)(106356001)(105586002)(54906003)(6916009)(2351001)(86362001)(305945005)(2616005)(5660300001)(36756003)(7736002)(316002)(2900100001)(186003)(71200400001)(446003)(11346002)(476003)(486006)(71190400001)(53936002)(6512007)(2501003)(97736004)(26005)(107886003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1126;H:BY1PR0601MB1436.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: QcxcgEuGONSWKbp+CjB3sl7prX8QNMNfurDc10vQxzNY/JR1GpojX03Zo+rUui29fIDifAOXmwtRvjfmK7qAztwqUrCpNgpUjHkFZRY4YqxnYJzcMXWWSG5+fqraRDnKqUkrOpS/SNa7FD2BSHH7GIhXdZqRSXJw4Z0v66SI+BnH9+Xyh/Fn7ebCUEHCigk8zTH+N2EKTSnDOQig+E1qtyPmzOtf5gW8LEpc1aY9GOj7x7Z5oOQWKf+0RaBEx/NdlOcKJsYjhPECxaWN9WiR5GraplMRzhUFyUOqX8fUzYaFZh8bJrc+LBvGrLU2bgQrCXGpQAK5xrL7dLjXGQL3TkGnoISWk+TPD7JNS/SXHwU=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10d04cb-c8d4-43b1-286b-08d64870a1ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2018 07:29:51.2291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1126
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naveen Gupta <naveen.gupta@cypress.com>

The number of words that the read FIFO has to contain except
the end of frame before sends data back to the host.
Max watermark =3D (512B - 2* (BurstLength))/4 =3D
(512 - 128)/4 =3D 384/4 =3D 0x60
so if burst length (i.e. BurstLength =3D 64) is increased,
watermark has to be reduced. This is the optimal setting for this chip.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Naveen Gupta <naveen.gupta@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 7707b0169c21..e1708e297d07 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -52,6 +52,7 @@
 /* watermark expressed in number of words */
 #define DEFAULT_F2_WATERMARK    0x8
 #define CY_4373_F2_WATERMARK    0x40
+#define CY_43012_F2_WATERMARK    0x60
=20
 #ifdef DEBUG
=20
@@ -4173,6 +4174,17 @@ static void brcmf_sdio_firmware_callback(struct devi=
ce *dev, int err,
 					   CY_4373_F2_WATERMARK |
 					   SBSDIO_MESBUSYCTRL_ENAB, &err);
 			break;
+		case SDIO_DEVICE_ID_CYPRESS_43012:
+			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
+				  CY_43012_F2_WATERMARK);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
+					   CY_43012_F2_WATERMARK, &err);
+			devctl =3D brcmf_sdiod_readb(sdiod, SBSDIO_DEVICE_CTL,
+						   &err);
+			devctl |=3D SBSDIO_DEVCTL_F2WM_ENAB;
+			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
+			break;
 		default:
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
 					   DEFAULT_F2_WATERMARK, &err);
--=20
2.1.0

